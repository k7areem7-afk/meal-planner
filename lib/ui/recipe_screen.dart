import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'widgets.dart';

class RecipeScreen extends StatefulWidget {
  final Recipe recipe;
  final PlannedMeal? planned;
  const RecipeScreen({super.key, required this.recipe, this.planned});
  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int? _servings;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final r = widget.recipe;
    final servings =
        _servings ?? widget.planned?.servings ?? app.prefs.people;
    final factor = servings / r.servings;
    final pr = app.pricing;
    final cps = pr.costPerServing(r);
    final cs = Theme.of(context).colorScheme;

    void setServings(int s) {
      s = s.clamp(1, 20);
      setState(() => _servings = s);
      if (widget.planned != null) app.setServings(widget.planned!, s);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.planned == null)
            IconButton(
              tooltip: 'أضف للخطة',
              icon: const Icon(Icons.playlist_add),
              onPressed: () => addToPlanDialog(context, r, servings),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          Center(child: FoodTile(r.emoji, size: 96)),
          const SizedBox(height: 12),
          Text(r.title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(Icons.timer_outlined, '${r.minutes} دقيقة'),
              InfoPill(Icons.payments_outlined, '${fmtMoney(cps)} للحصة'),
              InfoPill(Icons.local_fire_department_outlined,
                  '${r.kcal} سعرة'),
              for (final s in r.styles.take(2))
                InfoPill(Icons.public, app.c.styleName(s)),
              for (final a in r.appliances)
                InfoPill(Icons.kitchen_outlined,
                    applianceNames[a]?.$1 ?? a),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(children: [
                const Icon(Icons.people_outline),
                const SizedBox(width: 8),
                const Text('عدد الحصص'),
                const Spacer(),
                IconButton(
                    onPressed: () => setServings(servings - 1),
                    icon: const Icon(Icons.remove_circle_outline)),
                Text('$servings',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                    onPressed: () => setServings(servings + 1),
                    icon: const Icon(Icons.add_circle_outline)),
              ]),
            ),
          ),
          const SectionTitle('المكونات'),
          Card(
            child: Column(children: [
              for (final l in r.lines)
                Builder(builder: (_) {
                  final ing = app.c.ingredients[l.ingId]!;
                  return ListTile(
                    dense: true,
                    title: Text(ing.name),
                    subtitle: ing.pantry
                        ? const Text('من أساسيات المطبخ')
                        : null,
                    trailing: Text(fmtQty(l.q * factor, l.u, ing),
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  );
                }),
            ]),
          ),
          const SectionTitle('الطريقة'),
          for (var i = 0; i < r.steps.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 14,
                      backgroundColor: cs.primary,
                      child: Text('${i + 1}',
                          style:
                              TextStyle(color: cs.onPrimary, fontSize: 13))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(renderStep(r.steps[i], r, factor, app.c),
                          style: const TextStyle(fontSize: 16, height: 1.6))),
                ],
              ),
            ),
          const SectionTitle('القيمة الغذائية للحصة (تقريبية)'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _nut('سعرات', '${r.kcal}'),
                  _nut('بروتين', '${r.protein.round()} غ'),
                  _nut('كربوهيدرات', '${r.carbs.round()} غ'),
                  _nut('دهون', '${r.fat.round()} غ'),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CookMode(recipe: r, factor: factor))),
        icon: const Icon(Icons.soup_kitchen),
        label: const Text('ابدأ الطبخ'),
      ),
    );
  }

  Widget _nut(String label, String v) => Column(children: [
        Text(v,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ]);
}

Future<void> addToPlanDialog(
    BuildContext context, Recipe r, int servings) async {
  final app = AppScope.read(context);
  var day = 0;
  var slot = r.meals.first;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setD) => AlertDialog(
        title: const Text('أضف للخطة'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField<int>(
            initialValue: day,
            decoration: const InputDecoration(labelText: 'اليوم'),
            items: [
              for (var i = 0; i < 7; i++)
                DropdownMenuItem(
                    value: i,
                    child: Text(
                        '${dayName(app.dayDate(i))} ${app.dayDate(i).day}')),
            ],
            onChanged: (v) => setD(() => day = v ?? 0),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: slot,
            decoration: const InputDecoration(labelText: 'الوجبة'),
            items: [
              for (final s in slotOrder)
                DropdownMenuItem(value: s, child: Text(slotNames[s]!)),
            ],
            onChanged: (v) => setD(() => slot = v ?? slot),
          ),
          const SizedBox(height: 8),
          const Text('إذا كان فيه وجبة في نفس الخانة بنستبدلها.',
              style: TextStyle(fontSize: 12)),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('أضف')),
        ],
      ),
    ),
  );
  if (ok == true) {
    app.addMeal(day, slot, r.id, servings: servings);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'أُضيفت إلى ${slotNames[slot]} يوم ${dayName(app.dayDate(day))}')));
    }
  }
}

// ------------------------------------------------------------- cook mode

class CookMode extends StatefulWidget {
  final Recipe recipe;
  final double factor;
  const CookMode({super.key, required this.recipe, required this.factor});
  @override
  State<CookMode> createState() => _CookModeState();
}

class _CookModeState extends State<CookMode> {
  final ctrl = PageController();
  int page = 0;
  Timer? timer;
  int remaining = 0;

  @override
  void dispose() {
    timer?.cancel();
    ctrl.dispose();
    super.dispose();
  }

  void _startTimer(int minutes) {
    timer?.cancel();
    setState(() => remaining = minutes * 60);
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => remaining--);
      if (remaining <= 0) {
        t.cancel();
        HapticFeedback.heavyImpact();
        SystemSound.play(SystemSoundType.alert);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⏰ انتهى الوقت!')));
      }
    });
  }

  String _mmss(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final r = widget.recipe;
    final n = r.steps.length;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('الخطوة ${page + 1} من $n'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(value: (page + 1) / n),
        ),
      ),
      body: PageView.builder(
        controller: ctrl,
        itemCount: n,
        onPageChanged: (i) => setState(() => page = i),
        itemBuilder: (_, i) {
          final text = renderStep(r.steps[i], r, widget.factor, app.c);
          final mins = stepMinutes(r.steps[i]);
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 26, height: 1.6, fontWeight: FontWeight.w500)),
                const SizedBox(height: 32),
                if (mins != null)
                  timer != null && timer!.isActive
                      ? Text(_mmss(remaining),
                          style: TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.bold,
                              color: cs.primary))
                      : FilledButton.tonalIcon(
                          onPressed: () => _startTimer(mins),
                          icon: const Icon(Icons.timer),
                          label: Text('مؤقت $mins دقيقة'),
                        ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                onPressed: page == 0
                    ? null
                    : () => ctrl.previousPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut),
                child: const Text('السابق'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(52)),
                onPressed: page == n - 1
                    ? () => Navigator.pop(context)
                    : () => ctrl.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut),
                child: Text(page == n - 1 ? 'بالعافية 🎉' : 'التالي'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
