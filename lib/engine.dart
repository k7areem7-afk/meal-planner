// Pricing, filtering, plan generation and the grocery list.
import 'i18n.dart';
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
  double costPerServing(Recipe r) {
    var t = 0.0;
    for (final l in r.lines) {
      final i = catalog.ingredients[l.ingId];
      if (i == null) continue;
      t += l.b * unitPrice(i);
    }
    return r.servings <= 0 ? 0 : t / r.servings;
  }
}

// ------------------------------------------------------------- filtering

/// [strict] also enforces the "soft" diets (keto, high protein...). The
/// planner relaxes them when nothing fits a slot.
bool recipeAllowed(Recipe r, Prefs p, {String? slot, bool strict = true}) {
  if (slot != null && !r.meals.contains(slot)) return false;
  if (r.allergens.any(p.allergies.contains)) return false;
  if (r.tags.any(p.dislikes.contains)) return false;
  if (!r.appliances.every(p.appliances.contains)) return false;
  for (final d in p.diets) {
    if (!strict && !hardDiets.contains(d)) continue;
    if (!r.diets.contains(d)) return false;
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
  void add(Recipe r, double servings) {
    final f = servings / r.servings;
    for (final l in r.lines) {
      amounts[l.ingId] = (amounts[l.ingId] ?? 0) + l.b * f;
      final list = usedBy.putIfAbsent(l.ingId, () => <String>[]);
      if (!list.contains(r.id)) list.add(r.id);
    }
  }

  for (final m in meals) {
    // Sides are made fresh every day, for the people eating that day.
    final partner = partnerOf(meals, m);
    final eaters = partner == null
        ? m.servings
        : (m.servings - partner.servings).clamp(1, 99).toInt();
    for (final id in m.sides) {
      final s = c.recipeById[id];
      if (s != null) add(s, eaters.toDouble());
    }
    if (m.leftover) continue; // already cooked yesterday
    final r = c.recipeById[m.recipeId];
    if (r == null) continue;
    add(r, m.servings.toDouble());
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
    if (have.contains(g.ing.id)) continue;
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

  List<Recipe> candidates(String slot) {
    final strict =
        c.recipes.where((r) => recipeAllowed(r, p, slot: slot)).toList();
    if (strict.length >= 3) return strict;
    final loose = c.recipes
        .where((r) => recipeAllowed(r, p, slot: slot, strict: false))
        .toList();
    return loose.isEmpty ? strict : loose;
  }

  double _kcalTarget(String slot) {
    final slots = <String>[for (final s in slotOrder) if (p.meals.contains(s)) s];
    final w = slots.fold<double>(0, (a, s) => a + _weight[s]!);
    return w == 0 ? 0 : p.kcal * _weight[slot]! / w;
  }

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
    s += min(2, r.vibes.where(p.vibes.contains).length) * 3;
    if (p.kcalTarget) {
      s -= (r.kcal - _kcalTarget(slot)).abs() / 60;
      if (p.protein >= 100 && r.protein >= 25) s += 1.5;
    }
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
    assignSides(plan);
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

  // ---------------------------------------------------------- sides

  /// Recipes that can be served as [course] (soup, salad, drink, dessert).
  List<Recipe> sideCandidates(String course) => c.recipes
      .where((r) => r.course.contains(course))
      .where((r) => recipeAllowed(r, p, strict: false))
      .toList();

  String? pickSide(List<PlannedMeal> plan, PlannedMeal m, String course) {
    final cands = sideCandidates(course)
        .where((r) => r.id != m.recipeId)
        .toList();
    if (cands.isEmpty) return null;
    double score(Recipe r) {
      var s = -pr.costPerServing(r) * 0.8 + rng.nextDouble() * 4;
      s += min(2, fridgeHits(r)) * 2;
      for (final x in plan) {
        if (!x.sides.contains(r.id)) continue;
        final gap = (x.day - m.day).abs();
        s -= gap == 0 ? 20 : (gap == 1 ? 8 : 2);
      }
      return s;
    }

    final scores = {for (final r in cands) r.id: score(r)};
    cands.sort((a, b) => scores[b.id]!.compareTo(scores[a.id]!));
    final top = cands.take(min(3, cands.length)).toList();
    return top[rng.nextInt(top.length)].id;
  }

  /// Adds the soups, salads, drinks and desserts chosen in preferences.
  void assignSides(List<PlannedMeal> plan) {
    for (final m in plan) {
      if (m.locked && m.sides.isNotEmpty) continue;
      m.sides = [];
      for (final course in const ['soup', 'salad', 'drink', 'dessert']) {
        if (!(p.sides[m.slot]?.contains(course) ?? false)) continue;
        final id = pickSide(plan, m, course);
        if (id != null) m.sides.add(id);
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
  if (v >= 100) return tx('${v.round()} ر.س', 'SAR ${v.round()}');
  return tx('${v.toStringAsFixed(v < 10 ? 2 : 1)} ر.س', 'SAR ${v.toStringAsFixed(v < 10 ? 2 : 1)}');
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
      if (q >= 1000) return tx('${_num(q / 1000)} كغ', '${_num(q / 1000)} kg');
      if (q >= 50) return tx('${(q / 5).round() * 5} غ', '${(q / 5).round() * 5} g');
      return tx('${_num(q)} غ', '${_num(q)} g');
    case 'ml':
      if (q >= 1000) return tx('${_num(q / 1000)} لتر', '${_num(q / 1000)} L');
      return tx('${(q / 5).round() * 5} مل', '${(q / 5).round() * 5} ml');
    case 'tsp':
      return tx('${_frac(q)} ملعقة صغيرة', '${_frac(q)} tsp');
    case 'tbsp':
      return tx('${_frac(q)} ملعقة كبيرة', '${_frac(q)} tbsp');
    case 'cup':
      return tx('${_frac(q)} كوب', '${_frac(q)} cup');
    case 'pc':
      return tx('${_frac(q)} ${i.pcName ?? 'حبة'}', '${_frac(q)} ${i.pcName ?? 'pc'}');
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
      return tx('${_frac(amt)} ${i.pcName ?? 'حبة'}', '${_frac(amt)} ${i.pcName ?? 'pc'}');
  }
}

String fmtPack(double size, Ingredient i) {
  switch (i.unit) {
    case 'g':
      return size >= 1000 ? tx('${_num(size / 1000)} كغ', '${_num(size / 1000)} kg') : tx('${_num(size)} غ', '${_num(size)} g');
    case 'ml':
      return size >= 1000 ? tx('${_num(size / 1000)} لتر', '${_num(size / 1000)} L') : tx('${_num(size)} مل', '${_num(size)} ml');
    default:
      return tx('${_num(size)} ${i.pcName ?? 'حبة'}', '${_num(size)} ${i.pcName ?? 'pc'}');
  }
}

String unitLabel(Ingredient i) =>
    i.unit == 'g' ? tx('غرام', 'grams') : (i.unit == 'ml' ? tx('مل', 'ml') : (i.pcName ?? tx('حبة', 'pc')));

/// Steps keep the amounts in sync with the chosen servings.
String renderStep(String step, Recipe r, double factor, Catalog c) {
  // An Arabic step keeps Arabic names and units even in English mode.
  final saved = L.en;
  if (_arabic.hasMatch(step.replaceAll(RegExp(r'\{\w+\}'), ''))) L.en = false;
  try {
    return _render(step, r, factor, c);
  } finally {
    L.en = saved;
  }
}

final _arabic = RegExp(r'[\u0600-\u06FF]');

String _render(String step, Recipe r, double factor, Catalog c) {
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

// ------------------------------------------------------------- nutrition

class Macros {
  double kcal = 0, protein = 0, carbs = 0, fat = 0;
  void add(Recipe r) {
    kcal += r.kcal;
    protein += r.protein;
    carbs += r.carbs;
    fat += r.fat;
  }
}

/// What one person eats in a day.
Macros dayMacros(Catalog c, List<PlannedMeal> plan, int day) {
  final m = Macros();
  for (final x in plan.where((x) => x.day == day)) {
    final r = c.recipeById[x.recipeId];
    if (r != null) m.add(r);
    for (final id in x.sides) {
      final s = c.recipeById[id];
      if (s != null) m.add(s);
    }
  }
  return m;
}

// ------------------------------------------------------------- from my fridge

class FridgeMatch {
  final Recipe recipe;
  final int have;
  final int total;
  final List<Ingredient> missing;
  FridgeMatch(this.recipe, this.have, this.total, this.missing);
  double get ratio => total == 0 ? 0 : have / total;
}

/// Library recipes ranked by how much of them is already at home.
List<FridgeMatch> matchFridge(Catalog c, Prefs p, {int limit = 5}) {
  final out = <FridgeMatch>[];
  for (final r in c.recipes) {
    if (!recipeAllowed(r, p, strict: false)) continue;
    final main = r.lines
        .map((l) => c.ingredients[l.ingId])
        .whereType<Ingredient>()
        .where((i) => !i.isSpice && !i.pantry)
        .toList();
    if (main.isEmpty) continue;
    final have = main.where((i) => p.fridge.contains(i.id)).length;
    if (have == 0) continue;
    out.add(FridgeMatch(r, have, main.length,
        main.where((i) => !p.fridge.contains(i.id)).toList()));
  }
  out.sort((a, b) {
    final byRatio = b.ratio.compareTo(a.ratio);
    return byRatio != 0 ? byRatio : b.have.compareTo(a.have);
  });
  return out.take(limit).toList();
}

// ------------------------------------------------------------- recipes from AI

const _vol = {'tsp': 5.0, 'tbsp': 15.0, 'cup': 240.0};

/// (amount in base unit, grams) or null when the unit does not fit.
(double, double)? toBase(Ingredient i, double q, String u) {
  final base = i.unit;
  if (u == 'pc') {
    if (base == 'pc') return (q, q * (i.pcWeight ?? 100));
    if (i.pcWeight == null) return null;
    final g = q * i.pcWeight!;
    return (base == 'g' ? g : g / i.density, g);
  }
  if (_vol.containsKey(u)) {
    final ml = q * _vol[u]!;
    if (base == 'ml') return (ml, ml * i.density);
    if (base == 'g') return (ml * i.density, ml * i.density);
    return null;
  }
  if (u == 'g') {
    if (base == 'g') return (q, q);
    if (base == 'ml') return (q / i.density, q);
    if (base == 'pc' && i.pcWeight != null) return (q / i.pcWeight!, q);
    return null;
  }
  if (u == 'ml') {
    if (base == 'ml') return (q, q * i.density);
    if (base == 'g') return (q * i.density, q * i.density);
    return null;
  }
  return null;
}

/// Turns a recipe written by the AI (or the user) into a full recipe:
/// unknown ingredients are dropped, cost and nutrition are computed here.
Recipe? buildRecipe(Map<String, dynamic> j, Catalog c, String id) {
  final title = (j['title'] ?? '').toString().trim();
  if (title.isEmpty) return null;
  final servings = ((j['servings'] as num?)?.toInt() ?? 4).clamp(1, 12).toInt();
  final lines = <RecipeLine>[];
  var kcal = 0.0, prot = 0.0, carb = 0.0, fat = 0.0;
  final allergens = <String>{}, tags = <String>{};
  for (final raw in (j['ingredients'] as List? ?? const [])) {
    if (raw is! Map) continue;
    final ing = c.ingredients[(raw['id'] ?? '').toString()];
    final q = (raw['qty'] as num?)?.toDouble() ?? 0;
    final u = (raw['unit'] ?? '').toString();
    if (ing == null || q <= 0) continue;
    if (lines.any((l) => l.ingId == ing.id)) continue;
    final conv = toBase(ing, q, u);
    if (conv == null) continue;
    lines.add(RecipeLine(ing.id, q, u, conv.$1));
    final g = conv.$2;
    kcal += ing.nutr[0] * g / 100;
    prot += ing.nutr[1] * g / 100;
    carb += ing.nutr[2] * g / 100;
    fat += ing.nutr[3] * g / 100;
    allergens.addAll(ing.allergens);
    tags.addAll(ing.tags);
  }
  final steps = (j['steps'] as List? ?? const [])
      .map((e) => e.toString().trim())
      .where((e) => e.isNotEmpty)
      .toList();
  if (steps.isEmpty) steps.add(tx('حضّر المكونات واطبخها حسب رغبتك.', 'Prepare the ingredients and cook them your way.'));
  final meals = (j['meals'] as List? ?? const ['l', 'd'])
      .map((e) => e.toString())
      .where(slotOrder.contains)
      .toList();
  final minutes = ((j['minutes'] as num?)?.toInt() ?? 30).clamp(5, 300).toInt();
  final ids = lines.map((l) => l.ingId).toSet();
  final k = kcal / servings, pr = prot / servings, cb = carb / servings;
  final fried = steps.any((s) => s.contains('اقل'));
  final diets = <String>[];
  if (!tags.any({'chicken', 'beef', 'lamb', 'liver'}.contains)) {
    diets.add('pescatarian');
    if (!tags.any({'fish', 'seafood'}.contains)) {
      diets.add('vegetarian');
      if (!allergens.any({'dairy', 'eggs'}.contains) && !ids.contains('honey')) {
        diets.add('vegan');
      }
    }
  }
  if (lines.isNotEmpty && cb <= 15) diets.add('keto');
  if (pr >= 25) diets.add('high_protein');
  if (lines.isNotEmpty && k <= 550 && pr >= 15 && !fried) diets.add('glp1');
  if (!fried) diets.add('anti_inflammatory');
  if (ids.contains('olive_oil') && !fried) diets.add('mediterranean');
  return Recipe(
    id: id,
    titleAr: title,
    titleEn: title,
    emoji: _emoji(j['emoji']),
    meals: meals.isEmpty ? ['l', 'd'] : meals,
    styles: (j['styles'] as List? ?? const [])
        .map((e) => e.toString())
        .toList(),
    minutes: minutes,
    appliances: (j['appliances'] as List? ?? const [])
        .map((e) => e.toString())
        .where((a) => a != 'stove')
        .toList(),
    servings: servings,
    lines: lines,
    steps: steps,
    kcal: (j['kcal'] as num?)?.toInt() ?? k.round(),
    protein: double.parse(pr.toStringAsFixed(1)),
    carbs: double.parse(cb.toStringAsFixed(1)),
    fat: double.parse((fat / servings).toStringAsFixed(1)),
    allergens: allergens.toList()..sort(),
    tags: tags.toList()..sort(),
    keeps: j['keeps'] == true,
    fried: fried,
    diets: diets,
    vibes: [if (minutes <= 25) 'quick'],
    user: true,
  );
}

String _emoji(dynamic v) {
  final e = (v ?? '').toString().trim();
  return e.isEmpty || e.length > 8 ? '🍽️' : e;
}
