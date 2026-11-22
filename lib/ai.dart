// Gemini API: recipes from the fridge, a recipe for a dish you name,
// and beginner explanations of a step.
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'engine.dart';
import 'models.dart';

class AiException implements Exception {
  final String message;
  AiException(this.message);
  @override
  String toString() => message;
}

class Gemini {
  final String apiKey;
  final String model;
  Gemini(this.apiKey, this.model);

  static const defaultModel = 'gemini-3.5-flash-lite';

  Future<String> generate(String prompt, {bool json = false}) async {
    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent');
    final http.Response res;
    try {
      res = await http
          .post(uri,
              headers: {
                'Content-Type': 'application/json',
                'x-goog-api-key': apiKey,
              },
              body: jsonEncode({
                'contents': [
                  {
                    'role': 'user',
                    'parts': [
                      {'text': prompt}
                    ]
                  }
                ],
                if (json)
                  'generationConfig': {'responseMimeType': 'application/json'},
              }))
          .timeout(const Duration(seconds: 120));
    } catch (e) {
      throw AiException('ما قدرنا نتصل بالإنترنت. تأكد من الاتصال وجرّب مرة ثانية.');
    }
    final body = utf8.decode(res.bodyBytes);
    if (res.statusCode == 400 || res.statusCode == 403) {
      throw AiException(
          'مفتاح Gemini غير صحيح أو ما عنده صلاحية. راجعه من الإعدادات.\n($body)');
    }
    if (res.statusCode == 404) {
      throw AiException(
          'اسم النموذج "$model" غير موجود. غيّره من الإعدادات (مثلاً ${Gemini.defaultModel}).');
    }
    if (res.statusCode == 429) {
      throw AiException('وصلت للحد المسموح حالياً. جرّب بعد دقيقة.');
    }
    if (res.statusCode != 200) {
      throw AiException('خطأ من Gemini (${res.statusCode}).');
    }
    final data = jsonDecode(body) as Map<String, dynamic>;
    final cands = data['candidates'] as List?;
    if (cands == null || cands.isEmpty) {
      throw AiException('Gemini ما رجّع رد. جرّب مرة ثانية.');
    }
    final parts = ((cands.first as Map)['content'] as Map?)?['parts'] as List?;
    final text = (parts ?? const [])
        .map((p) => (p as Map)['text']?.toString() ?? '')
        .join();
    if (text.trim().isEmpty) throw AiException('الرد فاضي. جرّب مرة ثانية.');
    return text;
  }

  // ------------------------------------------------------------ prompts

  static String _catalogList(Catalog c) => c.ingredients.values
      .map((i) => '${i.id}: ${i.name} (${i.unit == 'pc' ? 'pc' : i.unit})')
      .join('\n');

  static String _prefsText(Catalog c, Prefs p) {
    final diets = p.diets.map((d) => optionTitle(dietOptions, d)).join('، ');
    final allergies =
        p.allergies.map((a) => optionTitle(allergyOptions, a)).join('، ');
    final dislikes =
        p.dislikes.map((d) => optionTitle(dislikeOptions, d)).join('، ');
    final appl =
        p.appliances.map((a) => optionTitle(applianceOptions, a)).join('، ');
    return [
      if (diets.isNotEmpty) 'النظام الغذائي: $diets',
      if (allergies.isNotEmpty) 'حساسية (ممنوع تماماً): $allergies',
      if (dislikes.isNotEmpty) 'لا يحب: $dislikes',
      'الأجهزة المتوفرة: البوتاجاز${appl.isEmpty ? '' : '، $appl'}',
      if (p.kcalTarget) 'هدف السعرات اليومي للشخص: ${p.kcal} سعرة',
    ].join('\n');
  }

