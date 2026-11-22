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
    if (m.leftover) continue; // already cooked yesterday
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

// ------------------------------------------------------------- leftovers

/// The leftover meal that eats from [m]'s pot the next day.
PlannedMeal? partnerOf(List<PlannedMeal> plan, PlannedMeal m) {
  if (m.leftover) return null;
  for (final x in plan) {
    if (x.leftover &&
        x.day == m.day + 1 &&
        x.slot == m.slot &&
        x.recipeId == m.recipeId) {
      return x;
    }
  }
  return null;
}

/// The cooked meal a leftover comes from.
PlannedMeal? originalOf(List<PlannedMeal> plan, PlannedMeal m) {
  if (!m.leftover) return null;
  for (final x in plan) {
    if (!x.leftover &&
        x.day == m.day - 1 &&
        x.slot == m.slot &&
        x.recipeId == m.recipeId) {
      return x;
    }
  }
  return null;
}

/// Replace a meal's recipe and keep leftover links consistent.
void applyReplace(
    List<PlannedMeal> plan, PlannedMeal m, String recipeId, Catalog c) {
  if (m.leftover) {
    final o = originalOf(plan, m);
    if (o != null) o.servings = max(1, o.servings - m.servings);
    m.leftover = false;
    m.recipeId = recipeId;
    return;
  }
  final partner = partnerOf(plan, m);
  if (partner != null) {
    final r = c.recipeById[recipeId];
    if (r != null && r.keeps) {
      partner.recipeId = recipeId;
    } else {
      // The new dish should not sit in the fridge: tomorrow is cooked fresh.
      partner.leftover = false;
      m.servings = max(1, m.servings - partner.servings);
    }
  }
  m.recipeId = recipeId;
}

/// Remove a meal and keep leftover links consistent.
void applyRemove(List<PlannedMeal> plan, PlannedMeal m) {
  if (m.leftover) {
    final o = originalOf(plan, m);
    if (o != null) o.servings = max(1, o.servings - m.servings);
  } else {
    final partner = partnerOf(plan, m);
    if (partner != null) partner.leftover = false;
  }
  plan.remove(m);
}

// ------------------------------------------------------------- planner

class PlanResult {
  final List<PlannedMeal> meals;
  final double total;
  final bool fits;
  final List<String> emptySlots;
  PlanResult(this.meals, this.total, this.fits, this.emptySlots);
}

class Alternative {
  final Recipe recipe;
  final double total; // weekly shopping total if chosen
  final bool inPlan; // already cooked on another (non-adjacent) day
  Alternative(this.recipe, this.total, this.inPlan);
}

class Planner {
  final Catalog c;
  final Prefs p;
  final Pricing pr;
  final Random rng;

  Planner(this.c, this.p, this.pr, {Random? rng}) : rng = rng ?? Random();

  Set<String> get have => p.fridge;

  static const _weight = {'b': 0.55, 'l': 1.35, 'd': 1.0};
  static const maxLeftoverPairs = 3;

  double _target(String slot) {
    final slots = <String>[for (final s in slotOrder) if (p.meals.contains(s)) s];
    final w = slots.fold<double>(0, (a, s) => a + _weight[s]!);
    if (w == 0) return 0;
    final perDay = p.budget / 7 / max(1, p.people);
    return perDay * _weight[slot]! / w;
  }

  List<Recipe> candidates(String slot) =>
      c.recipes.where((r) => recipeAllowed(r, p, slot: slot)).toList();

  /// 0: not in the week yet. 1: elsewhere in the week. 2: yesterday, today
  /// or tomorrow (never allowed unless nothing else fits).
  int conflict(List<PlannedMeal> plan, String id, int day,
      [List<PlannedMeal> except = const []]) {
    var level = 0;
    for (final m in plan) {
      if (m.recipeId != id || except.any((e) => identical(e, m))) continue;
      if ((m.day - day).abs() <= 1) return 2;
      level = 1;
    }
    return level;
  }

  int fridgeHits(Recipe r) => r.lines
      .where((l) =>
          have.contains(l.ingId) && !c.ingredients[l.ingId]!.pantry)
      .length;

  double _score(Recipe r, String slot) {
    final cost = pr.costPerServing(r);
    final target = _target(slot);
    var s = 0.0;
    s -= max(0, cost - target) * 2;
    s -= (cost - target).abs() * 0.3;
    if (p.styles.isNotEmpty && r.styles.any(p.styles.contains)) s += 4;
    s += min(3, fridgeHits(r)) * 2.5; // use what is already in the fridge
    if (r.minutes <= 30) s += 0.5;
    return s + rng.nextDouble() * 4;
  }

