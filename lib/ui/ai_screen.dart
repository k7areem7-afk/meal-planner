import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'pref_editors.dart';
import 'recipe_screen.dart';
import 'settings_screen.dart';
import 'theme.dart';
import 'widgets.dart';

/// "What can I cook with what I have?"
class AiScreen extends StatefulWidget {
  const AiScreen({super.key});
  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  int count = 3;
  bool busy = false;
  String? error;
  List<Recipe> results = [];

  Future<void> _ask() async {
    final app = AppScope.read(context);
    final g = app.gemini;
    if (g == null) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final list = await g.fromFridge(app.c, app.prefs, count);
      if (mounted) setState(() => results = list);
    } catch (e) {
      if (mounted) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final mine = app.prefs.fridge
        .map((id) => app.c.ingredients[id])
        .whereType<Ingredient>()
        .where((i) => !i.isSpice && !i.pantry)
        .toList();
    final matches = matchFridge(app.c, app.prefs);
    final g = app.gemini;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: Brand.warmGradient)),
        title: const Text('اقترح لي من الموجود ✨',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Text('🧊', style: TextStyle(fontSize: 26)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text('الموجود عندك (${mine.length})',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const PrefEditPage(PrefSection.fridge))),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('عدّل'),
                    ),
                  ]),
                  const SizedBox(height: 8),
                  if (mine.isEmpty)
                    const Text(
                        'ما اخترت مكونات بعد. اضغط "عدّل" واختار الموجود في ثلاجتك ومطبخك.')
                  else
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final i in mine)
                        Chip(
                          visualDensity: VisualDensity.compact,
                          label: Text('${i.emoji} ${i.name}'),
                        ),
                    ]),
                ],
              ),
            ),
          ),
          const SectionTitle('📖 من مكتبتنا (بدون إنترنت)'),
          if (matches.isEmpty)
            const Text('اختار مكونات أكثر عشان نلقى وصفات تناسبها.')
          else
            for (final (i, m) in matches.indexed)
              FadeSlideIn(
                index: i,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: FoodTile(m.recipe.emoji, size: 48),
                    title: Text(m.recipe.title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        AnimatedBar(value: m.ratio, height: 6),
                        const SizedBox(height: 4),
                        Text(m.missing.isEmpty
                            ? 'عندك كل المكونات ✓'
                            : 'عندك ${m.have} من ${m.total} · ناقصك: ${m.missing.take(4).map((x) => x.name).join('، ')}'),
                        MacroRow.of(m.recipe),
                      ],
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RecipeScreen(recipe: m.recipe))),
                  ),
                ),
              ),
          const SectionTitle('✨ وصفات جديدة بالذكاء الاصطناعي'),
          if (g == null)
            Card(
              color: Brand.yellow.withValues(alpha: 0.15),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        'عشان الذكاء الاصطناعي يكتب لك وصفات جديدة من مكوناتك، يحتاج مفتاح Gemini (مجاني):',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    const Text(
                        '1. افتح aistudio.google.com بحساب قوقل\n2. اضغط Get API key ثم Create API key\n3. انسخ المفتاح والصقه في الإعدادات',
                        style: TextStyle(height: 1.6)),
                    const SizedBox(height: 10),
                    FilledButton.icon(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AiSettingsPage())),
                      icon: const Icon(Icons.key),
                      label: const Text('أضف المفتاح'),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Row(children: [
              const Text('كم وصفة؟'),
              const SizedBox(width: 12),
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(value: 3, label: Text('3')),
                  ButtonSegment(value: 5, label: Text('5')),
                ],
                selected: {count},
                onSelectionChanged: (s) => setState(() => count = s.first),
              ),
            ]),
            const SizedBox(height: 10),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                  backgroundColor: Brand.orange,
                  minimumSize: const Size.fromHeight(54)),
              onPressed: busy || mine.isEmpty ? null : _ask,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.auto_awesome),
              label: Text(busy ? 'نفكر في وصفات لك...' : 'اقترح علي وصفات'),
            ),
            if (busy)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                    child: Bounce(
                        child: Text('🧑‍🍳', style: TextStyle(fontSize: 56)))),
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            for (final (i, r) in results.indexed)
              FadeSlideIn(
                index: i,
                child: Card(
                  margin: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    leading: FoodTile(r.emoji, size: 48),
                    title: Text(r.title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${r.minutes} دقيقة · ${r.lines.length} مكونات'
                            '${app.isSaved(r.id) ? ' · محفوظة ✓' : ''}'),
                        MacroRow.of(r),
                      ],
                    ),
                    trailing: IconButton(
                      tooltip: 'احفظ',
                      icon: Icon(app.isSaved(r.id)
                          ? Icons.bookmark
                          : Icons.bookmark_add_outlined),
                      onPressed: () => app.saveRecipe(r),
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RecipeScreen(recipe: r))),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
