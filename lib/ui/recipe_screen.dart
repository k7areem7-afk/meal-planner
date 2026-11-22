import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../cooking_guide.dart';
import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'anim.dart';
import 'theme.dart';
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

  Future<void> _youtube(Recipe r) async {
    final uri = Uri.https('www.youtube.com', '/results',
        {'search_query': 'طريقة عمل ${r.title}'});
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ما قدرنا نفتح يوتيوب')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final r = widget.recipe;
    final servings =
        _servings ?? widget.planned?.servings ?? app.prefs.people;
    final factor = r.servings <= 0 ? 1.0 : servings / r.servings;
    final cps = app.pricing.costPerServing(r);
    final cs = Theme.of(context).colorScheme;
    final have = app.prefs.fridge;
    final ings = r.lines
        .map((l) => (l, app.c.ingredients[l.ingId]))
        .where((x) => x.$2 != null)
        .map((x) => (x.$1, x.$2!))
        .toList();
    final main = ings.where((x) => !x.$2.isSpice && !x.$2.pantry).toList();
    final spices = ings.where((x) => x.$2.isSpice || x.$2.pantry).toList();
    final missing = ings.where((x) => !have.contains(x.$2.id)).length;
    final tag = widget.planned == null
        ? 'r-${r.id}'
        : 'r-${r.id}-${widget.planned!.day}-${widget.planned!.slot}';

    void setServings(int s) {
      s = s.clamp(1, 20).toInt();
      setState(() => _servings = s);
      if (widget.planned != null) app.setServings(widget.planned!, s);
    }

    Widget ingRow((RecipeLine, Ingredient) x) {
      final (l, ing) = x;
      final ok = have.contains(ing.id);
      return ListTile(
        dense: true,
        leading: Text(ing.emoji, style: const TextStyle(fontSize: 22)),
        title: Text(ing.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(ok ? '✓ موجود عندك' : 'ناقص، بيكون في قائمة المشتريات',
            style: TextStyle(
                fontSize: 11.5, color: ok ? Brand.green : Brand.orange)),
        trailing: Text(fmtQty(l.q * factor, l.u, ing),
            style: const TextStyle(fontWeight: FontWeight.w800)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          if (r.user && !app.isSaved(r.id))
            TextButton.icon(
              onPressed: () {
                app.saveRecipe(r);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('انحفظت في وصفاتي')));
              },
              icon: const Icon(Icons.bookmark_add_outlined),
              label: const Text('احفظ'),
            ),
          if (widget.planned == null)
            IconButton(
              tooltip: 'أضف للخطة',
              icon: const Icon(Icons.playlist_add),
              onPressed: () => addToPlanDialog(context, r, servings),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
        children: [
          if (widget.planned?.leftover ?? false)
            Card(
              color: Brand.yellow.withValues(alpha: 0.2),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                    '🍱 هذي بواقي من طبخة أمس، ما تحتاج تطبخ. سخّنها كويس لحد ما تطلع بخار قبل الأكل.'),
              ),
            ),
          const SizedBox(height: 8),
          Center(child: Hero(tag: tag, child: FoodTile(r.emoji, size: 104))),
          const SizedBox(height: 12),
          FadeSlideIn(
            child: Text(r.title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoPill(Icons.timer_outlined, '${r.minutes} دقيقة'),
              InfoPill(Icons.payments_outlined, '${fmtMoney(cps)} للحصة'),
              for (final s in r.styles.take(2))
                InfoPill(Icons.public, app.c.styleName(s)),
              for (final a in r.appliances)
                InfoPill(Icons.kitchen_outlined, optionTitle(applianceOptions, a)),
              if (r.keeps) const InfoPill(Icons.ac_unit, 'تصلح تبات'),
            ],
          ),
          const SizedBox(height: 14),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('القيمة الغذائية للحصة الواحدة (تقريبية)',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  MacroRow.of(r, compact: false),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                        fontSize: 18, fontWeight: FontWeight.w800)),
                IconButton(
                    onPressed: () => setServings(servings + 1),
                    icon: const Icon(Icons.add_circle_outline)),
              ]),
            ),
          ),
          SectionTitle(missing == 0
              ? 'المكونات (كلها موجودة عندك ✓)'
              : 'المكونات (ناقصك $missing)'),
          Card(child: Column(children: [for (final x in main) ingRow(x)])),
          if (spices.isNotEmpty) ...[
            const SectionTitle('🧂 البهارات والأساسيات المطلوبة'),
            Card(child: Column(children: [for (final x in spices) ingRow(x)])),
          ],
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _youtube(r),
                icon: const Icon(Icons.play_circle_fill, color: Colors.red),
                label: const Text('شاهد الطريقة'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => showKitchenBasics(context),
                icon: const Icon(Icons.school_outlined),
                label: const Text('أساسيات الطبخ'),
              ),
            ),
          ]),
          const SectionTitle('👩‍🍳 طريقة التحضير خطوة بخطوة'),
          for (var i = 0; i < r.steps.length; i++)
            FadeSlideIn(
              index: i,
              child: StepCard(
                recipe: r,
                index: i,
                text: renderStep(r.steps[i], r, factor, app.c),
                raw: r.steps[i],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Brand.orange,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => CookMode(recipe: r, factor: factor))),
        icon: const Icon(Icons.soup_kitchen),
        label: const Text('ابدأ الطبخ'),
      ),
    );
  }
}