  Recipe? _choose(String slot, int day, List<PlannedMeal> plan,
      {bool needKeeps = false}) {
    var cands = candidates(slot);
    if (needKeeps) cands = cands.where((r) => r.keeps).toList();
    for (final level in [0, 1, 2]) {
      final pool = cands
          .where((r) =>
              conflict(plan, r.id, day) <= level &&
              (!needKeeps || conflict(plan, r.id, day + 1) <= level))
          .toList();
      if (level == 2 && needKeeps) return null;
      if (pool.isEmpty) continue;
      final scores = {for (final r in pool) r.id: _score(r, slot)};
      pool.sort((a, b) => scores[b.id]!.compareTo(scores[a.id]!));
      final top = pool.take(min(4, pool.length)).toList();
      return top[rng.nextInt(top.length)];
    }
    return null;
  }

  bool _occupied(List<PlannedMeal> plan, int day, String slot) =>
      plan.any((m) => m.day == day && m.slot == slot);

  /// Builds a week. Locked meals in [keep] are preserved.
  PlanResult generate({List<PlannedMeal> keep = const []}) {
    final plan = <PlannedMeal>[for (final m in keep) if (m.locked) m.copy()];
    // A locked leftover without its locked pot becomes a normal meal.
    for (final m in plan.where((m) => m.leftover).toList()) {
      if (originalOf(plan, m) == null) m.leftover = false;
    }
    final empty = <String>[];
    var pairs = 0;
    for (var day = 0; day < 7; day++) {
      for (final slot in slotOrder) {
        if (!p.meals.contains(slot) || _occupied(plan, day, slot)) continue;
        final tryPair = p.leftovers &&
            slot != 'b' &&
            pairs < maxLeftoverPairs &&
            day < 6 &&
            !_occupied(plan, day + 1, slot) &&
            rng.nextDouble() < 0.45;
        if (tryPair) {
          final r = _choose(slot, day, plan, needKeeps: true);
          if (r != null) {
            plan.add(PlannedMeal(
                day: day, slot: slot, recipeId: r.id, servings: p.people * 2));
            plan.add(PlannedMeal(
                day: day + 1,
                slot: slot,
                recipeId: r.id,
                servings: p.people,
                leftover: true));
            pairs++;
            continue;
          }
        }
        final r = _choose(slot, day, plan);
        if (r == null) {
          empty.add('$day-$slot');
        } else {
          plan.add(PlannedMeal(
              day: day, slot: slot, recipeId: r.id, servings: p.people));
        }
      }
    }
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
    final tried = <PlannedMeal>{};
    while (total > p.budget && guard < 120) {
      guard++;
      final open = plan
          .where((m) => !m.locked && !m.leftover && !tried.contains(m))
          .toList();
      if (open.isEmpty) break;
      double mealCost(PlannedMeal m) =>
          pr.costPerServing(c.recipeById[m.recipeId]!) * m.servings;
      open.sort((a, b) => mealCost(b).compareTo(mealCost(a)));
      final m = open.first;
      tried.add(m);
      final partner = partnerOf(plan, m);
      final except = [m, if (partner != null) partner];
      final current = m.recipeId;
      final options = candidates(m.slot).where((r) =>
          r.id != current &&
          (partner == null || r.keeps) &&
          conflict(plan, r.id, m.day, except) == 0 &&
          (partner == null || conflict(plan, r.id, m.day + 1, except) == 0));
      String? best;
      var bestTotal = total;
      for (final r in options) {
        m.recipeId = r.id;
        partner?.recipeId = r.id;
        final t = shoppingTotal(c, pr, plan, have: have);
        if (t < bestTotal - 0.5) {
          bestTotal = t;
          best = r.id;
        }
      }
      m.recipeId = best ?? current;
      partner?.recipeId = best ?? current;
      if (best != null) {
        total = bestTotal;
        tried
          ..clear()
          ..add(m);
      }
    }
  }

  /// Alternatives for one slot (never yesterday's or tomorrow's dish).
  List<Alternative> alternatives(List<PlannedMeal> plan, PlannedMeal target) {
    final out = <Alternative>[];
    final idx = plan.indexOf(target);
    final partner = idx >= 0 ? partnerOf(plan, target) : null;
    final original = idx >= 0 ? originalOf(plan, target) : null;
    final except = [
      target,
      if (partner != null) partner,
      if (original != null) original,
    ];
    for (final r in candidates(target.slot)) {
      if (r.id == target.recipeId) continue;
      final level = conflict(plan, r.id, target.day, except);
      if (level == 2) continue;
      var total = 0.0;
      if (idx >= 0) {
        final copy = [for (final m in plan) m.copy()];
        applyReplace(copy, copy[idx], r.id, c);
        total = shoppingTotal(c, pr, copy, have: have);
      }
      out.add(Alternative(r, total, level == 1));
    }
    out.sort((a, b) {
      if (a.inPlan != b.inPlan) return a.inPlan ? 1 : -1;
      final fa = fridgeHits(a.recipe), fb = fridgeHits(b.recipe);
      if (fa != fb) return fb.compareTo(fa);
      final sa = p.styles.isNotEmpty && a.recipe.styles.any(p.styles.contains);
      final sb = p.styles.isNotEmpty && b.recipe.styles.any(p.styles.contains);
      if (sa != sb) return sa ? -1 : 1;
      return a.total.compareTo(b.total);
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
