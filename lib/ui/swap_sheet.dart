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
        ? 'أضف ${slotNames[widget.slot]}'
        : 'استبدل ${app.c.recipeById[widget.meal!.recipeId]?.title ?? ''}';
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
          const TabBar(tabs: [
            Tab(text: '💡 اقتراحاتنا'),
            Tab(text: '📖 اختار وصفة'),
            Tab(text: '✍️ اكتبها أنت'),
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
      return const Center(child: Text('ما فيه بدائل تناسب تفضيلاتك'));
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
              ? 'نفس التكلفة'
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
                  '${r.minutes} دقيقة',
                  if (hits > 0) '🧊 $hits من ثلاجتك',
                  if (a.inPlan) 'موجودة بيوم ثاني',
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
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ابحث في كل الوصفات: محشي، مكرونة...'),
          onChanged: (v) => setState(() => q = v.trim()),
        ),
      ),
      SwitchListTile(
        dense: true,
        title: Text('وصفات ${slotNames[widget.slot]} فقط'),
        value: onlySlot,
        onChanged: (v) => setState(() => onlySlot = v),
      ),
      Expanded(
        child: list.isEmpty
            ? const Center(child: Text('ما لقينا شيء'))
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
                          const Text('⚠️ ما تناسب تفضيلاتك',
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
      const Text('اكتب اسم الأكلة اللي تبيها، حتى لو مو موجودة عندنا.',
          style: TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 12),
      TextField(
        controller: nameCtrl,
        decoration: const InputDecoration(
            hintText: 'مثلاً: مكرونة بالبشاميل والمشروم'),
      ),
      const SizedBox(height: 10),
      TextField(
        controller: kcalCtrl,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
            hintText: 'السعرات للحصة (اختياري)', suffixText: 'سعرة'),
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
                  if (r == null) throw AiException('ما قدرنا نكتب الوصفة.');
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
            ? 'نكتب الوصفة...'
            : 'اكتب لي الوصفة بالذكاء الاصطناعي'),
      ),
      if (gemini == null)
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(
              'عشان الذكاء الاصطناعي يكتب الوصفة والمكونات والخطوات، أضف مفتاح Gemini من الإعدادات ← الذكاء الاصطناعي.',
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
            'steps': const ['وجبة أضفتها بنفسك.'],
          }, app.c, 'user_${DateTime.now().millisecondsSinceEpoch}');
          if (r == null) return;
          app.saveRecipe(r);
          _pick(r.id);
        },
        icon: const Icon(Icons.add),
        label: const Text('أضفها كاسم بس (بدون وصفة)'),
      ),
    ]);
  }
}