  static const _schema = '''
أرجع JSON فقط بهذا الشكل بالضبط (مصفوفة):
[
  {
    "title": "اسم الوصفة بالعربي",
    "emoji": "إيموجي واحد",
    "meals": ["b" أو "l" أو "d"],
    "minutes": 25,
    "servings": 4,
    "keeps": true أو false (هل تصلح تبات في الثلاجة لليوم الثاني),
    "ingredients": [{"id": "معرّف من القائمة فقط", "qty": 2, "unit": "g أو ml أو pc أو tsp أو tbsp أو cup"}],
    "steps": ["خطوة مفصلة للمبتدئ تذكر درجة النار والوقت وكيف أعرف إنها استوت، واكتب المكون هكذا {id} عند ذكره"]
  }
]
القواعد:
- استخدم فقط معرّفات المكونات من القائمة. لو احتجت مكون مش موجود تجاهله.
- اذكر البهارات والملح والزيت ككميات واضحة.
- الكميات لـ 4 أشخاص.
- الخطوات بالعربي البسيط لشخص ما يعرف يطبخ: 4 إلى 8 خطوات.
''';

  Future<List<Recipe>> fromFridge(Catalog c, Prefs p, int count) async {
    final have = p.fridge
        .map((id) => c.ingredients[id])
        .whereType<Ingredient>()
        .map((i) => '${i.id}: ${i.name}')
        .join('\n');
    final prompt = '''
أنت طباخ عربي محترف. اقترح $count وصفات مختلفة ولذيذة تستخدم أكبر قدر من المكونات الموجودة عندي، ويُسمح بإضافة مكونات قليلة من القائمة الكاملة.

المكونات الموجودة عندي:
$have

${_prefsText(c, p)}

القائمة الكاملة للمكونات المسموحة (id: الاسم (الوحدة الأساسية)):
${_catalogList(c)}

$_schema''';
    return _parseRecipes(await generate(prompt, json: true), c, count);
  }

  Future<Recipe?> forDish(Catalog c, Prefs p, String dish) async {
    final prompt = '''
أنت طباخ عربي محترف. اكتب وصفة "$dish" بطريقة البيت.

${_prefsText(c, p)}

القائمة الكاملة للمكونات المسموحة (id: الاسم (الوحدة الأساسية)):
${_catalogList(c)}

$_schema
أرجع مصفوفة فيها وصفة واحدة.''';
    final list = await _parseRecipes(await generate(prompt, json: true), c, 1);
    return list.isEmpty ? null : list.first;
  }

  Future<String> explainStep(Recipe r, String step) async {
    final prompt = '''
أنا ما أعرف أطبخ أبداً. أطبخ "${r.title}" ووصلت لهذي الخطوة:
"$step"

اشرحها لي خطوة بخطوة بالعربي البسيط جداً (اللهجة الخليجية أو المصرية مقبولة):
- وش الأدوات اللي أحتاجها
- درجة النار بالضبط (هادية/متوسطة/عالية) وكم دقيقة
- كيف يكون شكل الأكل لما يكون جاهز (اللون، الريحة، القوام)
- أخطاء شائعة وكيف أتجنبها
بدون مقدمات، نقاط قصيرة، أقل من 180 كلمة.''';
    return generate(prompt);
  }

  static Future<List<Recipe>> _parseRecipes(
      String text, Catalog c, int max) async {
    var t = text.trim();
    if (t.startsWith('```')) {
      t = t.replaceAll(RegExp(r'^```(json)?'), '').replaceAll('```', '').trim();
    }
    dynamic data;
    try {
      data = jsonDecode(t);
    } catch (_) {
      final start = t.indexOf('[');
      final end = t.lastIndexOf(']');
      if (start < 0 || end <= start) {
        throw AiException('ما فهمنا رد الذكاء الاصطناعي. جرّب مرة ثانية.');
      }
      data = jsonDecode(t.substring(start, end + 1));
    }
    if (data is Map) data = data['recipes'] ?? [data];
    final out = <Recipe>[];
    final stamp = DateTime.now().millisecondsSinceEpoch;
    var n = 0;
    for (final raw in (data as List)) {
      if (raw is! Map) continue;
      final r = buildRecipe(raw.cast<String, dynamic>(), c, 'ai_${stamp}_${n++}');
      if (r != null && r.lines.isNotEmpty) out.add(r);
      if (out.length >= max) break;
    }
    if (out.isEmpty) {
      throw AiException('الرد ما فيه وصفات صالحة. جرّب مرة ثانية.');
    }
    return out;
  }
}
