import 'package:flutter/material.dart';

import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'pref_editors.dart';
import 'widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final prefs = Prefs();
  int step = 0; // 0 welcome, 1..9 sections, 10 preview
  PlanResult? preview;

  static const sections = PrefSection.values;
  int get last => sections.length + 1;

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

  void _back() => setState(() => step = (step - 1).clamp(0, last));

  @override
  Widget build(BuildContext context) {
    if (step == 0) return _welcome();
    if (step == last) return _preview();
    final sec = sections[step - 1];
    final t = prefTitles[sec]!;
    final optional = sec == PrefSection.styles ||
        sec == PrefSection.allergies ||
        sec == PrefSection.dislikes;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: _back, icon: const Icon(Icons.arrow_back_rounded)),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
              value: step / sections.length, minHeight: 8),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        children: [
          Text(t.$1,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(t.$2, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          PrefEditor(
              section: sec, prefs: prefs, onChanged: () => setState(() {})),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
            onPressed: _next,
            child: Text(step == sections.length
                ? 'اصنع خطتي'
                : (optional ? 'التالي (أو تخطَّ)' : 'التالي')),
          ),
        ),
      ),
    );
  }

  Widget _welcome() {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const Text('🍽️', style: TextStyle(fontSize: 90)),
              const SizedBox(height: 16),
              Text('سفرة',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold, color: cs.primary)),
              const SizedBox(height: 12),
              Text(
                'حدد ميزانيتك ومتجرك، ونطلع لك أسبوع وجبات كامل\nمع قائمة مشتريات مسعّرة تحت ميزانيتك.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              const _Bullet('💰', 'خطة أسبوعية حسب ميزانيتك بالريال'),
              const _Bullet('🛒', 'قائمة مشتريات مرتبة حسب أقسام المتجر'),
              const _Bullet('👨‍🍳', 'وصفات عربية بخطوات تتغير مع عدد الحصص'),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54)),
                onPressed: _next,
                child: const Text('ابدأ'),
              ),
            ],
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
        title: const Text('خطتك جاهزة'),
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
          if (res.emptySlots.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                  'بعض الخانات بقيت فاضية لأن ما فيه وصفات تناسب كل الشروط.'),
            ),
          for (var day = 0; day < 7; day++) ...[
            SectionTitle(dayName(DateTime.now().add(Duration(days: day)))),
            for (final m in res.meals.where((m) => m.day == day))
              Builder(builder: (_) {
                final r = app.c.recipeById[m.recipeId]!;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: FoodTile(r.emoji, size: 44),
                  title: Text(r.title),
                  subtitle: Text(
                      '${slotNames[m.slot]} · ${fmtMoney(pr.costPerServing(r) * m.servings)}'),
                );
              }),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            style:
                FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
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

class _Bullet extends StatelessWidget {
  final String emoji;
  final String text;
  const _Bullet(this.emoji, this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
              child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ]),
      );
}
