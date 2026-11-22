// Preference pickers, shared by onboarding and settings.
import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'widgets.dart';

enum PrefSection {
  store,
  people,
  meals,
  diet,
  styles,
  allergies,
  dislikes,
  appliances,
  budget,
}

const prefTitles = {
  PrefSection.store: ('من وين تتسوق؟', 'نحسب الأسعار التقديرية حسب المتجر'),
  PrefSection.people: ('كم شخص تطبخ لهم؟', 'نضبط الكميات على عددكم'),
  PrefSection.meals: ('أي وجبات تبي نخطط لها؟', 'تقدر تغيّرها بعدين'),
  PrefSection.diet: ('نظامك الغذائي', 'نستبعد الوصفات اللي ما تناسبه'),
  PrefSection.styles: ('وش تحب تاكل؟', 'نعطي الأولوية لهذي المطابخ (اختياري)'),
  PrefSection.allergies: ('عندكم حساسية من شيء؟', 'نستبعدها تماماً من كل الوصفات'),
  PrefSection.dislikes: ('أشياء ما تحبها', 'ما نقترح وصفات فيها'),
  PrefSection.appliances: ('وش عندك في المطبخ؟', 'نقترح وصفات تقدر تسويها'),
  PrefSection.budget: ('ميزانية الأكل الأسبوعية', 'نبني الخطة وقائمة المشتريات تحتها'),
};

class PrefEditor extends StatelessWidget {
  final PrefSection section;
  final Prefs prefs;
  final VoidCallback onChanged;
  const PrefEditor(
      {super.key,
      required this.section,
      required this.prefs,
      required this.onChanged});

  void _toggle(Set<String> s, String k) {
    s.contains(k) ? s.remove(k) : s.add(k);
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cs = Theme.of(context).colorScheme;
    switch (section) {
      case PrefSection.store:
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.4,
          children: [
            for (final s in app.c.stores)
              _SelectTile(
                selected: prefs.storeId == s.id,
                onTap: () {
                  prefs.storeId = s.id;
                  onChanged();
                },
                child: Text(s.name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600)),
              ),
          ],
        );
      case PrefSection.people:
        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton.filledTonal(
                iconSize: 32,
                onPressed: prefs.people > 1
                    ? () {
                        prefs.people--;
                        onChanged();
                      }
                    : null,
                icon: const Icon(Icons.remove),
              ),
              SizedBox(
                width: 110,
                child: Column(children: [
                  Text('${prefs.people}',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text(prefs.people == 1 ? 'شخص' : 'أشخاص'),
                ]),
              ),
              IconButton.filledTonal(
                iconSize: 32,
                onPressed: prefs.people < 15
                    ? () {
                        prefs.people++;
                        onChanged();
                      }
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        );
      case PrefSection.meals:
        return Column(children: [
          for (final s in slotOrder)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectTile(
                selected: prefs.meals.contains(s),
                onTap: () {
                  if (prefs.meals.contains(s) && prefs.meals.length == 1) {
                    return;
                  }
                  _toggle(prefs.meals, s);
                },
                child: Row(children: [
                  Text({'b': '🍳', 'l': '🍛', 'd': '🥗'}[s]!,
                      style: const TextStyle(fontSize: 26)),
                  const SizedBox(width: 12),
                  Text(slotNames[s]!,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
        ]);
      case PrefSection.diet:
        return Column(children: [
          for (final e in dietNames.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SelectTile(
                selected: prefs.diet == e.key,
                onTap: () {
                  prefs.diet = e.key;
                  onChanged();
                },
                child: Text(e.value,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
        ]);
      case PrefSection.styles:
        return ChoiceChips(
          options: {for (final s in app.c.styles) s.id: s.name},
          selected: prefs.styles,
          onTap: (k) => _toggle(prefs.styles, k),
        );
      case PrefSection.allergies:
        return ChoiceChips(
          options: allergyNames,
          selected: prefs.allergies,
          onTap: (k) => _toggle(prefs.allergies, k),
        );
      case PrefSection.dislikes:
        return ChoiceChips(
          options: dislikeNames,
          selected: prefs.dislikes,
          onTap: (k) => _toggle(prefs.dislikes, k),
        );
      case PrefSection.appliances:
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            for (final e in applianceNames.entries)
              _SelectTile(
                selected: prefs.appliances.contains(e.key),
                onTap: () => _toggle(prefs.appliances, e.key),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(e.value.$2, style: const TextStyle(fontSize: 30)),
                    const SizedBox(height: 4),
                    Text(e.value.$1,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
          ],
        );
      case PrefSection.budget:
        final meals = 7 * prefs.people * prefs.meals.length;
        final perMeal = meals == 0 ? 0.0 : prefs.budget / meals;
        return Column(children: [
          Text(fmtMoney(prefs.budget),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold, color: cs.primary)),
          const SizedBox(height: 4),
          Text('في الأسبوع', style: Theme.of(context).textTheme.bodyLarge),
          Slider(
            min: 100,
            max: 2500,
            divisions: 96,
            value: prefs.budget.clamp(100, 2500),
            label: fmtMoney(prefs.budget),
            onChanged: (v) {
              prefs.budget = v;
              onChanged();
            },
          ),
          const SizedBox(height: 8),
          Card(
            color: cs.surfaceContainerHigh,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'يعني تقريباً ${fmtMoney(perMeal)} للوجبة الواحدة لكل شخص '
                '(${prefs.people} ${prefs.people == 1 ? 'شخص' : 'أشخاص'} × '
                '${prefs.meals.length} وجبات × 7 أيام).',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final v = await askNumber(context,
                  title: 'الميزانية الأسبوعية',
                  initial: prefs.budget,
                  suffix: 'ر.س');
              if (v != null && v > 0) {
                prefs.budget = v;
                onChanged();
              }
            },
            icon: const Icon(Icons.edit),
            label: const Text('اكتب رقماً محدداً'),
          ),
        ]);
    }
  }
}

class _SelectTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final Widget child;
  const _SelectTile(
      {required this.selected, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            Expanded(child: child),
            if (selected) Icon(Icons.check_circle, color: cs.primary),
          ]),
        ),
      ),
    );
  }
}

/// Settings page that edits one section.
class PrefEditPage extends StatefulWidget {
  final PrefSection section;
  const PrefEditPage(this.section, {super.key});
  @override
  State<PrefEditPage> createState() => _PrefEditPageState();
}

class _PrefEditPageState extends State<PrefEditPage> {
  Prefs? _p;
  Prefs get p => _p!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _p ??= AppScope.read(context).prefs.copy();
  }

  @override
  Widget build(BuildContext context) {
    final t = prefTitles[widget.section]!;
    return Scaffold(
      appBar: AppBar(title: Text(t.$1)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(t.$2, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        PrefEditor(
            section: widget.section, prefs: p, onChanged: () => setState(() {})),
      ]),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
            onPressed: () async {
              final app = AppScope.read(context);
              app.updatePrefs(p);
              final regen = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('تحديث الخطة؟'),
                  content: const Text(
                      'تبي نعيد بناء خطة الأسبوع على التفضيلات الجديدة؟ الوجبات المقفلة تبقى كما هي.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('لاحقاً')),
                    FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('أعد البناء')),
                  ],
                ),
              );
              if (regen == true) app.generate();
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ),
      ),
    );
  }
}
