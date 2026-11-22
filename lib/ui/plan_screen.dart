import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'pref_editors.dart';
import 'recipe_screen.dart';
import 'swap_sheet.dart';
import 'theme.dart';
import 'week_editor.dart';
import 'widgets.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});
  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  int day = 0;

  Future<void> _regenerate() async {
    final app = AppScope.read(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('خطة جديدة؟'),
        content: const Text(
            'نبني أسبوعاً جديداً من اليوم. الوجبات المقفلة 🔒 تبقى كما هي.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('ابنِ خطة جديدة')),
        ],
      ),
    );
    if (ok != true) return;
    final res = app.generate();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(res.fits
          ? 'خطة جديدة بتكلفة ${fmtMoney(res.total)} ✨'
          : 'الخطة تتجاوز الميزانية: ${fmtMoney(res.total)}'),
    ));
  }

  Future<void> _reset() async {
    final app = AppScope.read(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إعادة ضبط الخطة'),
        content: const Text('بنمسح كل وجبات الأسبوع بما فيها المقفلة.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('امسح')),
        ],
      ),
    );
    if (ok == true) app.resetPlan();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = app.prefs;
    final meals = app.plan.where((m) => m.day == day).toList();
    final macros = dayMacros(app.c, app.plan, day);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace:
            Container(decoration: const BoxDecoration(gradient: Brand.headerGradient)),
        foregroundColor: Colors.white,
        title: const Text('خطة الأسبوع',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22)),
        actions: [
          IconButton(
              tooltip: 'ثلاجتي',
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PrefEditPage(PrefSection.fridge))),
              icon: const Icon(Icons.kitchen_outlined)),
          IconButton(
              tooltip: 'خطة جديدة',
              onPressed: _regenerate,
              icon: const Icon(Icons.auto_awesome)),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'reset') _reset();
              if (v == 'week') {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const WeekEditor()));
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'week', child: Text('تعديل كل الأسبوع')),
              PopupMenuItem(value: 'reset', child: Text('إعادة ضبط الخطة')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          FadeSlideIn(child: BudgetBar(total: app.total, budget: p.budget)),
          const SizedBox(height: 14),
          SizedBox(
            height: 76,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final d = app.dayDate(i);
                final sel = i == day;
                final cs = Theme.of(context).colorScheme;
                return Pressable(
                  onTap: () => setState(() => day = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 64,
                    decoration: BoxDecoration(
                      gradient: sel ? Brand.warmGradient : null,
                      color: sel ? null : cs.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(dayName(d),
                            style: TextStyle(
                                fontSize: 11.5,
                                color: sel ? Colors.white : cs.onSurface)),
                        const SizedBox(height: 2),
                        Text('${d.day}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: sel ? Colors.white : cs.onSurface)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _daySummary(context, app, macros),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey('day$day-${app.plan.length}'),
              children: [
                for (final slot in slotOrder)
                  if (p.meals.contains(slot) ||
                      meals.any((m) => m.slot == slot))
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FadeSlideIn(
                        index: slotOrder.indexOf(slot),
                        child: _slotCard(context, app, slot,
                            meals.where((m) => m.slot == slot).firstOrNull),
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const WeekEditor())),
            icon: const Icon(Icons.edit_calendar),
            label: const Text('تعديل كل وجبات الأسبوع'),
          ),
          if (app.plan.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Column(children: [
                const Text('🗓️', style: TextStyle(fontSize: 56)),
                const SizedBox(height: 8),
                const Text('الخطة فاضية'),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => app.generate(keepLocked: false),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('اصنع خطة الأسبوع'),
                ),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _daySummary(BuildContext context, AppState app, Macros m) {
    final p = app.prefs;
    final d = app.dayDate(day);
    Widget bar(String label, double v, int target, Color c, String unit) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label ${v.round()}${p.kcalTarget ? '/$target' : ''}$unit',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            AnimatedBar(
                value: p.kcalTarget && target > 0 ? v / target : 1,
                color: c,
                height: 6),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${dayName(d)} ${d.day}/${d.month} · للشخص الواحد',
                style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Row(children: [
              bar('🔥', m.kcal, p.kcal, Brand.orange, ''),
              const SizedBox(width: 8),
              bar('بروتين', m.protein, p.protein, Brand.green, 'غ'),
              const SizedBox(width: 8),
              bar('كارب', m.carbs, p.carbs, const Color(0xFFB8860B), 'غ'),
              const SizedBox(width: 8),
              bar('دهون', m.fat, p.fat, const Color(0xFF8D6E63), 'غ'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _slotCard(
      BuildContext context, AppState app, String slot, PlannedMeal? m) {
    final cs = Theme.of(context).colorScheme;
    if (m == null) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: Brand.yellow.withValues(alpha: 0.3),
              child: const Icon(Icons.add)),
          title: Text(slotNames[slot]!),
          subtitle: const Text('خانة فاضية · اضغط لنقترح لك أو تختار'),
          onTap: () => showSwapSheet(context, day: day, slot: slot),
        ),
      );
    }
    final r = app.c.recipeById[m.recipeId]!;
    final cost = app.pricing.costPerServing(r) * m.servings;
    final pot = partnerOf(app.plan, m) != null;
    final hits = app.planner().fridgeHits(r);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => RecipeScreen(recipe: r, planned: m))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Hero(tag: 'r-${r.id}-${m.day}-${m.slot}', child: FoodTile(r.emoji, size: 56)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    runSpacing: 2,
                    children: [
                      Text(slotNames[slot]!,
                          style: TextStyle(
                              color: cs.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12)),
                      if (m.locked) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.lock, size: 14, color: cs.primary),
                      ],
                      if (m.leftover) const _Badge('🍱 بواقي من أمس'),
                      if (pot) const _Badge('🍲 تكفي يومين'),
                      if (hits > 0 && !m.leftover) _Badge('🧊 $hits من ثلاجتك'),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(r.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                      m.leftover
                          ? 'جاهزة، سخّنها بس'
                          : '${r.minutes} دقيقة · ${m.servings} حصص${pot ? ' (لليومين)' : ''} · ${fmtMoney(cost)}',
                      style: Theme.of(context).textTheme.bodySmall),
                  MacroRow.of(r),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                switch (v) {
                  case 'swap':
                    showSwapSheet(context, day: day, slot: slot, meal: m);
                  case 'lock':
                    app.toggleLock(m);
                  case 'remove':
                    app.removeMeal(m);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'swap', child: Text('استبدال')),
                PopupMenuItem(
                    value: 'lock',
                    child: Text(m.locked
                        ? 'فك القفل'
                        : 'قفل (تبقى عند إعادة البناء)')),
                const PopupMenuItem(value: 'remove', child: Text('حذف')),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: Brand.yellow.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }
}
