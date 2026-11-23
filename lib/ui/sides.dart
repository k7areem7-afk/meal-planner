import 'package:flutter/material.dart';

import '../i18n.dart';
import '../models.dart';
import '../state.dart';
import 'recipe_screen.dart';
import 'widgets.dart';

/// Soup / salad / drink / dessert served with a meal.
class SidesRow extends StatelessWidget {
  final PlannedMeal meal;
  const SidesRow({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (meal.sides.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(spacing: 6, runSpacing: 6, children: [
        for (var i = 0; i < meal.sides.length; i++)
          if (app.c.recipeById[meal.sides[i]] case final r?)
            InputChip(
              visualDensity: VisualDensity.compact,
              avatar: Text(r.emoji),
              label: Text(r.title, style: const TextStyle(fontSize: 12)),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => RecipeScreen(recipe: r))),
              deleteIcon: const Icon(Icons.swap_horiz, size: 18),
              onDeleted: () => showSideSheet(context, meal, i),
            ),
      ]),
    );
  }
}

String sideCourse(AppState app, PlannedMeal m, Recipe r) {
  final wanted = app.prefs.sides[m.slot] ?? const <String>{};
  for (final c in r.course) {
    if (wanted.contains(c)) return c;
  }
  return r.course.isEmpty ? 'salad' : r.course.first;
}

Future<void> showSideSheet(BuildContext context, PlannedMeal m, int index) {
  final app = AppScope.read(context);
  final current = app.c.recipeById[m.sides[index]];
  if (current == null) return Future.value();
  final course = sideCourse(app, m, current);
  final options = app.planner().sideCandidates(course)
    ..removeWhere((r) => r.id == current.id)
    ..sort((a, b) => a.title.compareTo(b.title));
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, ctrl) => ListView(
        controller: ctrl,
        children: [
          ListTile(
            title: Text(
                tx('استبدل ${current.title}', 'Replace ${current.title}'),
                style: const TextStyle(fontWeight: FontWeight.w800)),
            trailing: TextButton.icon(
              onPressed: () {
                app.removeSide(m, index);
                Navigator.pop(ctx);
              },
              icon: const Icon(Icons.delete_outline),
              label: Text(tx('شيلها', 'Remove')),
            ),
          ),
          for (final r in options)
            ListTile(
              leading: FoodTile(r.emoji, size: 40),
              title: Text(r.title),
              subtitle: MacroRow.of(r),
              onTap: () {
                app.setSide(m, index, r.id);
                Navigator.pop(ctx);
              },
            ),
        ],
      ),
    ),
  );
}
