// Pricing, filtering, plan generation and the grocery list.
import 'dart:math';

import 'models.dart';

class Pricing {
  final Catalog catalog;
  final String storeId;
  final Map<String, PriceOverride> overrides;

  Pricing(this.catalog, this.storeId, this.overrides);

  static String key(String storeId, String ingId) => '$storeId|$ingId';

  PriceOverride? override(String ingId) => overrides[key(storeId, ingId)];

  double packSize(Ingredient i) => override(i.id)?.pack ?? i.pack;

  double packPrice(Ingredient i) {
    final o = override(i.id);
    if (o != null) return o.price;
    return i.price * catalog.store(storeId).factor;
  }

  double unitPrice(Ingredient i) {
    final p = packSize(i);
    return p <= 0 ? 0 : packPrice(i) / p;
  }

  /// Cost per serving, proportional to what the recipe uses.
  double costPerServing(Recipe r, {bool pantry = false}) {
    var t = 0.0;
    for (final l in r.lines) {
      final i = catalog.ingredients[l.ingId]!;
      if (i.pantry && !pantry) continue;
      t += l.b * unitPrice(i);
    }
    return t / r.servings;
  }
}

// ------------------------------------------------------------- filtering

bool recipeAllowed(Recipe r, Prefs p, {String? slot}) {
  if (slot != null && !r.meals.contains(slot)) return false;
  if (r.allergens.any(p.allergies.contains)) return false;
  if (r.tags.any(p.dislikes.contains)) return false;
  if (!r.appliances.every(p.appliances.contains)) return false;
  if (p.diet == 'vegetarian' && r.tags.any(meatTags.contains)) return false;
  final main = slot == null || slot != 'b';
  if (main && p.diet == 'low_carb' && r.carbs > 40 && !r.meals.contains('b')) {
    return false;
  }
  if (main &&
      p.diet == 'high_protein' &&
      r.protein < 22 &&
      !r.meals.contains('b')) {
    return false;
  }
  return true;
}

// ------------------------------------------------------------- grocery

class GroceryLine {
  final Ingredient ing;
  final double amount; // base unit
  final int packs;
  final double cost; // packs * pack price
  final List<String> recipeIds;
  GroceryLine(this.ing, this.amount, this.packs, this.cost, this.recipeIds);
}

Map<String, double> aggregate(
    Catalog c, List<PlannedMeal> meals, Map<String, List<String>> usedBy) {
  final amounts = <String, double>{};
  for (final m in meals) {
    final r = c.recipeById[m.recipeId];
    if (r == null) continue;
    final f = m.servings / r.servings;
    for (final l in r.lines) {
      amounts[l.ingId] = (amounts[l.ingId] ?? 0) + l.b * f;
      final list = usedBy.putIfAbsent(l.ingId, () => <String>[]);
      if (!list.contains(r.id)) list.add(r.id);
    }
  }
  return amounts;
}

List<GroceryLine> groceryLines(
    Catalog c, Pricing pr, List<PlannedMeal> meals) {
  final usedBy = <String, List<String>>{};
  final amounts = aggregate(c, meals, usedBy);
  final out = <GroceryLine>[];
  amounts.forEach((id, amt) {
    final i = c.ingredients[id]!;
    final size = pr.packSize(i);
    final packs = size <= 0 ? 1 : max(1, (amt / size - 1e-6).ceil());
    out.add(GroceryLine(i, amt, packs, packs * pr.packPrice(i), usedBy[id]!));
  });
  return out;
}

/// What you will actually pay at the till: whole packs, without pantry
/// staples and without what you marked as already at home.
double shoppingTotal(Catalog c, Pricing pr, List<PlannedMeal> meals,
    {Set<String> have = const {}}) {
  var t = 0.0;
  for (final g in groceryLines(c, pr, meals)) {
    if (g.ing.pantry || have.contains(g.ing.id)) continue;
    t += g.cost;
  }
  return t;
}

// ------------------------------------------------------------- planner

class PlanResult {
  final List<PlannedMeal> meals;
  final double total;
  final bool fits;
  final List<String> emptySlots;
  PlanResult(this.meals, this.total, this.fits, this.emptySlots);
}

class Planner {
  final Catalog c;
  final Prefs p;
  final Pricing pr;
  final Set<String> have;
  final Random rng;

  Planner(this.c, this.p, this.pr, {this.have = const {}, Random? rng})
      : rng = rng ?? Random();

