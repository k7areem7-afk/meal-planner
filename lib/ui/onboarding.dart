import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'pref_editors.dart';
import 'theme.dart';
import 'widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final prefs = Prefs();
  int step = 0; // 0 welcome, 1..n sections, n+1 preview
  PlanResult? preview;
  bool _init = false;

  static const sections = PrefSection.values;
  int get last => sections.length + 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_init) {
      _init = true;
      // Most homes already have salt, oil and basic spices.
      prefs.fridge.addAll(AppScope.read(context).basicIds);
    }
  }

  void _next() {
    if (step == sections.length) {
      final app = AppScope.read(context);
      setState(() {
        preview = app.planner(prefs).generate();
        step++;
      });
      return;
    }
    setState(() => step++);
  }

  void _back() => setState(() => step = (step - 1).clamp(0, last).toInt());

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, a) => FadeTransition(
        opacity: a,
        child: SlideTransition(
          position: Tween(begin: const Offset(0.06, 0), end: Offset.zero)
              .animate(a),
          child: child,
        ),
      ),
      child: KeyedSubtree(
        key: ValueKey(step),
        child: step == 0
            ? _welcome()
            : (step == last ? _preview() : _section(sections[step - 1])),
      ),
    );
  }

  Widget _section(PrefSection sec) {
    final t = prefTitles[sec]!;
    final optional = const {
      PrefSection.cuisine,
      PrefSection.vibe,
      PrefSection.allergies,
      PrefSection.dislikes,
      PrefSection.fridge,
    }.contains(sec);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(6),
          child: IconButton.filledTonal(
              onPressed: _back,
              icon: const Icon(Icons.arrow_back_ios_new, size: 18)),
        ),
        title: AnimatedBar(value: step / sections.length, height: 8),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          FadeSlideIn(
            child: Text(t.$1,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 6),
          FadeSlideIn(
            index: 1,
            child: Text(t.$2, style: Theme.of(context).textTheme.bodyLarge),
          ),
          const SizedBox(height: 22),
          PrefEditor(
              section: sec, prefs: prefs, onChanged: () => setState(() {})),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: _next,
            child: Text(step == sections.length
                ? 'اصنع خطتي ✨'
                : (optional ? 'التالي (أو تخطَّ)' : 'التالي')),
          ),
        ),
      ),
    );
  }

  Widget _welcome() {
    const bullets = [
      ('💰', 'خطة أسبوعية حسب ميزانيتك'),
      ('🧊', 'تستخدم الموجود في ثلاجتك'),
      ('👩‍🍳', 'شرح طبخ للمبتدئين خطوة بخطوة'),
      ('✨', 'وصفات بالذكاء الاصطناعي من مكوناتك'),
    ];
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: Brand.headerGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const Bounce(
                    child: Text('🍽️', style: TextStyle(fontSize: 96))),
                const SizedBox(height: 12),
                const FadeSlideIn(
                  child: Text('سفرة',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                ),
                const SizedBox(height: 10),
                const FadeSlideIn(
                  index: 1,
                  child: Text(
                    'حدد ميزانيتك والموجود عندك، ونطلع لك أسبوع وجبات كامل\nمع قائمة مشتريات وطريقة طبخ خطوة بخطوة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: Colors.white, height: 1.5),
                  ),
                ),
                const Spacer(),
                for (var i = 0; i < bullets.length; i++)
                  FadeSlideIn(
                    index: i + 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(children: [
                        Text(bullets[i].$1,
                            style: const TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Text(bullets[i].$2,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),
                      ]),
                    ),
                  ),
                const SizedBox(height: 24),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Brand.greenDark,
                      minimumSize: const Size.fromHeight(56)),
                  onPressed: _next,
                  child: const Text('ابدأ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _preview() {
    final app = AppScope.of(context);
    final res = preview!;
    final pr = app.planner(prefs).pr;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _back, icon: const Icon(Icons.arrow_back_rounded)),
        title: const Text('خطتك جاهزة 🎉'),
        actions: [
          IconButton(
            tooltip: 'خطة ثانية',
            onPressed: () =>
                setState(() => preview = app.planner(prefs).generate()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BudgetBar(total: res.total, budget: prefs.budget),
          if (!res.fits)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'ما قدرنا ننزل تحت الميزانية بالكامل مع تفضيلاتك. جرّب ترفع الميزانية أو تقلل الاستبعادات، أو استبدل وجبات بنفسك.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          for (var day = 0; day < 7; day++) ...[
            SectionTitle(dayName(DateTime.now().add(Duration(days: day)))),
            for (final m in res.meals.where((m) => m.day == day))
              FadeSlideIn(
                index: slotOrder.indexOf(m.slot),
                child: Builder(builder: (_) {
                  final r = app.c.recipeById[m.recipeId]!;
                  final pot = partnerOf(res.meals, m) != null;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: FoodTile(r.emoji, size: 44),
                    title: Text(r.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.leftover
                            ? '${slotNames[m.slot]} · بواقي من أمس 🍱'
                            : '${slotNames[m.slot]} · ${fmtMoney(pr.costPerServing(r) * m.servings)}${pot ? ' · تكفي يومين' : ''}'),
                        MacroRow.of(r),
                      ],
                    ),
                  );
                }),
              ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: () {
              final app = AppScope.read(context);
              app.prefs = prefs;
              app.onboarded = true;
              app.plan = res.meals;
              app.planStart = DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day);
              app.updatePrefs(prefs);
            },
            child: const Text('اعتمد الخطة'),
          ),
        ),
      ),
    );
  }
}
