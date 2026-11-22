// Preference pickers, shared by onboarding and settings.
import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'theme.dart';
import 'widgets.dart';

enum PrefSection {
  store,
  people,
  meals,
  diet,
  cuisine,
  vibe,
  target,
  allergies,
  dislikes,
  appliances,
  fridge,
  budget,
}

const prefTitles = {
  PrefSection.store: ('من وين تتسوق؟', 'نحسب الأسعار التقديرية حسب المتجر'),
  PrefSection.people: ('كم شخص تطبخ لهم؟', 'نضبط الكميات على عددكم'),
  PrefSection.meals: ('أي وجبات تبي نخطط لها؟', 'تقدر تغيّرها بعدين'),
  PrefSection.diet: ('كيف تاكل؟', 'اختار واحد أو أكثر'),
  PrefSection.cuisine: ('وش المطابخ اللي تحبها؟', 'نعطيها الأولوية (اختياري)'),
  PrefSection.vibe: ('وش الجو اللي تبيه؟', 'اختار اللي يناسب يومك'),
  PrefSection.target: ('عندك هدف سعرات؟', 'نختار وجبات قريبة من هدفك'),
  PrefSection.allergies: ('عندكم حساسية من شيء؟', 'نستبعدها تماماً من كل الوصفات'),
  PrefSection.dislikes: ('أشياء ما تحبها', 'ما نقترح وصفات فيها'),
  PrefSection.appliances: ('وش عندك في المطبخ؟', 'نقترح وصفات تقدر تسويها'),
  PrefSection.fridge: ('وش موجود عندك؟',
      'اختار المكونات والبهارات الموجودة. نقدّم الوصفات اللي تستخدمها، وما نحسب سعرها'),
  PrefSection.budget: ('ميزانية الأكل الأسبوعية', 'نبني الخطة وقائمة المشتريات تحتها'),
};

