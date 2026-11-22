import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'recipe_screen.dart';
import 'swap_sheet.dart';
import 'theme.dart';
import 'widgets.dart';

/// Every meal of the week on one screen.
class WeekEditor extends StatelessWidget {
  const WeekEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = app.prefs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل الأسبوع'),
        actions: [
          IconButton(
            tooltip: 'خطة جديدة',
            icon: const Icon(Icons.auto_awesome),
            onPressed: () => app.generate(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
        children: [
          const Text(
              'اضغط ⇄ لاستبدال أي وجبة باقتراحنا أو باختيارك، 🔒 لقفلها، أو 🗑 لحذفها.'),
          for (var day = 0; day < 7; day++)
            FadeSlideIn(
              index: day,
              child: _day(context, app, p, day),
            ),
        ],
      ),
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
                  '🔥 ${macros.kcal.round()}${p.kcalTarget ? ' / ${p.kcal}' : ''} سعرة',
                  style: const TextStyle(
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
        subtitle: const Text('فاضية'),
        trailing: TextButton(
          onPressed: () => showSwapSheet(context, day: day, slot: slot),
          child: const Text('أضف'),
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
          if (m.leftover) const Text('🍱 بواقي من أمس'),
          if (partnerOf(app.plan, m) != null) const Text('🍲 تكفي يومين'),
          MacroRow.of(r),
        ],
      ),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => RecipeScreen(recipe: r, planned: m))),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
          tooltip: 'استبدال',
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.swap_horiz),
          onPressed: () =>
              showSwapSheet(context, day: day, slot: slot, meal: m),
        ),
        IconButton(
          tooltip: m.locked ? 'فك القفل' : 'قفل',
          visualDensity: VisualDensity.compact,
          icon: Icon(m.locked ? Icons.lock : Icons.lock_open,
              color: m.locked ? Brand.green : null),
          onPressed: () => app.toggleLock(m),
        ),
        IconButton(
          tooltip: 'حذف',
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.delete_outline),
          onPressed: () => app.removeMeal(m),
        ),
      ]),
    );
  }
}
