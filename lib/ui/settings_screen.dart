import '../i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ai.dart';
import '../engine.dart';
import '../models.dart';
import '../state.dart';
import 'shell.dart';
import 'colors_page.dart';
import 'notif_page.dart';
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
      return l.isEmpty ? tx('لا شيء', 'None') : l.join(tx('، ', ', '));
    }

    final summary = {
      PrefSection.store: app.c.store(p.storeId).name,
      PrefSection.budget: tx('${fmtMoney(p.budget)} في الأسبوع', '${fmtMoney(p.budget)} per week'),
      PrefSection.people: tx('${p.people} ${p.people == 1 ? 'شخص' : 'أشخاص'}', '${p.people} ${p.people == 1 ? 'person' : 'people'}'),
      PrefSection.meals:
          tx('${slotOrder.where(p.meals.contains).map((s) => slotNames[s]!).join('، ')}${p.leftovers ? ' · طبخة تكفي يومين' : ''}', '${slotOrder.where(p.meals.contains).map((s) => slotNames[s]!).join(', ')}${p.leftovers ? ' · cook once for two days' : ''}'),
      PrefSection.sides: p.sides.values.every((v) => v.isEmpty)
          ? tx('لا شيء', 'None')
          : [
              for (final e in p.sides.entries)
                if (e.value.isNotEmpty)
                  '${slotNames[e.key]}: ${e.value.map((c) => optionTitle(sideOptions, c)).join(tx('، ', ', '))}'
            ].join(' · '),
      PrefSection.diet: p.diets.isEmpty
          ? tx('بدون قيود', 'No restrictions')
          : join(p.diets.map((d) => optionTitle(dietOptions, d))),
      PrefSection.cuisine: join(p.styles.map(app.c.styleName)),
      PrefSection.vibe: join(p.vibes.map((v) => optionTitle(vibeOptions, v))),
      PrefSection.target: p.kcalTarget
          ? tx('${p.kcal} سعرة · بروتين ${p.protein}غ · كارب ${p.carbs}غ · دهون ${p.fat}غ', '${p.kcal} kcal · protein ${p.protein}g · carbs ${p.carbs}g · fat ${p.fat}g')
          : tx('بدون هدف', 'No target'),
      PrefSection.allergies:
          join(p.allergies.map((a) => optionTitle(allergyOptions, a))),
      PrefSection.dislikes:
          join(p.dislikes.map((a) => optionTitle(dislikeOptions, a))),
      PrefSection.appliances:
          join(p.appliances.map((a) => optionTitle(applianceOptions, a))),
      PrefSection.fridge: tx('${p.fridge.length} مكوّن', '${p.fridge.length} items'),
    };
    const icons = {
      PrefSection.store: Icons.storefront_outlined,
      PrefSection.budget: Icons.account_balance_wallet_outlined,
      PrefSection.people: Icons.people_outline,
      PrefSection.meals: Icons.restaurant_outlined,
      PrefSection.sides: Icons.local_cafe_outlined,
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
      appBar: AppBar(
        leading: const ShellBack(),title: Text(tx('الإعدادات', 'Settings'))),
      body: ListView(children: [
        _Header(tx('✨ الذكاء الاصطناعي', '✨ AI')),
        ListTile(
          leading: Icon(Icons.auto_awesome, color: Brand.orange),
          title: Text(tx('مفتاح Gemini', 'Gemini key')),
          subtitle: Text(app.gemini == null
              ? tx('غير مضاف: الاقتراحات من المكتبة تشتغل بدونه', 'Not added: library suggestions work without it')
              : tx('مضاف ✓ · ${app.geminiModel}', 'Added ✓ · ${app.geminiModel}')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AiSettingsPage())),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_outline),
          title: Text(tx('وصفاتي', 'My recipes')),
          subtitle: Text(tx('${app.userRecipes.length} وصفة محفوظة', '${app.userRecipes.length} saved recipes')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const MyRecipesPage())),
        ),
        _Header(tx('عام', 'General')),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(tx('اللغة', 'Language')),
          subtitle: Text(app.lang == 'en' ? 'English' : 'العربية'),
          trailing: SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'ar', label: Text('ع')),
              ButtonSegment(value: 'en', label: Text('EN')),
            ],
            selected: {app.lang},
            onSelectionChanged: (v) => app.setLang(v.first),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.brightness_6_outlined),
          title: Text(tx('المظهر', 'Appearance')),
          subtitle: Text(app.themeMode == 'dark'
              ? tx('داكن', 'Dark')
              : (app.themeMode == 'light'
                  ? tx('فاتح', 'Light')
                  : tx('حسب إعدادات الجوال', 'Follow phone setting'))),
          onTap: () => showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (ctx) => SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                for (final (v, icon, label) in [
                  ('system', Icons.brightness_auto, tx('حسب إعدادات الجوال', 'Follow phone setting')),
                  ('light', Icons.light_mode, tx('فاتح', 'Light')),
                  ('dark', Icons.dark_mode, tx('داكن', 'Dark')),
                ])
                  ListTile(
                    leading: Icon(icon),
                    title: Text(label),
                    trailing: app.themeMode == v
                        ? Icon(Icons.check_circle, color: Brand.green)
                        : null,
                    onTap: () {
                      app.setThemeMode(v);
                      Navigator.pop(ctx);
                    },
                  ),
              ]),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: Text(tx('التنبيهات', 'Reminders')),
          subtitle: Text(app.notif.enabled
              ? tx('شغالة: بدء الطبخ، وقت الوجبة، التجهيزات', 'On: start cooking, meal time, prep')
              : tx('مطفية', 'Off')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NotifPage())),
        ),
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(tx('ألوان التطبيق', 'App colors')),
          subtitle: Text('${paletteById(app.themeId).emoji} ${paletteById(app.themeId).name}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ColorsPage())),
        ),
        const Divider(),
        _Header(tx('التفضيلات', 'Preferences')),
        for (final e in summary.entries)
          ListTile(
            leading: Icon(icons[e.key]),
            title: Text(prefTitles[e.key]!.$1),
            subtitle:
                Text(e.value, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => PrefEditPage(e.key))),
          ),
        const Divider(),
        _Header(tx('الأسعار', 'Prices')),
        ListTile(
          leading: const Icon(Icons.price_change_outlined),
          title: Text(tx('تعديل أسعار المكونات', 'Edit ingredient prices')),
          subtitle: Text(
              tx('${app.overrides.keys.where((k) => k.startsWith('${p.storeId}|')).length} سعر معدّل في هذا المتجر', '${app.overrides.keys.where((k) => k.startsWith('${p.storeId}|')).length} prices changed at this store')),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PriceEditor())),
        ),
        ListTile(
          leading: const Icon(Icons.school_outlined),
          title: Text(tx('أساسيات الطبخ للمبتدئين', 'Cooking basics for beginners')),
          onTap: () => showKitchenBasics(context),
        ),
        const Divider(),
        _Header(tx('البيانات', 'Data')),
        ListTile(
          leading: const Icon(Icons.restart_alt),
          title: Text(tx('ابدأ من جديد', 'Start over')),
          subtitle: Text(tx('يمسح التفضيلات والخطة والأسعار المعدلة', 'Clears preferences, plan and edited prices')),
          onTap: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text(tx('مسح كل البيانات؟', 'Delete all data?')),
                content: Text(tx('ما تقدر تتراجع عن هذا.', 'This cannot be undone.')),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(tx('إلغاء', 'Cancel'))),
                  FilledButton(
                      style: FilledButton.styleFrom(
                          backgroundColor: Theme.of(ctx).colorScheme.error),
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(tx('امسح', 'Clear'))),
                ],
              ),
            );
            if (ok == true) app.resetAll();
          },
        ),
        AboutListTile(
          icon: const Icon(Icons.info_outline),
          applicationName: tx('سفرة', 'Sufra'),
          applicationVersion: '0.5.0',
          aboutBoxChildren: [
            Text(
                tx('مخطط وجبات أسبوعي بالميزانية. ${app.c.recipes.length} وصفة. الأسعار والقيم الغذائية تقديرية.', 'Weekly meal planner on a budget. ${app.c.recipes.length} recipes. Prices and nutrition are estimates.')),
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
            tx('⚠️ ما لقينا مفتاح في الحافظة. المفتاح يبدأ بـ AIza، انسخه من صفحة قوقل وارجع.', '⚠️ No key found on the clipboard. The key starts with AIza. Copy it from the Google page and come back.'));
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
      await g.generate(tx('رد بكلمة واحدة: تمام', 'Reply with one word: OK'));
      setState(() => result = tx('✅ تم الربط بنجاح! جرّب تبويب "اقترح لي ✨".', '✅ Linked! Try the "Cook with what I have ✨" tab.'));
    } catch (e) {
      setState(() => result = '⚠️ $e');
    } finally {
      if (mounted) setState(() => testing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tx('الذكاء الاصطناعي', 'AI'))),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx('اربط Gemini في خطوتين', 'Link Gemini in two steps'),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Text(
                    tx('1. اضغط الزر تحت، بتفتح صفحة قوقل (بحسابك على الجوال).\n', '1. Tap the button below. Google’s page opens (with your phone’s account).\n') +
                    tx('2. اضغط "Create API key". لو سألك عن مشروع، اختار أي واحد أو "Create project".\n', '2. Tap "Create API key". If it asks for a project, pick any or "Create project".\n') +
                    tx('3. اضغط زر النسخ جنب المفتاح وارجع للتطبيق، ونربطه تلقائياً.', '3. Tap the copy button next to the key and come back. We link it automatically.'),
                    style: TextStyle(height: 1.7)),
                const SizedBox(height: 12),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: Brand.orange,
                      minimumSize: const Size.fromHeight(52)),
                  onPressed: _openStudio,
                  icon: const Icon(Icons.open_in_new),
                  label: Text(tx('افتح صفحة المفتاح', 'Open the key page')),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48)),
                  onPressed: testing ? null : () => _paste(),
                  icon: const Icon(Icons.content_paste),
                  label: Text(tx('نسخته؟ الصقه واربط', 'Copied it? Paste and link')),
                ),
                if (waiting)
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(tx('⏳ ننتظرك ترجع بالمفتاح منسوخ...', '⏳ Waiting for you to come back with the key copied...'),
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
        Text(tx('الميزات اللي تحتاج المفتاح:', 'Features that need the key:'),
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(
            tx('• 3 أو 5 وصفات جديدة من المكونات اللي عندك\n• وصفة كاملة لأي أكلة تكتب اسمها\n• شرح مفصّل لأي خطوة طبخ', '• 3 or 5 new recipes from what you have\n• A full recipe for any dish you name\n• A detailed explanation of any cooking step'),
            style: TextStyle(height: 1.7)),
        const SizedBox(height: 16),
        Text(tx('أو اكتب المفتاح يدوياً:', 'Or type the key yourself:'),
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          controller: key,
          obscureText: hide,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: tx('مفتاح Gemini API', 'Gemini API key'),
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
            labelText: tx('اسم النموذج', 'Model name'),
            helperText: tx('الافتراضي ${Gemini.defaultModel}. غيّره لو قوقل أصدرت نموذج أحدث.', 'Default ${Gemini.defaultModel}. Change it if Google releases a newer model.'),
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
                  : Text(tx('جرّب المفتاح', 'Test key')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: () {
                AppScope.read(context).setAi(key.text, model.text);
                Navigator.pop(context);
              },
              child: Text(tx('حفظ', 'Save')),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        Text(
            tx('المفتاح ينحفظ على جوالك بس، ويُرسل مباشرة لقوقل مع قائمة مكوناتك وتفضيلاتك لما تطلب وصفة.', 'The key is stored only on your phone and sent straight to Google with your ingredients and preferences when you ask for a recipe.'),
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
      appBar: AppBar(title: Text(tx('وصفاتي', 'My recipes'))),
      body: list.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                    tx('الوصفات اللي تحفظها من الذكاء الاصطناعي أو تضيفها بنفسك بتظهر هنا.', 'Recipes you save from AI or add yourself show up here.'),
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
