// App state, persistence and the scope widget that exposes it.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'engine.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  static const _key = 'sufra_state_v1';

  Catalog? catalog;
  bool loaded = false;

  bool onboarded = false;
  Prefs prefs = Prefs();
  DateTime planStart = _today();
  List<PlannedMeal> plan = [];
  Map<String, PriceOverride> overrides = {};
  Set<String> checked = {};
  Set<String> have = {};
  List<CustomItem> custom = [];
  bool showPantry = false;

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  Catalog get c => catalog!;
  Pricing get pricing => Pricing(c, prefs.storeId, overrides);

  Future<void> load() async {
    final cat = jsonDecode(await rootBundle.loadString('assets/data/catalog.json'))
        as Map<String, dynamic>;
    final rec = jsonDecode(await rootBundle.loadString('assets/data/recipes.json'))
        as List<dynamic>;
    catalog = Catalog.fromJson(cat, rec);
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString(_key);
      if (raw != null) _fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Corrupt or old data: start fresh rather than crash.
    }
    loaded = true;
    notifyListeners();
  }

  void _fromJson(Map<String, dynamic> j) {
    onboarded = j['onboarded'] == true;
    prefs = Prefs.fromJson((j['prefs'] as Map).cast<String, dynamic>());
    planStart = DateTime.tryParse(j['planStart'] as String? ?? '') ?? _today();
    plan = ((j['plan'] as List?) ?? [])
        .map((e) => PlannedMeal.fromJson((e as Map).cast<String, dynamic>()))
        .where((m) => c.recipeById.containsKey(m.recipeId))
        .toList();
    overrides = ((j['overrides'] as Map?) ?? {}).map((k, v) => MapEntry(
        k as String, PriceOverride.fromJson((v as Map).cast<String, dynamic>())));
    checked = ((j['checked'] as List?) ?? []).map((e) => e.toString()).toSet();
    have = ((j['have'] as List?) ?? []).map((e) => e.toString()).toSet();
    custom = ((j['custom'] as List?) ?? [])
        .map((e) => CustomItem.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    showPantry = j['showPantry'] == true;
  }

  Map<String, dynamic> _toJson() => {
        'onboarded': onboarded,
        'prefs': prefs.toJson(),
        'planStart': planStart.toIso8601String(),
        'plan': plan.map((m) => m.toJson()).toList(),
        'overrides': overrides.map((k, v) => MapEntry(k, v.toJson())),
        'checked': checked.toList(),
        'have': have.toList(),
        'custom': custom.map((e) => e.toJson()).toList(),
        'showPantry': showPantry,
      };

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(_toJson()));
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  // ------------------------------------------------------------ plan

  Planner planner([Prefs? p]) =>
      Planner(c, p ?? prefs, Pricing(c, (p ?? prefs).storeId, overrides),
          have: have);

  PlanResult generate({bool keepLocked = true}) {
    final res = planner().generate(keep: keepLocked ? plan : const []);
    plan = res.meals;
    planStart = _today();
    checked.clear();
    _changed();
    return res;
  }

  void finishOnboarding(Prefs p) {
    prefs = p;
    onboarded = true;
    generate(keepLocked: false);
  }

  void updatePrefs(Prefs p) {
    prefs = p;
    for (final m in plan) {
      if (!m.locked) m.servings = p.people;
    }
    _changed();
  }

  void replaceMeal(PlannedMeal m, String recipeId) {
    m.recipeId = recipeId;
    _changed();
  }

  void addMeal(int day, String slot, String recipeId, {int? servings}) {
    plan.removeWhere((m) => m.day == day && m.slot == slot);
    plan.add(PlannedMeal(
        day: day,
        slot: slot,
        recipeId: recipeId,
        servings: servings ?? prefs.people));
    _changed();
  }

  void removeMeal(PlannedMeal m) {
    plan.remove(m);
    _changed();
  }

  void toggleLock(PlannedMeal m) {
    m.locked = !m.locked;
    _changed();
  }

  void setServings(PlannedMeal m, int s) {
    m.servings = s.clamp(1, 20).toInt();
    _changed();
  }

  void resetPlan() {
    plan = [];
    checked.clear();
    _changed();
  }

  double get total => shoppingTotal(c, pricing, plan, have: have);

  DateTime dayDate(int day) => planStart.add(Duration(days: day));

  // ------------------------------------------------------------ grocery

  void toggleChecked(String id) {
    checked.contains(id) ? checked.remove(id) : checked.add(id);
    _changed();
  }

  void toggleHave(String id) {
    have.contains(id) ? have.remove(id) : have.add(id);
    _changed();
  }

  void setShowPantry(bool v) {
    showPantry = v;
    _changed();
  }

  void addCustom(String name, String note, double price) {
    custom.add(CustomItem(
        id: 'c${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        note: note,
        price: price));
    _changed();
  }

  void removeCustom(CustomItem item) {
    custom.remove(item);
    checked.remove(item.id);
    _changed();
  }

  void clearChecked() {
    checked.clear();
    _changed();
  }

  // ------------------------------------------------------------ prices

  void setPrice(String ingId, double pack, double price) {
    overrides[Pricing.key(prefs.storeId, ingId)] = PriceOverride(pack, price);
    _changed();
  }

  void resetPrice(String ingId) {
    overrides.remove(Pricing.key(prefs.storeId, ingId));
    _changed();
  }

  // ------------------------------------------------------------ reset

  Future<void> resetAll() async {
    onboarded = false;
    prefs = Prefs();
    plan = [];
    overrides = {};
    checked = {};
    have = {};
    custom = [];
    showPantry = false;
    _changed();
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