  static const _weight = {'b': 0.55, 'l': 1.35, 'd': 1.0};

  double _target(String slot) {
    final slots = <String>[for (final s in slotOrder) if (p.meals.contains(s)) s];
    final w = slots.fold<double>(0, (a, s) => a + _weight[s]!);
    if (w == 0) return 0;
    final perDay = p.budget / 7 / max(1, p.people);
    return perDay * _weight[slot]! / w;
  }

  List<Recipe> candidates(String slot) =>
      c.recipes.where((r) => recipeAllowed(r, p, slot: slot)).toList();

  double _score(Recipe r, String slot, int day, List<PlannedMeal> plan) {
    final cost = pr.costPerServing(r);
    final target = _target(slot);
    var s = 0.0;
    // Cheaper than the slot's share is good; much more expensive is bad.
    s -= max(0, cost - target) * 3;
    s -= (cost - target).abs() * 0.4;
    if (p.styles.isNotEmpty && r.styles.any(p.styles.contains)) s += 4;
    final uses = plan.where((m) => m.recipeId == r.id).length;
    s -= uses * 6;
    if (plan.any((m) => m.recipeId == r.id && (m.day - day).abs() <= 1)) {
      s -= 8;
    }
    if (r.minutes <= 30) s += 0.5;
    return s + rng.nextDouble() * 3;
  }

  PlannedMeal _pick(String slot, int day, List<PlannedMeal> plan) {
    final cands = candidates(slot);
    if (cands.isEmpty) {
      return PlannedMeal(day: day, slot: slot, recipeId: '', servings: p.people);
    }
    final scores = {for (final r in cands) r.id: _score(r, slot, day, plan)};
    cands.sort((a, b) => scores[b.id]!.compareTo(scores[a.id]!));
    final top = cands.take(min(4, cands.length)).toList();
    final r = top[rng.nextInt(top.length)];
    return PlannedMeal(day: day, slot: slot, recipeId: r.id, servings: p.people);
  }

  /// Builds a week. Locked meals in [keep] are preserved.
  PlanResult generate({List<PlannedMeal> keep = const []}) {
    final plan = <PlannedMeal>[for (final m in keep) if (m.locked) m.copy()];
    for (var day = 0; day < 7; day++) {
      for (final slot in slotOrder) {
        if (!p.meals.contains(slot)) continue;
        if (plan.any((m) => m.day == day && m.slot == slot)) continue;
        plan.add(_pick(slot, day, plan));
      }
    }
    final empty = <String>[
      for (final m in plan) if (m.recipeId.isEmpty) '${m.day}-${m.slot}'
    ];
    plan.removeWhere((m) => m.recipeId.isEmpty);
    _fitBudget(plan);
    plan.sort((a, b) => a.day != b.day
        ? a.day.compareTo(b.day)
        : slotOrder.indexOf(a.slot).compareTo(slotOrder.indexOf(b.slot)));
    final total = shoppingTotal(c, pr, plan, have: have);
    return PlanResult(plan, total, total <= p.budget + 0.01, empty);
  }

  void _fitBudget(List<PlannedMeal> plan) {
    var total = shoppingTotal(c, pr, plan, have: have);
    var guard = 0;
    final tried = <String>{};
    while (total > p.budget && guard < 80) {
      guard++;
      // Most expensive unlocked meal we have not tried to replace yet.
      final open = plan
          .where((m) => !m.locked && !tried.contains('${m.day}-${m.slot}'))
          .toList();
      if (open.isEmpty) break;
      open.sort((a, b) => pr
          .costPerServing(c.recipeById[b.recipeId]!)
          .compareTo(pr.costPerServing(c.recipeById[a.recipeId]!)));
      final m = open.first;
      tried.add('${m.day}-${m.slot}');
      final current = m.recipeId;
      final options = candidates(m.slot)
          .where((r) =>
              r.id != current &&
              plan.where((x) => x.recipeId == r.id).length < 2)
          .toList();
      String? best;
      var bestTotal = total;
      for (final r in options) {
        m.recipeId = r.id;
        final t = shoppingTotal(c, pr, plan, have: have);
        if (t < bestTotal - 0.5) {
          bestTotal = t;
          best = r.id;
        }
      }
      m.recipeId = best ?? current;
      if (best != null) {
        total = bestTotal;
        tried.clear();
        tried.add('${m.day}-${m.slot}');
      }
    }
  }

