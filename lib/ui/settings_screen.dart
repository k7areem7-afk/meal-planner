import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ai.dart';
import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'pref_editors.dart';
import 'price_editor.dart';
import 'recipe_screen.dart';
import 'theme.dart';
import 'widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final p = app.prefs;

    String join(Iterable<String> titles) {
      final l = titles.toList();
      return l.isEmpty ? 'لا شيء' : l.join('، ');
    }

    final summary = {
      PrefSection.store: app.c.store(p.storeId).name,
      PrefSection.budget: '${fmtMoney(p.budget)} في الأسبوع',
      PrefSection.people: '${p.people} ${p.people == 1 ? 'شخص' : 'أشخاص'}',
      PrefSection.meals:
          '${slotOrder.where(p.meals.contains).map((s) => slotNames[s]!).join('، ')}${p.leftovers ? ' · طبخة تكفي يومين' : ''}',
      PrefSection.diet: p.diets.isEmpty
          ? 'بدون قيود'
          : join(p.diets.map((d) => optionTitle(dietOptions, d))),
      PrefSection.cuisine: join(p.styles.map(app.c.styleName)),
      PrefSection.vibe: join(p.vibes.map((v) => optionTitle(vibeOptions, v))),
      PrefSection.target: p.kcalTarget
          ? '${p.kcal} سعرة · بروتين ${p.protein}غ · كارب ${p.carbs}غ · دهون ${p.fat}غ'
          : 'بدون هدف',
      PrefSection.allergies:
          join(p.allergies.map((a) => optionTitle(allergyOptions, a))),
      PrefSection.dislikes:
          join(p.dislikes.map((a) => optionTitle(dislikeOptions, a))),
      PrefSection.appliances:
          join(p.appliances.map((a) => optionTitle(applianceOptions, a))),
      PrefSection.fridge: '${p.fridge.length} مكوّن',
    };
    const icons = {
      PrefSection.store: Icons.storefront_outlined,
      PrefSection.budget: Icons.account_balance_wallet_outlined,
      PrefSection.people: Icons.people_outline,
      PrefSection.meals: Icons.restaurant_outlined,
      PrefSection.diet: Icons.eco_outlined,
      PrefSection.cuisine: Icons.public,
      PrefSection.vibe: Icons.mood,
      PrefSection.target: Icons.monitor_heart_outlined,
      PrefSection.allergies: Icons.warning_amber_outlined,
      PrefSection.dislikes: Icons.thumb_down_outlined,
      PrefSection.appliances: Icons.kitchen_outlined,
      PrefSection.fridge: Icons.kitchen,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(children: [
        const _Header('✨ الذكاء الاصطناعي'),
        ListTile(
          leading: const Icon(Icons.auto_awesome, color: Brand.orange),
          title: const Text('مفتاح Gemini'),
          subtitle: Text(app.gemini == null
              ? 'غير مضاف: الاقتراحات من المكتبة تشتغل بدونه'
              : 'مضاف ✓ · ${app.geminiModel}'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AiSettingsPage())),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_outline),
          title: const Text('وصفاتي'),
          subtitle: Text('${app.userRecipes.length} وصفة محفوظة'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MyRecipesPage())),
        ),
        const Divider(),
        const _Header('التفضيلات'),
        for (final e in summary.entries)
          ListTile(
            leading: Icon(icons[e.key]),
            title: Text(prefTitles[e.key]!.$1),
            subtitle:
                Text(e.value, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_left),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PrefEditPage(e.key))),
          ),
        const Divider(),
        const _Header('الأسعار'),
        ListTile(
          leading: const Icon(Icons.price_change_outlined),
          title: const Text('تعديل أسعار المكونات'),
          subtitle: Text(
              '${app.overrides.keys.where((k) => k.startsWith('${p.storeId}|')).length} سعر معدّل في هذا المتجر'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PriceEditor())),
        ),
        ListTile(
          leading: const Icon(Icons.school_outlined),
          title: const Text('أساسيات الطبخ للمبتدئين'),
          onTap: () => showKitchenBasics(context),
        ),
        const Divider(),
        const _Header('البيانات'),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: const Text('ابدأ من جديد'),
          subtitle: const Text('يمسح التفضيلات والخطة والأسعار المعدلة'),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('مسح كل البيانات؟'),
                content: const Text('ما تقدر تتراجع عن هذا.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('إلغاء')),
                  FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(ctx).colorScheme.error),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('امسح')),
                ],
              ),
            );
            if (ok == true) app.resetAll();
          },
        ),
        AboutListTile(
          icon: const Icon(Icons.info_outline),
          applicationName: 'سفرة',
          applicationVersion: '0.3.0',
          aboutBoxChildren: [
            Text(
                'مخطط وجبات أسبوعي بالميزانية. ${app.c.recipes.length} وصفة. الأسعار والقيم الغذائية تقديرية.'),
          ],
        ),
        const SizedBox(height: 24),
      ]),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(text,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w800)),
      );
}

class AiSettingsPage extends StatefulWidget {
  final bool autoOpen;
  const AiSettingsPage({super.key, this.autoOpen = false});
  @override
  State<AiSettingsPage> createState() => _AiSettingsPageState();
}

