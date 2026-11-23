import '../i18n.dart';
import 'package:flutter/material.dart';

import '../ai.dart';
import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'recipe_screen.dart';
import 'theme.dart';
import 'widgets.dart';

/// Replace (or fill) one slot: our suggestions, any recipe, or your own dish.
Future<void> showSwapSheet(BuildContext context,
    {required int day, required String slot, PlannedMeal? meal}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _SwapSheet(day: day, slot: slot, meal: meal),
  );
}

class _SwapSheet extends StatefulWidget {
  final int day;
  final String slot;
  final PlannedMeal? meal;
  const _SwapSheet({required this.day, required this.slot, this.meal});
  @override
  State<_SwapSheet> createState() => _SwapSheetState();
}

class _SwapSheetState extends State<_SwapSheet> {
  String q = '';
  bool onlySlot = true;
  final nameCtrl = TextEditingController();
  final kcalCtrl = TextEditingController();
  bool busy = false;
  String? error;

  void _pick(String recipeId) {
    final app = AppScope.read(context);
    if (widget.meal == null) {
      app.addMeal(widget.day, widget.slot, recipeId);
    } else {
      app.replaceMeal(widget.meal!, recipeId);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final title = widget.meal == null
        ? tx('أضف ${slotNames[widget.slot]}', 'Add ${slotNames[widget.slot]}')
        : tx('استبدل ${app.c.recipeById[widget.meal!.recipeId]?.title ?? ''}', 'Replace ${app.c.recipeById[widget.meal!.recipeId]?.title ?? ''}');
    return DefaultTabController(
      length: 3,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) => Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          ),
          TabBar(tabs: [
            Tab(text: tx('💡 اقتراحاتنا', '💡 Suggestions')),
            Tab(text: tx('📖 اختار وصفة', '📖 Pick a recipe')),
            Tab(text: tx('✍️ اكتبها أنت', '✍️ Write your own')),
          ]),
          Expanded(
            child: TabBarView(children: [
              _suggestions(app, ctrl),
              _browse(app),
              _custom(app),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _suggestions(AppState app, ScrollController ctrl) {
    final target = widget.meal ??
        PlannedMeal(
            day: widget.day,
            slot: widget.slot,
            recipeId: '',
            servings: app.prefs.people);
    final plan = [...app.plan, if (widget.meal == null) target];
    final alts = app.planner().alternatives(plan, target);
    final current = widget.meal == null ? null : app.total;
    final cs = Theme.of(context).colorScheme;
    if (alts.isEmpty) {
      return Center(child: Text(tx('ما فيه بدائل تناسب تفضيلاتك', 'No alternatives fit your preferences')));
    }
    return ListView.builder(
      controller: ctrl,
      itemCount: alts.length,
      itemBuilder: (_, i) {
        final a = alts[i];
        final r = a.recipe;
        String? delta;
        Color? color;
        if (current != null) {
          final d = a.total - current;
          delta = d.abs() < 0.5
              ? tx('نفس التكلفة', 'Same cost')
              : (d > 0 ? '+${fmtMoney(d)}' : '−${fmtMoney(-d)}');
          color = d > 0.5 ? cs.error : (d < -0.5 ? Brand.green : null);
        }
        final hits = app.planner().fridgeHits(r);
        return FadeSlideIn(
          index: i,
          child: ListTile(
            leading: FoodTile(r.emoji, size: 46),
            title: Text(r.title,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text([
                  tx('${r.minutes} دقيقة', '${r.minutes} min'),
                  if (hits > 0) tx('🧊 $hits من ثلاجتك', '🧊 $hits from your fridge'),
                  if (a.inPlan) tx('موجودة بيوم ثاني', 'On another day'),
                ].join(' · ')),
                MacroRow.of(r),
              ],
            ),
            trailing: delta == null
                ? null
                : Text(delta,
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.w700)),
            onTap: () => _pick(r.id),
          ),
        );
      },
    );
  }

  Widget _browse(AppState app) {
    final list = app.c.recipes
        .where((r) => !onlySlot || r.meals.contains(widget.slot))
        .where((r) => q.isEmpty || r.title.contains(q))
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: tx('ابحث في كل الوصفات: محشي، مكرونة...', 'Search all recipes: mahshi, pasta...')),
          onChanged: (v) => setState(() => q = v.trim()),
        ),
      ),
      SwitchListTile(
        dense: true,
        title: Text(tx('وصفات ${slotNames[widget.slot]} فقط', '${slotNames[widget.slot]} recipes only')),
        value: onlySlot,
        onChanged: (v) => setState(() => onlySlot = v),
      ),
      Expanded(
        child: list.isEmpty
            ? Center(child: Text(tx('ما لقينا شيء', 'Nothing found')))
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final r = list[i];
                  final ok = recipeAllowed(r, app.prefs);
                  return ListTile(
                    leading: FoodTile(r.emoji, size: 42),
                    title: Text(r.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!ok)
                          Text(tx('⚠️ ما تناسب تفضيلاتك', '⚠️ Doesn’t fit your preferences'),
                              style: TextStyle(color: Brand.orange)),
                        MacroRow.of(r),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => RecipeScreen(recipe: r))),
                    ),
                    onTap: () => _pick(r.id),
                  );
                },
              ),
      ),
    ]);
  }

  Widget _custom(AppState app) {
    final gemini = app.gemini;
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text(tx('اكتب اسم الأكلة اللي تبيها، حتى لو مو موجودة عندنا.', 'Type the dish you want, even if it is not in our library.'),
          style: TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      TextField(
        controller: nameCtrl,
        decoration: InputDecoration(
            hintText: tx('مثلاً: مكرونة بالبشاميل والمشروم', 'e.g. béchamel pasta with mushrooms')),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: kcalCtrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: tx('السعرات للحصة (اختياري)', 'Calories per serving (optional)'), suffixText: tx('سعرة', 'kcal')),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        style: FilledButton.styleFrom(
            backgroundColor: Brand.orange,
            minimumSize: const Size.fromHeight(52)),
        onPressed: busy || gemini == null
            ? null
            : () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                setState(() {
                  busy = true;
                  error = null;
                });
                try {
                  final r = await gemini.forDish(app.c, app.prefs, name);
                  if (r == null) throw AiException(tx('ما قدرنا نكتب الوصفة.', 'Could not write the recipe.'));
                  app.saveRecipe(r);
                  if (!mounted) return;
                  _pick(r.id);
                } catch (e) {
                  setState(() => error = e.toString());
                } finally {
                  if (mounted) setState(() => busy = false);
                }
              },
        icon: busy
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.auto_awesome),
        label: Text(busy
            ? tx('نكتب الوصفة...', 'Writing the recipe...')
            : tx('اكتب لي الوصفة بالذكاء الاصطناعي', 'Write the recipe with AI')),
      ),
      if (gemini == null)
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
              tx('عشان الذكاء الاصطناعي يكتب الوصفة والمكونات والخطوات، أضف مفتاح Gemini من الإعدادات ← الذكاء الاصطناعي.', 'For AI to write the recipe, ingredients and steps, add a Gemini key in Settings → AI.'),
              style: TextStyle(fontSize: 12)),
        ),
      if (error != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () {
          final name = nameCtrl.text.trim();
          if (name.isEmpty) return;
          final r = buildRecipe({
            'title': name,
            'emoji': '🍽️',
            'meals': [widget.slot],
            'minutes': 30,
            'servings': 1,
            'kcal': parseNumber(kcalCtrl.text)?.round() ?? 0,
            'ingredients': const [],
            'steps': [tx('وجبة أضفتها بنفسك.', 'A meal you added yourself.')],
          }, app.c, 'user_${DateTime.now().millisecondsSinceEpoch}');
          if (r == null) return;
          app.saveRecipe(r);
          _pick(r.id);
        },
        icon: const Icon(Icons.add),
        label: Text(tx('أضفها كاسم بس (بدون وصفة)', 'Add it as a name only (no recipe)')),
      ),
    ]);
  }
}
