// App state, persistence and the scope widget that exposes it.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

import 'ai.dart';
import 'engine.dart';
import 'i18n.dart';
import 'notify.dart';
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
  List<CustomItem> custom = [];
  bool showPantry = false;
  String geminiKey = '';
  String themeId = 'mango';
  String themeMode = 'system'; // system | light | dark
  String lang = 'ar';
  bool langChosen = false;
  Map<String, List<String>> stepsEn = {}; // AI translations, by recipe id
  NotifSettings notif = NotifSettings();
  String geminiModel = Gemini.defaultModel;
  List<Recipe> userRecipes = [];

  static const dataVersion = 3;

  Gemini? get gemini => geminiKey.trim().isEmpty
      ? null
      : Gemini(geminiKey.trim(),
          geminiModel.trim().isEmpty ? Gemini.defaultModel : geminiModel.trim());

  /// Spices, salt and oil most homes already have.
  Set<String> get basicIds => {
        for (final i in c.ingredients.values)
          if (i.pantry) i.id
      };

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
    userRecipes = ((j['userRecipes'] as List?) ?? [])
        .map((e) => Recipe.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    for (final r in userRecipes) {
      c.register(r);
    }
    geminiKey = (j['geminiKey'] as String?) ?? '';
    themeId = (j['themeId'] as String?) ?? 'mango';
    themeMode = (j['themeMode'] as String?) ?? 'system';
    lang = (j['lang'] as String?) ?? 'ar';
    langChosen = j['langChosen'] == true || j['onboarded'] == true;
    L.en = lang == 'en';
    stepsEn = ((j['stepsEn'] as Map?) ?? {}).map((k, v) =>
        MapEntry(k.toString(), (v as List).map((e) => e.toString()).toList()));
    notif = NotifSettings.fromJson(((j['notif'] as Map?) ?? {}).cast<String, dynamic>());
    geminiModel = (j['geminiModel'] as String?) ?? Gemini.defaultModel;
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
    // v1 kept 'have' outside prefs; it is now the fridge.
    prefs.fridge.addAll(((j['have'] as List?) ?? []).map((e) => e.toString()));
    custom = ((j['custom'] as List?) ?? [])
        .map((e) => CustomItem.fromJson((e as Map).cast<String, dynamic>()))
        .toList();
    showPantry = j['showPantry'] == true;
    // Before v3 spices were assumed to be at home; keep it that way.
    if (((j['v'] as num?)?.toInt() ?? 1) < 3 && onboarded) {
      prefs.fridge.addAll(basicIds);
    }
  }

  Map<String, dynamic> _toJson() => {
        'onboarded': onboarded,
        'prefs': prefs.toJson(),
        'planStart': planStart.toIso8601String(),
        'plan': plan.map((m) => m.toJson()).toList(),
        'overrides': overrides.map((k, v) => MapEntry(k, v.toJson())),
        'checked': checked.toList(),
        'custom': custom.map((e) => e.toJson()).toList(),
        'showPantry': showPantry,
        'v': dataVersion,
        'geminiKey': geminiKey,
        'themeId': themeId,
        'themeMode': themeMode,
        'lang': lang,
        'langChosen': langChosen,
        'stepsEn': stepsEn,
        'notif': notif.toJson(),
        'geminiModel': geminiModel,
        'userRecipes': userRecipes.map((r) => r.toJson()).toList(),
      };

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_key, jsonEncode(_toJson()));
  }

  void _changed() {
    notifyListeners();
    _save();
  }

  /// Plan or reminder settings changed: also refresh scheduled reminders.
  void _planChanged() {
    _changed();
    if (onboarded) Notifier.schedulePlan(this);
  }

  static String _sidesKey(Prefs p) => (p.sides.entries
          .map((e) => '${e.key}:${(e.value.toList()..sort()).join(',')}')
          .toList()
        ..sort())
      .join('|');

  DateTime mealTime(int day, String slot) {
    final t = notif.times[slot] ?? const {'b': 8 * 60, 'l': 14 * 60, 'd': 20 * 60}[slot]!;
    return dayDate(day).add(Duration(minutes: t));
  }

  // ------------------------------------------------------------ plan

  Set<String> get have => prefs.fridge;

  Planner planner([Prefs? p]) =>
      Planner(c, p ?? prefs, Pricing(c, (p ?? prefs).storeId, overrides));

  PlanResult generate({bool keepLocked = true}) {
    final res = planner().generate(keep: keepLocked ? plan : const []);
    plan = res.meals;
    planStart = _today();
    checked.clear();
    _planChanged();
    return res;
  }

  void finishOnboarding(Prefs p) {
    prefs = p;
    onboarded = true;
    generate(keepLocked: false);
  }

  void updatePrefs(Prefs p) {
    final sidesChanged = _sidesKey(prefs) != _sidesKey(p);
    prefs = p;
    if (sidesChanged) planner().assignSides(plan);
    for (final m in plan) {
      if (m.locked) continue;
      m.servings = m.leftover || partnerOf(plan, m) == null
          ? p.people
          : p.people * 2;
    }
    _planChanged();
  }

  void replaceMeal(PlannedMeal m, String recipeId) {
    applyReplace(plan, m, recipeId, c);
    _planChanged();
  }

  void addMeal(int day, String slot, String recipeId, {int? servings}) {
    for (final m in plan.where((m) => m.day == day && m.slot == slot).toList()) {
      applyRemove(plan, m);
    }
    plan.add(PlannedMeal(
        day: day,
        slot: slot,
        recipeId: recipeId,
        servings: servings ?? prefs.people));
    final added = plan.last;
    planner().assignSides([added]);
    _planChanged();
  }

  void removeMeal(PlannedMeal m) {
    applyRemove(plan, m);
    _planChanged();
  }

  void toggleLock(PlannedMeal m) {
    final v = !m.locked;
    m.locked = v;
    partnerOf(plan, m)?.locked = v;
    originalOf(plan, m)?.locked = v;
    _changed();
  }

  void setFridge(Set<String> items) {
    prefs.fridge = items;
    _changed();
  }

  void setServings(PlannedMeal m, int s) {
    m.servings = s.clamp(1, 20).toInt();
    _changed();
  }

  void setSide(PlannedMeal m, int index, String recipeId) {
    if (index < m.sides.length) m.sides[index] = recipeId;
    _changed();
  }

  void removeSide(PlannedMeal m, int index) {
    if (index < m.sides.length) m.sides.removeAt(index);
    _changed();
  }

  void addSide(PlannedMeal m, String recipeId) {
    m.sides.add(recipeId);
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
    final f = prefs.fridge;
    f.contains(id) ? f.remove(id) : f.add(id);
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

  // ------------------------------------------------------------ my recipes

  void saveRecipe(Recipe r) {
    userRecipes.removeWhere((x) => x.id == r.id);
    userRecipes.add(r);
    c.register(r);
    _changed();
  }

  void deleteRecipe(String id) {
    userRecipes.removeWhere((x) => x.id == id);
    plan.removeWhere((m) => m.recipeId == id);
    c.unregister(id);
    _changed();
  }

  bool isSaved(String id) => userRecipes.any((r) => r.id == id);

  void setTheme(String id) {
    themeId = id;
    _changed();
  }

  void setThemeMode(String m) {
    themeMode = m;
    _changed();
  }

  /// Onboarding: show an editable plan before it is approved.
  void startPreview(Prefs p) {
    prefs = p;
    final res = planner().generate();
    plan = res.meals;
    planStart = _today();
    checked.clear();
    notifyListeners();
  }

  void approvePlan() {
    onboarded = true;
    _planChanged();
  }

  /// Preview a language on the first screen without leaving it.
  void setLangDraft(String l) {
    lang = l;
    L.en = l == 'en';
    notifyListeners();
  }

  void setLang(String l) {
    lang = l;
    langChosen = true;
    L.en = l == 'en';
    _changed();
  }

  void setNotif(NotifSettings n) {
    notif = n;
    _planChanged();
  }

  void saveStepsEn(String id, List<String> steps) {
    stepsEn[id] = steps;
    _changed();
  }

  void setAi(String key, String model) {
    geminiKey = key.trim();
    geminiModel = model.trim().isEmpty ? Gemini.defaultModel : model.trim();
    _changed();
  }

  // ------------------------------------------------------------ reset

  Future<void> resetAll() async {
    onboarded = false;
    prefs = Prefs();
    plan = [];
    overrides = {};
    checked = {};
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
