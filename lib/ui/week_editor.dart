import '../i18n.dart';
import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'recipe_screen.dart';
import 'sides.dart';
import 'swap_sheet.dart';
import 'theme.dart';
import 'widgets.dart';

/// Every meal of the week on one screen.
class WeekEditor extends StatelessWidget {
  const WeekEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tx('تعديل الأسبوع', 'Edit week')),
        actions: [
          IconButton(
            tooltip: tx('خطة جديدة', 'New plan'),
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => app.generate(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: const [WeekList()],
      ),
    );
  }
}

/// The seven days with swap / lock / delete on every meal.
class WeekList extends StatelessWidget {
  const WeekList({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = app.prefs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Brand.yellow.withValues(alpha: 0.15),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
                tx('⇄ استبدل أي وجبة باقتراحي أو ببحثك أو اكتبها بنفسك · 🔒 قفلها · 🗑 احذفها · اضغط على الوجبة لتشوف الوصفة', '⇄ swap any meal with a suggestion, a search or your own dish · 🔒 lock it · 🗑 delete it · tap a meal to see the recipe')),
          ),
        ),
        for (var day = 0; day < 7; day++)
          FadeSlideIn(
            index: day,
            child: _day(context, app, p, day),
          ),
      ],
    );
  }

  Widget _day(BuildContext context, AppState app, Prefs p, int day) {
    final meals = app.plan.where((m) => m.day == day).toList();
    final macros = dayMacros(app.c, app.plan, day);
    final d = app.dayDate(day);
    return Card(
      margin: const EdgeInsets.only(top: 14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('${dayName(d)} ${d.day}/${d.month}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
              const Spacer(),
              Text(
                  tx('🔥 ${macros.kcal.round()}${p.kcalTarget ? ' / ${p.kcal}' : ''} سعرة', '🔥 ${macros.kcal.round()}${p.kcalTarget ? ' / ${p.kcal}' : ''} kcal'),
                  style: TextStyle(
                      color: Brand.orange, fontWeight: FontWeight.w700)),
            ]),
            const Divider(),
            for (final slot in slotOrder)
              if (p.meals.contains(slot) || meals.any((m) => m.slot == slot))
                _row(context, app, day, slot,
                    meals.where((m) => m.slot == slot).firstOrNull),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, AppState app, int day, String slot,
      PlannedMeal? m) {
    if (m == null) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(child: Icon(Icons.add)),
        title: Text(slotNames[slot]!),
        subtitle: Text(tx('فاضية', 'Empty')),
        trailing: TextButton(
          onPressed: () => showSwapSheet(context, day: day, slot: slot),
          child: Text(tx('أضف', 'Add')),
        ),
      );
    }
    final r = app.c.recipeById[m.recipeId]!;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: FoodTile(r.emoji, size: 42),
      title: Text('${slotNames[slot]} · ${r.title}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (m.leftover) Text(tx('🍱 بواقي من أمس', '🍱 Yesterday’s leftovers')),
          if (partnerOf(app.plan, m) != null) Text(tx('🍲 تكفي يومين', '🍲 Covers two days')),
          MacroRow.of(r),
          SidesRow(meal: m),
        ],
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => RecipeScreen(recipe: r, planned: m))),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          tooltip: tx('استبدال', 'Swap'),
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.swap_horiz),
          onPressed: () =>
              showSwapSheet(context, day: day, slot: slot, meal: m),
        ),
        IconButton(
          tooltip: m.locked ? tx('فك القفل', 'Unlock') : tx('قفل', 'Lock'),
          visualDensity: VisualDensity.compact,
          icon: Icon(m.locked ? Icons.lock : Icons.lock_open,
              color: m.locked ? Brand.green : null),
          onPressed: () => app.toggleLock(m),
        ),
        IconButton(
          tooltip: tx('حذف', 'Delete'),
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.delete_outline),
          onPressed: () => app.removeMeal(m),
        ),
      ]),
    );
  }
}