class _AiSettingsPageState extends State<AiSettingsPage>
    with WidgetsBindingObserver {
  late final TextEditingController key;
  late final TextEditingController model;
  bool hide = true;
  bool testing = false;
  bool waiting = false; // opened Google's page, waiting for a copied key
  String? result;

  static final _keyPattern = RegExp(r'AIza[0-9A-Za-z_\-]{30,}');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final app = AppScope.read(context);
    key = TextEditingController(text: app.geminiKey);
    model = TextEditingController(text: app.geminiModel);
    if (widget.autoOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openStudio());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    key.dispose();
    model.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && waiting) _paste(auto: true);
  }

  Future<void> _openStudio() async {
    setState(() => waiting = true);
    await launchUrl(Uri.parse('https://aistudio.google.com/apikey'),
        mode: LaunchMode.externalApplication);
  }

  /// Picks a Gemini key from the clipboard, saves it and tests it.
  Future<void> _paste({bool auto = false}) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final m = _keyPattern.firstMatch(data?.text ?? '');
    if (!mounted) return;
    if (m == null) {
      if (!auto) {
        setState(() => result =
            '⚠️ ما لقينا مفتاح في الحافظة. المفتاح يبدأ بـ AIza، انسخه من صفحة قوقل وارجع.');
      }
      return;
    }
    key.text = m.group(0)!;
    AppScope.read(context).setAi(key.text, model.text);
    setState(() => waiting = false);
    await _test();
  }

  Future<void> _test() async {
    setState(() {
      testing = true;
      result = null;
    });
    try {
      final g = Gemini(key.text.trim(),
          model.text.trim().isEmpty ? Gemini.defaultModel : model.text.trim());
      await g.generate('رد بكلمة واحدة: تمام');
      setState(() => result = '✅ تم الربط بنجاح! جرّب تبويب "اقترح لي ✨".');
    } catch (e) {
      setState(() => result = '⚠️ $e');
    } finally {
      if (mounted) setState(() => testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الذكاء الاصطناعي')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اربط Gemini في خطوتين',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                const Text(
                    '1. اضغط الزر تحت، بتفتح صفحة قوقل (بحسابك على الجوال).\n'
                    '2. اضغط "Create API key". لو سألك عن مشروع، اختار أي واحد أو "Create project".\n'
                    '3. اضغط زر النسخ جنب المفتاح وارجع للتطبيق، ونربطه تلقائياً.',
                    style: TextStyle(height: 1.7)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: Brand.orange,
                      minimumSize: const Size.fromHeight(52)),
                  onPressed: _openStudio,
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('افتح صفحة المفتاح'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: testing ? null : () => _paste(),
                  icon: const Icon(Icons.content_paste),
                  label: const Text('نسخته؟ الصقه واربط'),
                ),
                if (waiting)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text('⏳ ننتظرك ترجع بالمفتاح منسوخ...',
                        style: TextStyle(color: Brand.orange)),
                  ),
                if (testing)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: LinearProgressIndicator(),
                  ),
                if (result != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(result!,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('الميزات اللي تحتاج المفتاح:',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text(
            '• 3 أو 5 وصفات جديدة من المكونات اللي عندك\n• وصفة كاملة لأي أكلة تكتب اسمها\n• شرح مفصّل لأي خطوة طبخ',
            style: TextStyle(height: 1.7)),
        const SizedBox(height: 16),
        const Text('أو اكتب المفتاح يدوياً:',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: key,
          obscureText: hide,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: 'مفتاح Gemini API',
            suffixIcon: IconButton(
              icon: Icon(hide ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => hide = !hide),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: model,
          decoration: InputDecoration(
            labelText: 'اسم النموذج',
            helperText: 'الافتراضي ${Gemini.defaultModel}. غيّره لو قوقل أصدرت نموذج أحدث.',
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(
            child: OutlinedButton(
              onPressed: testing || key.text.trim().isEmpty ? null : _test,
              child: testing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('جرّب المفتاح'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () {
                AppScope.read(context).setAi(key.text, model.text);
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        const Text(
            'المفتاح ينحفظ على جوالك بس، ويُرسل مباشرة لقوقل مع قائمة مكوناتك وتفضيلاتك لما تطلب وصفة.',
            style: TextStyle(fontSize: 12)),
      ]),
    );
  }
}

class MyRecipesPage extends StatelessWidget {
  const MyRecipesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final list = app.userRecipes.reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('وصفاتي')),
      body: list.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    'الوصفات اللي تحفظها من الذكاء الاصطناعي أو تضيفها بنفسك بتظهر هنا.',
                    textAlign: TextAlign.center),
              ),
            )
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (_, i) {
                final r = list[i];
                return ListTile(
                  leading: FoodTile(r.emoji, size: 44),
                  title: Text(r.title),
                  subtitle: MacroRow.of(r),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => app.deleteRecipe(r.id),
                  ),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RecipeScreen(recipe: r))),
                );
              },
            ),
    );
  }
}
