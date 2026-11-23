// Preference pickers, shared by onboarding and settings.
import '../i18n.dart';
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
  sides,
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

Map<PrefSection, (String, String)> get prefTitles => {
  PrefSection.store: (tx('من وين تتسوق؟', 'Where do you shop?'), tx('نحسب الأسعار التقديرية حسب المتجر', 'We estimate prices by store')),
  PrefSection.people: (tx('كم شخص تطبخ لهم؟', 'How many people do you cook for?'), tx('نضبط الكميات على عددكم', 'We scale the amounts for you')),
  PrefSection.meals: (tx('أي وجبات تبي نخطط لها؟', 'Which meals should we plan?'), tx('تقدر تغيّرها بعدين', 'You can change this later')),
  PrefSection.sides: (tx('وش تبي مع كل وجبة؟', 'What would you like with each meal?'),
      tx('شوربة أو سلطة أو مشروب أو تحلية، ونختارها لك كل يوم', 'Soup, salad, drink or dessert, picked for you every day')),
  PrefSection.diet: (tx('كيف تاكل؟', 'How do you eat?'), tx('اختار واحد أو أكثر', 'Pick one or more')),
  PrefSection.cuisine: (tx('وش المطابخ اللي تحبها؟', 'Which cuisines do you like?'), tx('نعطيها الأولوية (اختياري)', 'We give them priority (optional)')),
  PrefSection.vibe: (tx('وش الجو اللي تبيه؟', 'What kind of vibe?'), tx('اختار اللي يناسب يومك', 'Pick what fits your days')),
  PrefSection.target: (tx('عندك هدف سعرات؟', 'Got a calorie target?'), tx('نختار وجبات قريبة من هدفك', 'We pick meals close to your target')),
  PrefSection.allergies: (tx('عندكم حساسية من شيء؟', 'Any allergies?'), tx('نستبعدها تماماً من كل الوصفات', 'We remove them from every recipe')),
  PrefSection.dislikes: (tx('أشياء ما تحبها', 'Things you don’t like'), tx('ما نقترح وصفات فيها', 'We won’t suggest recipes with them')),
  PrefSection.appliances: (tx('وش عندك في المطبخ؟', 'What’s in your kitchen?'), tx('نقترح وصفات تقدر تسويها', 'We suggest recipes you can make')),
  PrefSection.fridge: (tx('وش موجود عندك؟', 'What do you already have?'),
      tx('اختار المكونات والبهارات الموجودة. نقدّم الوصفات اللي تستخدمها، وما نحسب سعرها', 'Pick the ingredients and spices you have. We favor recipes that use them and don’t count their cost')),
  PrefSection.budget: (tx('ميزانية الأكل الأسبوعية', 'Weekly food budget'), tx('نبني الخطة وقائمة المشتريات تحتها', 'We build the plan and shopping list under it')),
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
                    Text(prefs.people == 1 ? tx('شخص', 'person') : tx('أشخاص', 'people')),
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
            title: Text(tx('أطبخ مرة وتكفي يومين', 'Cook once, eat two days')),
            subtitle: Text(
                tx('للأكلات اللي تصلح تبات في الثلاجة بس، مثل المحاشي والمرق والكبسة. المقلي والسلطات والسمك دايماً طازجة.', 'Only for dishes that keep well in the fridge, like mahshi, stews and kabsa. Fried food, salads and fish are always fresh.')),
          ),
        ]);
      case PrefSection.sides:
        return Column(children: [
          for (final slot in slotOrder.where(prefs.meals.contains))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${{'b': '🍳', 'l': '🍛', 'd': '🥗'}[slot]} ${slotNames[slot]}',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final o in sideOptions)
                          FilterChip(
                            label: Text('${o.emoji} ${o.title}'),
                            selected: prefs.sides[slot]?.contains(o.id) ?? false,
                            onSelected: (_) {
                              final set = prefs.sides.putIfAbsent(slot, () => <String>{});
                              set.contains(o.id) ? set.remove(o.id) : set.add(o.id);
                              onChanged();
                            },
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          Text(tx('اتركها فاضية لو ما تبي شيء مع الوجبة.',
              'Leave empty if you want nothing extra.'),
              style: const TextStyle(fontSize: 12)),
        ]);
      case PrefSection.diet:
        return Column(children: [
          OptionCard(
            horizontal: true,
            option: Option('none', '🍽️', tx('بدون قيود', 'No restrictions'), tx('آكل كل شيء', 'Anything goes')),
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
          Text(tx('البوتاجاز والطاسة والحلة نفترض إنها موجودة.', 'We assume you have a stove, a pan and a pot.'),
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
          Text(tx('في الأسبوع', 'per week'), style: Theme.of(context).textTheme.bodyLarge),
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
                tx('يعني تقريباً ${fmtMoney(perMeal)} للوجبة الواحدة لكل شخص ', 'That is about ${fmtMoney(perMeal)} per meal per person ') +
                tx('(${prefs.people} × ${prefs.meals.length} وجبات × 7 أيام).', '(${prefs.people} × ${prefs.meals.length} meals × 7 days).'),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              final v = await askNumber(context,
                  title: tx('الميزانية الأسبوعية', 'Weekly budget'),
                  initial: prefs.budget,
                  suffix: tx('ر.س', 'SAR'));
              if (v != null && v > 0) {
                prefs.budget = v;
                onChanged();
              }
            },
            icon: const Icon(Icons.edit),
            label: Text(tx('اكتب رقماً محدداً', 'Type an exact amount')),
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
        option: Option('no', '🍴', tx('لا، خليها بسيطة', 'No, keep it simple'),
            tx('وجبات متوازنة ومشبعة بدون أرقام', 'Balanced, filling meals. No numbers to track')),
        selected: !prefs.kcalTarget,
        onTap: () {
          prefs.kcalTarget = false;
          onChanged();
        },
      ),
      const SizedBox(height: 12),
      OptionCard(
        horizontal: true,
        option: Option('yes', '🏋️', tx('نعم، عندي هدف', 'Yes, I have a target'),
            tx('حدد السعرات والبروتين والكارب والدهون', 'Set calories, protein, carbs and fat')),
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
                      label: Text(tx('تخسيس', 'Weight loss')),
                      onPressed: () => preset(1500, 120, 120, 50)),
                  ActionChip(
                      label: Text(tx('ثبات الوزن', 'Maintain weight')),
                      onPressed: () => preset(2000, 110, 220, 70)),
                  ActionChip(
                      label: Text(tx('بناء عضل', 'Build muscle')),
                      onPressed: () => preset(2600, 170, 280, 80)),
                ]),
                const SizedBox(height: 8),
                Text(tx('الأرقام لكل شخص في اليوم', 'Numbers are per person per day'),
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 8),
                field(tx('السعرات 🔥', 'Calories 🔥'), prefs.kcal, tx('سعرة', 'kcal'), 100,
                    (v) => prefs.kcal = v),
                const SizedBox(height: 8),
                field(tx('البروتين', 'Protein'), prefs.protein, tx('غ', 'g'), 10,
                    (v) => prefs.protein = v),
                const SizedBox(height: 8),
                field(tx('الكارب', 'Carbs'), prefs.carbs, tx('غ', 'g'), 10, (v) => prefs.carbs = v),
                const SizedBox(height: 8),
                field(tx('الدهون', 'Fat'), prefs.fat, tx('غ', 'g'), 5, (v) => prefs.fat = v),
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

List<(String, String)> get fridgeFilters => [
  ('all', tx('الكل', 'All')),
  ('fresh', tx('خضار وفواكه', 'Fresh')),
  ('meat', tx('لحوم وأسماك', 'Meat & fish')),
  ('fridge', tx('ثلاجة', 'Fridge')),
  ('pantry', tx('بقالة', 'Pantry')),
  ('spices', tx('بهارات وأساسيات', 'Spices & basics')),
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
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: tx('ابحث عن مكوّن', 'Search foods'),
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
            child: Text(tx('اخترت ${f.length} · هنا $visibleSelected من ${items.length}', 'Selected ${f.length} · here $visibleSelected of ${items.length}'),
                style: TextStyle(color: cs.onSurfaceVariant)),
          ),
          TextButton.icon(
            onPressed: () {
              f.addAll(items.map((i) => i.id));
              widget.onChanged();
            },
            icon: const Icon(Icons.done_all, size: 18),
            label: Text(tx('تحديد الكل', 'Select all')),
          ),
          TextButton(
            onPressed: () {
              f.removeAll(items.map((i) => i.id));
              widget.onChanged();
            },
            child: Text(tx('إلغاء', 'Cancel')),
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
                      child: Icon(Icons.check_circle,
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
                  title: Text(tx('تحديث الخطة؟', 'Update the plan?')),
                  content: Text(
                      tx('تبي نعيد بناء خطة الأسبوع على التفضيلات الجديدة؟ الوجبات المقفلة تبقى كما هي.', 'Rebuild this week’s plan with the new preferences? Locked meals stay as they are.')),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(tx('لاحقاً', 'Later'))),
                    FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(tx('أعد البناء', 'Rebuild'))),
                  ],
                ),
              );
              if (regen == true) app.generate();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(tx('حفظ', 'Save')),
          ),
        ),
      ),
    );
  }
}