/// One illustrated step with beginner tips and an optional AI explanation.
class StepCard extends StatefulWidget {
  final Recipe recipe;
  final int index;
  final String text;
  final String raw;
  const StepCard(
      {super.key,
      required this.recipe,
      required this.index,
      required this.text,
      required this.raw});
  @override
  State<StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<StepCard> {
  String? ai;
  bool busy = false;

  Future<void> _explain() async {
    final g = AppScope.read(context).gemini;
    if (g == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('أضف مفتاح Gemini من الإعدادات ← الذكاء الاصطناعي')));
      return;
    }
    setState(() => busy = true);
    try {
      final t = await g.explainStep(widget.recipe, widget.text);
      if (mounted) setState(() => ai = t);
    } catch (e) {
      if (mounted) setState(() => ai = '⚠️ $e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final techs = techniquesFor(widget.raw);
    final heat = heatFor(widget.raw);
    final emoji = techs.isEmpty ? '👩‍🍳' : techs.first.emoji;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Stack(clipBehavior: Clip.none, children: [
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: Brand.headerGradient,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
                PositionedDirectional(
                  top: -6,
                  start: -6,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Brand.orange,
                    child: Text('${widget.index + 1}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ]),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.text,
                        style: const TextStyle(fontSize: 16, height: 1.6)),
                    if (heat.isNotEmpty || stepMinutes(widget.raw) != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Wrap(spacing: 6, children: [
                          if (heat.isNotEmpty)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text('🔥 النار: $heat'),
                            ),
                          if (stepMinutes(widget.raw) != null)
                            Chip(
                              visualDensity: VisualDensity.compact,
                              label: Text('⏱️ ${stepMinutes(widget.raw)} دقيقة'),
                            ),
                        ]),
                      ),
                  ],
                ),
              ),
            ]),
            if (techs.isNotEmpty)
              Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text('💡 شرح للمبتدئ',
                      style: TextStyle(
                          color: Brand.orange, fontWeight: FontWeight.w700)),
                  children: [
                    for (final t in techs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.emoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: '${t.title}: ',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                TextSpan(text: t.tip),
                              ]), style: const TextStyle(height: 1.5)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: busy ? null : _explain,
                icon: busy
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.auto_awesome, size: 18),
                label: Text(ai == null ? 'اشرح لي أكثر بالذكاء الاصطناعي' : 'اشرح مرة ثانية'),
              ),
            ),
            if (ai != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Brand.yellow.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(ai!, style: const TextStyle(height: 1.6)),
              ),
          ],
        ),
      ),
    );
  }
}

void showKitchenBasics(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      builder: (_, ctrl) => ListView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const Text('أساسيات الطبخ للمبتدئين',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          for (final (e, t, d) in kitchenBasics)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(e, style: const TextStyle(fontSize: 28)),
              title: Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(d, style: const TextStyle(height: 1.5)),
            ),
          const SectionTitle('المصطلحات'),
          for (final t in techniques.take(14))
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Text(t.emoji, style: const TextStyle(fontSize: 24)),
              title: Text(t.title,
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(t.tip, style: const TextStyle(height: 1.5)),
            ),
        ],
      ),
    ),
  );
}

Future<void> addToPlanDialog(
    BuildContext context, Recipe r, int servings) async {
  final app = AppScope.read(context);
  var day = 0;
  var slot = r.meals.isEmpty ? 'l' : r.meals.first;
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
    if (r.user && !app.isSaved(r.id)) app.saveRecipe(r);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('الخطوة ${page + 1} من $n'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AnimatedBar(value: (page + 1) / n, height: 6),
          ),
        ),
      ),
      body: PageView.builder(
        controller: ctrl,
        itemCount: n,
        onPageChanged: (i) => setState(() => page = i),
        itemBuilder: (_, i) {
          final text = renderStep(r.steps[i], r, widget.factor, app.c);
          final mins = stepMinutes(r.steps[i]);
          final techs = techniquesFor(r.steps[i]);
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Bounce(
                  key: ValueKey(i),
                  child: Container(
                    width: 110,
                    height: 110,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      gradient: Brand.headerGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Text(stepEmoji(r.steps[i]),
                        style: const TextStyle(fontSize: 54)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, height: 1.6, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              if (mins != null)
                Center(
                  child: timer != null && timer!.isActive
                      ? Text(_mmss(remaining),
                          style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              color: Brand.orange))
                      : FilledButton.tonalIcon(
                          onPressed: () => _startTimer(mins),
                          icon: const Icon(Icons.timer),
                          label: Text('مؤقت $mins دقيقة'),
                        ),
                ),
              for (final t in techs)
                Card(
                  margin: const EdgeInsets.only(top: 12),
                  color: Brand.yellow.withValues(alpha: 0.15),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('${t.emoji} ${t.title}: ${t.tip}',
                        style: const TextStyle(height: 1.5)),
                  ),
                ),
            ],
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
