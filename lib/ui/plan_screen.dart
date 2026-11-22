import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'recipe_screen.dart';
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
          ? 'خطة جديدة بتكلفة ${fmtMoney(res.total)}'
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
    final pr = app.pricing;
    final meals = app.plan.where((m) => m.day == day).toList()
      ..sort((a, b) =>
          slotOrder.indexOf(a.slot).compareTo(slotOrder.indexOf(b.slot)));
    final dayCost = meals.fold<double>(0, (a, m) {
      final r = app.c.recipeById[m.recipeId];
      return r == null ? a : a + pr.costPerServing(r) * m.servings;
    });
    final dayKcal = meals.fold<double>(0, (a, m) {
      final r = app.c.recipeById[m.recipeId];
      return r == null ? a : a + r.kcal;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('خطة الأسبوع'),
        actions: [
          IconButton(
              tooltip: 'خطة جديدة',
              onPressed: _regenerate,
              icon: const Icon(Icons.auto_awesome)),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'reset') _reset();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'reset', child: Text('إعادة ضبط الخطة')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          BudgetBar(total: app.total, budget: app.prefs.budget),
          const SizedBox(height: 14),
          SizedBox(
            height: 74,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final d = app.dayDate(i);
                final sel = i == day;
                final cs = Theme.of(context).colorScheme;
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => setState(() => day = i),
                  child: Container(
                    width: 66,
                    decoration: BoxDecoration(
                      color: sel ? cs.primary : cs.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(dayName(d),
                            style: TextStyle(
                                fontSize: 12,
                                color: sel ? cs.onPrimary : cs.onSurface)),
                        const SizedBox(height: 2),
                        Text('${d.day}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: sel ? cs.onPrimary : cs.onSurface)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
            child: Row(children: [
              Text('${dayName(app.dayDate(day))} ${app.dayDate(day).day}/${app.dayDate(day).month}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('${fmtMoney(dayCost)} · ${dayKcal.round()} سعرة/شخص',
                  style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
          for (final slot in slotOrder)
            if (app.prefs.meals.contains(slot) ||
                meals.any((m) => m.slot == slot))
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _slotCard(context, app, slot,
                    meals.where((m) => m.slot == slot).firstOrNull),
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

  Widget _slotCard(
      BuildContext context, AppState app, String slot, PlannedMeal? m) {
    final cs = Theme.of(context).colorScheme;
    if (m == null) {
      return Card(
        child: ListTile(
          leading: CircleAvatar(
              backgroundColor: cs.surfaceContainerHighest,
              child: const Icon(Icons.add)),
          title: Text(slotNames[slot]!),
          subtitle: const Text('خانة فاضية · اضغط لنقترح لك وجبة'),
          onTap: () => _swap(context, app, null, slot),
        ),
      );
    }
    final r = app.c.recipeById[m.recipeId]!;
    final cost = app.pricing.costPerServing(r) * m.servings;
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
            FoodTile(r.emoji),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(slotNames[slot]!,
                        style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 12)),
                    if (m.locked) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.lock, size: 14, color: cs.primary),
                    ],
                  ]),
                  const SizedBox(height: 2),
                  Text(r.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                      '${r.minutes} دقيقة · ${m.servings} حصص · ${fmtMoney(cost)}',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (v) {
                switch (v) {
                  case 'swap':
                    _swap(context, app, m, slot);
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

  void _swap(
      BuildContext context, AppState app, PlannedMeal? m, String slot) {
    final target = m ??
        PlannedMeal(
            day: day, slot: slot, recipeId: '', servings: app.prefs.people);
    final plan = [...app.plan, if (m == null) target];
    final alts = app.planner().alternatives(plan, target);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _SwapSheet(
        alts: alts,
        currentTotal: m == null ? null : app.total,
        budget: app.prefs.budget,
        onPick: (r) {
          Navigator.pop(ctx);
          if (m == null) {
            app.addMeal(day, slot, r.id);
          } else {
            app.replaceMeal(m, r.id);
          }
        },
      ),
    );
  }
}

class _SwapSheet extends StatefulWidget {
  final List<(Recipe, double)> alts;
  final double? currentTotal;
  final double budget;
  final ValueChanged<Recipe> onPick;
  const _SwapSheet(
      {required this.alts,
      required this.currentTotal,
      required this.budget,
      required this.onPick});
  @override
  State<_SwapSheet> createState() => _SwapSheetState();
}

class _SwapSheetState extends State<_SwapSheet> {
  String q = '';

  @override
  Widget build(BuildContext context) {
    final items = widget.alts
        .where((a) => q.isEmpty || a.$1.title.contains(q))
        .toList();
    final cs = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (_, ctrl) => Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ابحث عن وصفة',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => q = v.trim()),
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('ما فيه بدائل تناسب تفضيلاتك'))
              : ListView.builder(
                  controller: ctrl,
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final (r, total) = items[i];
                    String? delta;
                    Color? color;
                    if (widget.currentTotal != null) {
                      final d = total - widget.currentTotal!;
                      delta = d.abs() < 0.5
                          ? 'نفس التكلفة'
                          : (d > 0
                              ? '+${fmtMoney(d)}'
                              : '−${fmtMoney(-d)}');
                      color = d > 0.5
                          ? cs.error
                          : (d < -0.5 ? Colors.green.shade700 : null);
                    } else if (total > 0) {
                      delta = 'الأسبوع: ${fmtMoney(total)}';
                      color = total > widget.budget ? cs.error : null;
                    }
                    return ListTile(
                      leading: FoodTile(r.emoji, size: 44),
                      title: Text(r.title),
                      subtitle: Text('${r.minutes} دقيقة · ${r.kcal} سعرة'),
                      trailing: delta == null
                          ? null
                          : Text(delta,
                              style: TextStyle(
                                  color: color, fontWeight: FontWeight.w600)),
                      onTap: () => widget.onPick(r),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}