  /// Alternatives for one slot, best first, with the weekly total each gives.
  List<(Recipe, double)> alternatives(
      List<PlannedMeal> plan, PlannedMeal target) {
    final out = <(Recipe, double)>[];
    final copy = [for (final m in plan) m.copy()];
    final idx = plan.indexOf(target);
    for (final r in candidates(target.slot)) {
      if (r.id == target.recipeId) continue;
      if (idx >= 0) {
        copy[idx].recipeId = r.id;
        out.add((r, shoppingTotal(c, pr, copy, have: have)));
      } else {
        out.add((r, 0));
      }
    }
    out.sort((a, b) {
      final sa = p.styles.isNotEmpty && a.$1.styles.any(p.styles.contains);
      final sb = p.styles.isNotEmpty && b.$1.styles.any(p.styles.contains);
      if (sa != sb) return sa ? -1 : 1;
      return a.$2.compareTo(b.$2);
    });
    return out;
  }
}

// ------------------------------------------------------------- formatting

String fmtMoney(double v) {
  if (v >= 100) return '${v.round()} ر.س';
  return '${v.toStringAsFixed(v < 10 ? 2 : 1)} ر.س';
}

String _num(double v) {
  if ((v - v.roundToDouble()).abs() < 0.01) return v.round().toString();
  return v.toStringAsFixed(1);
}

String _frac(double v) {
  final q = (v * 4).round() / 4;
  if (q <= 0) return '¼';
  final whole = q.floor();
  final rest = q - whole;
  final quarters = (rest * 4).round();
  final f = quarters == 1
      ? '¼'
      : quarters == 2
          ? '½'
          : quarters == 3
              ? '¾'
              : '';
  if (whole == 0) return f;
  return '$whole$f';
}

String fmtQty(double q, String u, Ingredient i) {
  switch (u) {
    case 'g':
      if (q >= 1000) return '${_num(q / 1000)} كغ';
      if (q >= 50) return '${(q / 5).round() * 5} غ';
      return '${_num(q)} غ';
    case 'ml':
      if (q >= 1000) return '${_num(q / 1000)} لتر';
      return '${(q / 5).round() * 5} مل';
    case 'tsp':
      return '${_frac(q)} ملعقة صغيرة';
    case 'tbsp':
      return '${_frac(q)} ملعقة كبيرة';
    case 'cup':
      return '${_frac(q)} كوب';
    case 'pc':
      return '${_frac(q)} ${i.pcName ?? 'حبة'}';
  }
  return _num(q);
}

/// Amount in the ingredient's base unit, for the shopping list.
String fmtBase(double amt, Ingredient i) {
  switch (i.unit) {
    case 'g':
      return fmtQty(amt, 'g', i);
    case 'ml':
      return fmtQty(amt, 'ml', i);
    default:
      return '${_frac(amt)} ${i.pcName ?? 'حبة'}';
  }
}

String fmtPack(double size, Ingredient i) {
  switch (i.unit) {
    case 'g':
      return size >= 1000 ? '${_num(size / 1000)} كغ' : '${_num(size)} غ';
    case 'ml':
      return size >= 1000 ? '${_num(size / 1000)} لتر' : '${_num(size)} مل';
    default:
      return '${_num(size)} ${i.pcName ?? 'حبة'}';
  }
}

String unitLabel(Ingredient i) =>
    i.unit == 'g' ? 'غرام' : (i.unit == 'ml' ? 'مل' : (i.pcName ?? 'حبة'));

/// Steps keep the amounts in sync with the chosen servings.
String renderStep(String step, Recipe r, double factor, Catalog c) {
  return step.replaceAllMapped(RegExp(r'\{(\w+)\}'), (m) {
    final id = m.group(1)!;
    final line = r.lines.where((l) => l.ingId == id);
    final ing = c.ingredients[id];
    if (line.isEmpty || ing == null) return id;
    return '${ing.name} (${fmtQty(line.first.q * factor, line.first.u, ing)})';
  });
}

int? stepMinutes(String step) {
  final m = RegExp(r'(\d+)\s*(دقيقة|دقائق|د\b)').firstMatch(step);
  if (m != null) return int.tryParse(m.group(1)!);
  if (step.contains('ساعة ونصف')) return 90;
  if (step.contains('ساعة')) return 60;
  return null;
}