const _exclusive = {'vegetarian', 'vegan', 'pescatarian'};

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
        return OptionGrid(
          aspect: 1.45,
          options: [
            for (final s in app.c.stores) Option(s.id, '🏪', s.name),
          ],
          selected: {prefs.storeId},
          onTap: (id) {
            prefs.storeId = id;
            onChanged();
          },
        );
      case PrefSection.people:
        return Center(
          child: Column(children: [
            Bounce(
                child: Text(
                    prefs.people <= 1
                        ? '🧑'
                        : (prefs.people == 2 ? '👫' : '👨‍👩‍👧‍👦'),
                    style: const TextStyle(fontSize: 70))),
            const SizedBox(height: 12),
            Row(
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
                            ?.copyWith(fontWeight: FontWeight.w800)),
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
          ]),
        );
      case PrefSection.meals:
        return Column(children: [
          for (final (i, s) in slotOrder.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: FadeSlideIn(
                index: i,
                child: OptionCard(
                  horizontal: true,
                  option: Option(s, {'b': '🍳', 'l': '🍛', 'd': '🥗'}[s]!,
                      slotNames[s]!),
                  selected: prefs.meals.contains(s),
                  onTap: () {
                    if (prefs.meals.contains(s) && prefs.meals.length == 1) {
                      return;
                    }
                    _toggle(prefs.meals, s);
                  },
                ),
              ),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: prefs.leftovers,
            onChanged: (v) {
              prefs.leftovers = v;
              onChanged();
            },
            title: const Text('أطبخ مرة وتكفي يومين'),
            subtitle: const Text(
                'للأكلات اللي تصلح تبات في الثلاجة بس، مثل المحاشي والمرق والكبسة. المقلي والسلطات والسمك دايماً طازجة.'),
          ),
        ]);
      case PrefSection.diet:
        return Column(children: [
          OptionCard(
            horizontal: true,
            option: const Option('none', '🍽️', 'بدون قيود', 'آكل كل شيء'),
            selected: prefs.diets.isEmpty,
            onTap: () {
              prefs.diets.clear();
              onChanged();
            },
          ),
          const SizedBox(height: 12),
          OptionGrid(
            options: dietOptions,
            selected: prefs.diets,
            onTap: (id) {
              if (!prefs.diets.contains(id) && _exclusive.contains(id)) {
                prefs.diets.removeAll(_exclusive);
              }
              _toggle(prefs.diets, id);
            },
          ),
        ]);
      case PrefSection.cuisine:
        return OptionGrid(
          options: [
            for (final s in app.c.styles)
              Option(s.id, styleEmoji[s.id] ?? '🍽️', s.name,
                  styleSub[s.id] ?? ''),
          ],
          selected: prefs.styles,
          onTap: (k) => _toggle(prefs.styles, k),
        );
      case PrefSection.vibe:
        return OptionGrid(
          options: vibeOptions,
          selected: prefs.vibes,
          onTap: (k) {
            _toggle(prefs.vibes, k);
            if (k == 'batch' && prefs.vibes.contains('batch')) {
              prefs.leftovers = true;
            }
          },
        );
      case PrefSection.target:
        return _TargetEditor(prefs: prefs, onChanged: onChanged);
      case PrefSection.allergies:
        return OptionGrid(
          aspect: 1.25,
          options: allergyOptions,
          selected: prefs.allergies,
          onTap: (k) => _toggle(prefs.allergies, k),
        );
      case PrefSection.dislikes:
        return OptionGrid(
          aspect: 1.25,
          options: dislikeOptions,
          selected: prefs.dislikes,
          onTap: (k) => _toggle(prefs.dislikes, k),
        );
      case PrefSection.appliances:
        return Column(children: [
          OptionGrid(
            aspect: 1.25,
            options: applianceOptions,
            selected: prefs.appliances,
            onTap: (k) => _toggle(prefs.appliances, k),
          ),
          const SizedBox(height: 8),
          const Text('البوتاجاز والطاسة والحلة نفترض إنها موجودة.',
              style: TextStyle(fontSize: 12)),
        ]);
      case PrefSection.fridge:
        return FridgePicker(prefs: prefs, onChanged: onChanged);
      case PrefSection.budget:
        final meals = 7 * prefs.people * prefs.meals.length;
        final perMeal = meals == 0 ? 0.0 : prefs.budget / meals;
        return Column(children: [
          const Bounce(child: Text('💰', style: TextStyle(fontSize: 60))),
          Text(fmtMoney(prefs.budget),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800, color: cs.primary)),
          const SizedBox(height: 4),
          Text('في الأسبوع', style: Theme.of(context).textTheme.bodyLarge),
          Slider(
            min: 100,
            max: 2500,
            divisions: 96,
            value: prefs.budget.clamp(100.0, 2500.0).toDouble(),
            label: fmtMoney(prefs.budget),
            onChanged: (v) {
              prefs.budget = v;
              onChanged();
            },
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                'يعني تقريباً ${fmtMoney(perMeal)} للوجبة الواحدة لكل شخص '
                '(${prefs.people} × ${prefs.meals.length} وجبات × 7 أيام).',
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

class _TargetEditor extends StatelessWidget {
  final Prefs prefs;
  final VoidCallback onChanged;
  const _TargetEditor({required this.prefs, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget field(String label, int value, String unit, int step,
        void Function(int) set) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(children: [
            Expanded(
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w700))),
            IconButton(
                onPressed: () {
                  set((value - step).clamp(0, 9999).toInt());
                  onChanged();
                },
                icon: const Icon(Icons.remove_circle_outline)),
            InkWell(
              onTap: () async {
                final v = await askNumber(context,
                    title: label, initial: value.toDouble(), suffix: unit);
                if (v != null && v >= 0) {
                  set(v.round());
                  onChanged();
                }
              },
              child: SizedBox(
                width: 80,
                child: Text('$value $unit',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
            IconButton(
                onPressed: () {
                  set(value + step);
                  onChanged();
                },
                icon: const Icon(Icons.add_circle_outline)),
          ]),
        ),
      );
    }

    void preset(int k, int p, int c, int f) {
      prefs
        ..kcal = k
        ..protein = p
        ..carbs = c
        ..fat = f;
      onChanged();
    }

    return Column(children: [
      OptionCard(
        horizontal: true,
        option: const Option('no', '🍴', 'لا، خليها بسيطة',
            'وجبات متوازنة ومشبعة بدون أرقام'),
        selected: !prefs.kcalTarget,
        onTap: () {
          prefs.kcalTarget = false;
          onChanged();
        },
      ),
      const SizedBox(height: 12),
      OptionCard(
        horizontal: true,
        option: const Option('yes', '🏋️', 'نعم، عندي هدف',
            'حدد السعرات والبروتين والكارب والدهون'),
        selected: prefs.kcalTarget,
        onTap: () {
          prefs.kcalTarget = true;
          onChanged();
        },
      ),
      AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        child: !prefs.kcalTarget
            ? const SizedBox(width: double.infinity)
            : Column(children: [
                const SizedBox(height: 16),
                Wrap(spacing: 8, children: [
                  ActionChip(
                      label: const Text('تخسيس'),
                      onPressed: () => preset(1500, 120, 120, 50)),
                  ActionChip(
                      label: const Text('ثبات الوزن'),
                      onPressed: () => preset(2000, 110, 220, 70)),
                  ActionChip(
                      label: const Text('بناء عضل'),
                      onPressed: () => preset(2600, 170, 280, 80)),
                ]),
                const SizedBox(height: 8),
                const Text('الأرقام لكل شخص في اليوم',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                field('السعرات 🔥', prefs.kcal, 'سعرة', 100,
                    (v) => prefs.kcal = v),
                const SizedBox(height: 8),
                field('البروتين', prefs.protein, 'غ', 10,
                    (v) => prefs.protein = v),
                const SizedBox(height: 8),
                field('الكارب', prefs.carbs, 'غ', 10, (v) => prefs.carbs = v),
                const SizedBox(height: 8),
                field('الدهون', prefs.fat, 'غ', 5, (v) => prefs.fat = v),
              ]),
      ),
    ]);
  }
}

// ------------------------------------------------------------- fridge

String ingredientCategory(Ingredient i) {
  if (i.isSpice || i.pantry) return 'spices';
  switch (i.aisle) {
    case 'produce':
      return 'fresh';
    case 'meat':
    case 'seafood':
      return 'meat';
    case 'dairy':
    case 'frozen':
      return 'fridge';
    default:
      return 'pantry';
  }
}

const fridgeFilters = [
  ('all', 'الكل'),
  ('fresh', 'خضار وفواكه'),
  ('meat', 'لحوم وأسماك'),
  ('fridge', 'ثلاجة'),
  ('pantry', 'بقالة'),
  ('spices', 'بهارات وأساسيات'),
];

class FridgePicker extends StatefulWidget {
  final Prefs prefs;
  final VoidCallback onChanged;
  const FridgePicker({super.key, required this.prefs, required this.onChanged});
  @override
  State<FridgePicker> createState() => _FridgePickerState();
}

class _FridgePickerState extends State<FridgePicker> {
  String q = '';
  String filter = 'all';

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final f = widget.prefs.fridge;
    final items = app.c.ingredients.values
        .where((i) => q.isEmpty || i.name.contains(q))
        .where((i) => filter == 'all' || ingredientCategory(i) == filter)
        .toList()
      ..sort((a, b) {
        final ca = fridgeFilters.indexWhere((x) => x.$1 == ingredientCategory(a));
        final cb = fridgeFilters.indexWhere((x) => x.$1 == ingredientCategory(b));
        return ca != cb ? ca.compareTo(cb) : a.name.compareTo(b.name);
      });
    final visibleSelected = items.where((i) => f.contains(i.id)).length;
    final cs = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'ابحث عن مكوّن',
          ),
          onChanged: (v) => setState(() => q = v.trim()),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final (id, name) in fridgeFilters)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  label: Text(name,
                      style: TextStyle(
                          color: filter == id ? Colors.white : null,
                          fontWeight: FontWeight.w600)),
                  selected: filter == id,
                  showCheckmark: false,
                  onSelected: (_) => setState(() => filter = id),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
            child: Text('اخترت ${f.length} · هنا $visibleSelected من ${items.length}',
                style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          TextButton.icon(
            onPressed: () {
              f.addAll(items.map((i) => i.id));
              widget.onChanged();
            },
            icon: const Icon(Icons.done_all, size: 18),
            label: const Text('تحديد الكل'),
          ),
          TextButton(
            onPressed: () {
              f.removeAll(items.map((i) => i.id));
              widget.onChanged();
            },
            child: const Text('إلغاء'),
          ),
        ]),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.92,
          ),
          itemBuilder: (_, idx) {
            final i = items[idx];
            final sel = f.contains(i.id);
            final dark = Theme.of(context).brightness == Brightness.dark;
            return Pressable(
              onTap: () {
                sel ? f.remove(i.id) : f.add(i.id);
                widget.onChanged();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: sel
                      ? Brand.greenLight.withValues(alpha: dark ? 0.25 : 0.15)
                      : (dark ? const Color(0xFF20261A) : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: sel
                          ? Brand.green
                          : cs.outlineVariant.withValues(alpha: 0.6),
                      width: sel ? 2 : 1),
                ),
                child: Stack(children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(i.emoji, style: const TextStyle(fontSize: 34)),
                          const SizedBox(height: 6),
                          Text(i.name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12.5, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    top: 4,
                    end: 4,
                    child: AnimatedScale(
                      scale: sel ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: const Icon(Icons.check_circle,
                          color: Brand.green, size: 20),
                    ),
                  ),
                ]),
              ),
            );
          },
        ),
      ],
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
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
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
