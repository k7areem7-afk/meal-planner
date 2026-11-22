import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'recipe_screen.dart';
import 'widgets.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});
  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String q = '';
  String meal = 'all';
  String style = 'all';
  bool onlyMine = true;
  String sort = 'cost';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final pr = app.pricing;
    var list = app.c.recipes.where((r) {
      if (q.isNotEmpty && !r.title.contains(q)) return false;
      if (meal != 'all' && !r.meals.contains(meal)) return false;
      if (style != 'all' && !r.styles.contains(style)) return false;
      if (onlyMine && !recipeAllowed(r, app.prefs)) return false;
      return true;
    }).toList();
    list.sort((a, b) {
      switch (sort) {
        case 'time':
          return a.minutes.compareTo(b.minutes);
        case 'kcal':
          return a.kcal.compareTo(b.kcal);
        case 'protein':
          return b.protein.compareTo(a.protein);
        default:
          return pr.costPerServing(a).compareTo(pr.costPerServing(b));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('الوصفات (${list.length})'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            initialValue: sort,
            onSelected: (v) => setState(() => sort = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'cost', child: Text('الأرخص أولاً')),
              PopupMenuItem(value: 'time', child: Text('الأسرع أولاً')),
              PopupMenuItem(value: 'kcal', child: Text('الأقل سعرات')),
              PopupMenuItem(value: 'protein', child: Text('الأعلى بروتين')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'ابحث: كبسة، شوربة، دجاج...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (v) => setState(() => q = v.trim()),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final e in {'all': 'الكل', ...slotNames}.entries)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(e.value),
                    selected: meal == e.key,
                    onSelected: (_) => setState(() => meal = e.key),
                  ),
                ),
            ]),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              for (final e in {
                'all': 'كل المطابخ',
                for (final s in app.c.styles) s.id: s.name
              }.entries)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    label: Text(e.value),
                    selected: style == e.key,
                    onSelected: (_) => setState(() => style = e.key),
                  ),
                ),
            ]),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('اللي تناسب تفضيلاتي فقط'),
            subtitle: const Text('الحساسية، اللي ما تحبه، الأجهزة، النظام الغذائي'),
            value: onlyMine,
            onChanged: (v) => setState(() => onlyMine = v),
          ),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('ما لقينا وصفات بهذي الفلاتر')),
            ),
          for (final r in list)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: FoodTile(r.emoji, size: 48),
                  title: Text(r.title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipeSubtitle(r, pr.costPerServing(r))),
                      MacroRow.of(r),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: 'أضف للخطة',
                    icon: const Icon(Icons.playlist_add),
                    onPressed: () =>
                        addToPlanDialog(context, r, app.prefs.people),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RecipeScreen(recipe: r))),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
