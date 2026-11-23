import '../i18n.dart';
import 'package:flutter/material.dart';

import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'pref_editors.dart';
import 'colors_page.dart';
import 'theme.dart';
import 'week_editor.dart';
import 'widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final prefs = Prefs();
  int step = 0; // 0 welcome, 1..n sections, n+1 preview
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
      AppScope.read(context).startPreview(prefs);
      setState(() => step++);
      return;
    }
    setState(() => step++);
  }

  void _back() => setState(() => step = (step - 1).clamp(0, last).toInt());

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (!app.langChosen) return _language(app);
    return PopScope(
      canPop: step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: _switcher(),
    );
  }

  Widget _language(AppState app) {
    Widget card(String code, String flag, String title, String sub) {
      final sel = app.lang == code;
      return Pressable(
        onTap: () => app.setLangDraft(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: sel ? Brand.green : Colors.black12, width: sel ? 2.5 : 1),
          ),
          child: Row(children: [
            Text(flag, style: const TextStyle(fontSize: 34)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w900)),
                  Text(sub),
                ],
              ),
            ),
            if (sel) Icon(Icons.check_circle, color: Brand.green),
          ]),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),
            const Center(child: Bounce(child: Text('🌍', style: TextStyle(fontSize: 72)))),
            const SizedBox(height: 16),
            const Text('اللغة · Language',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
            const SizedBox(height: 24),
            card('ar', '🇸🇦', 'العربية', 'واجهة التطبيق بالعربي'),
            const SizedBox(height: 12),
            card('en', '🇬🇧', 'English', 'App in English'),
            const SizedBox(height: 28),
            Text(tx('المظهر', 'Appearance'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                    value: 'system',
                    icon: const Icon(Icons.brightness_auto),
                    label: Text(tx('حسب الجوال', 'Phone setting'))),
                ButtonSegment(
                    value: 'light',
                    icon: const Icon(Icons.light_mode),
                    label: Text(tx('فاتح', 'Light'))),
                ButtonSegment(
                    value: 'dark',
                    icon: const Icon(Icons.dark_mode),
                    label: Text(tx('داكن', 'Dark'))),
              ],
              selected: {app.themeMode},
              onSelectionChanged: (s) => app.setThemeMode(s.first),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ColorsPage())),
              icon: const Icon(Icons.palette_outlined),
              label: Text(tx('ألوان التطبيق', 'App colors')),
            ),
            const SizedBox(height: 24),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
              onPressed: () => app.setLang(app.lang),
              child: Text(tx('متابعة', 'Continue')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switcher() {
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
      PrefSection.sides,
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
                ? tx('اصنع خطتي ✨', 'Make my plan ✨')
                : (optional ? tx('التالي (أو تخطَّ)', 'Next (or skip)') : tx('التالي', 'Next'))),
          ),
        ),
      ),
    );
  }

  Widget _welcome() {
    final bullets = [
      ('💰', tx('خطة أسبوعية حسب ميزانيتك', 'A weekly plan within your budget')),
      ('🧊', tx('تستخدم الموجود في ثلاجتك', 'Uses what is in your fridge')),
      ('👩‍🍳', tx('شرح طبخ للمبتدئين خطوة بخطوة', 'Step-by-step cooking for beginners')),
      ('✨', tx('وصفات بالذكاء الاصطناعي من مكوناتك', 'AI recipes from your ingredients')),
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: Brand.headerGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ColorsPage())),
                    icon: const Icon(Icons.palette_outlined),
                    label: Text(tx('الألوان', 'Colors')),
                  ),
                ),
                const Spacer(),
                const Bounce(
                    child: Text('🍽️', style: TextStyle(fontSize: 96))),
                const SizedBox(height: 12),
                FadeSlideIn(
                  child: Text(tx('سفرة', 'Sufra'),
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                ),
                const SizedBox(height: 10),
                FadeSlideIn(
                  index: 1,
                  child: Text(
                    tx('حدد ميزانيتك والموجود عندك، ونطلع لك أسبوع وجبات كامل\nمع قائمة مشتريات وطريقة طبخ خطوة بخطوة.', 'Set your budget and what you have, and get a full week of meals\nwith a shopping list and step-by-step cooking.'),
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
                  child: Text(tx('ابدأ', 'Start')),
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
    final total = app.total;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _back, icon: const Icon(Icons.arrow_back_rounded)),
        title: Text(tx('خطتك جاهزة 🎉', 'Your plan is ready 🎉')),
        actions: [
          TextButton.icon(
            onPressed: () => app.generate(),
            icon: const Icon(Icons.refresh),
            label: Text(tx('خطة ثانية', 'Another plan')),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          BudgetBar(total: total, budget: prefs.budget),
          if (total > prefs.budget + 0.01)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                tx('الخطة فوق الميزانية. استبدل وجبات بأرخص منها (⇄ يوريك فرق السعر)، أو ارفع الميزانية.', 'The plan is over budget. Swap meals for cheaper ones (⇄ shows the price difference), or raise the budget.'),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 8),
          Text(tx('عدّل اللي تبيه قبل ما تعتمد الخطة:', 'Change anything you like before approving the plan:'),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const WeekList(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(56)),
            onPressed: () => AppScope.read(context).approvePlan(),
            child: Text(tx('اعتمد الخطة ✓', 'Approve plan ✓')),
          ),
        ),
      ),
    );
  }
}
