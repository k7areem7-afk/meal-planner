// Beginner explanations for cooking techniques, detected from step text.
import 'i18n.dart';

class Technique {
  final List<String> words; // Arabic keywords in the step text
  final String emoji;
  final String titleAr, titleEn;
  final String heatAr, heatEn; // '' when not about heat
  final String tipAr, tipEn;
  const Technique(this.words, this.emoji, this.titleAr, this.titleEn,
      this.heatAr, this.heatEn, this.tipAr, this.tipEn);
  String get title => L.en ? titleEn : titleAr;
  String get heat => L.en ? heatEn : heatAr;
  String get tip => L.en ? tipEn : tipAr;
}

const techniques = <Technique>[
  Technique(['انقع', 'نقع'], '💧', 'النقع', 'Soaking', '', '',
      'غطّي المكوّن بماء بارد في وعاء وسيبه المدة المكتوبة. الرز ربع ساعة تكفي، والبقوليات الناشفة من الليلة اللي قبلها. بعدها صفّيه من الماء.',
      'Cover with cold water and leave for the time given. Rice needs 15 minutes; dried beans need the night before. Drain before using.'),
  Technique(['سخّن الفرن', 'الفرن على', 'اخبز', 'أدخل', 'في الفرن'], '🔥', 'الفرن', 'The oven', 'حسب الدرجة', 'as stated',
      'شغّل الفرن قبلها بـ 10 دقائق على الدرجة المكتوبة عشان يسخن. حط الصينية في الرف اللي في النص. لو الوش ما حمّر، شغّل الشواية فوق آخر 3 دقائق وراقبها.',
      'Turn the oven on 10 minutes before, at the stated temperature. Use the middle shelf. If the top is not browned, use the top grill for the last 3 minutes and watch it.'),
  Technique(['اقل', 'القلي'], '🍟', 'القلي', 'Frying', 'متوسطة لعالية', 'medium-high',
      'الزيت لازم يكون سخن كفاية: ارمي حتة صغيرة، لو طلعت حواليها فقاقيع على طول يبقى جاهز. لا تزحم الطاسة، اقلي على دفعات. طلّع الأكل على مناديل عشان تشرب الزيت. خلّي الأطفال بعيد.',
      'The oil must be hot enough: drop in a small piece; if it bubbles right away, it is ready. Do not crowd the pan, fry in batches. Drain on paper towels. Keep children away.'),
  Technique(['حمّر', 'تحمير', 'حمّره'], '🍳', 'التحمير', 'Browning', 'متوسطة', 'medium',
      'سخّن الزيت أو الزبدة على نار متوسطة لحد ما يلمع (حوالي دقيقة). حط المكون وقلّبه كل نص دقيقة لحد ما لونه يبقى دهبي. لو بيسود بسرعة وطّي النار. البصل ياخد 4-6 دقائق لحد ما يدبل ويصفر.',
      'Heat oil or butter on medium until it shimmers (about a minute). Add the food and stir every 30 seconds until golden. If it darkens fast, lower the heat. Onions take 4-6 minutes to soften and turn golden.'),
  Technique(['شوّح', 'قلّب', 'قلّبه', 'قلّبها'], '🥘', 'التشويح والتقليب', 'Sautéing', 'متوسطة لعالية', 'medium-high',
      'نار متوسطة لعالية وقلّب باستمرار بمعلقة خشب. الخضار تفضل لونها زاهي وطرية من برا ومقرمشة شوية من جوا.',
      'Medium-high heat, stir constantly with a wooden spoon. Vegetables should stay bright, tender outside and a little crisp inside.'),
  Technique(['اسلق', 'السلق', 'غلّي', 'يغلي', 'مغلي'], '♨️', 'السلق والغلي', 'Boiling', 'عالية ثم متوسطة', 'high, then medium',
      'حط ماء كتير على نار عالية لحد ما يفور (فقاقيع كبيرة). للمكرونة: ملح في الماء وقلّب أول دقيقة عشان ما تلزق، ودوقها قبل ما تصفيها. البيض: 9 دقائق مسلوق جامد.',
      'Bring plenty of water to a rolling boil (big bubbles) on high. For pasta: salt the water and stir in the first minute so it does not stick; taste before draining. Eggs: 9 minutes for hard-boiled.'),
  Technique(['نار هادئة', 'نار هادية', 'على نار هادئة', 'هادية'], '🫕', 'نار هادية', 'Low heat', 'هادية', 'low',
      'أصغر شعلة تقريباً. المرق يطلع فقاقيع صغيرة بس، مش فوران. غطّي الحلة وقلّب كل 10 دقائق عشان ما يلزق في القاع.',
      'Almost the smallest flame. The liquid should show small bubbles, not a boil. Cover the pot and stir every 10 minutes so nothing sticks.'),
  Technique(['اشو', 'الشوي', 'جريل'], '🍢', 'الشوي', 'Grilling', 'عالية', 'high',
      'سخّن الطاسة الجريل أو الفرن كويس قبلها. لا تقلّب اللحم أو الفراخ كتير: سيبه لحد ما يتحمّر ويتفصل لوحده. الفراخ لازم تستوي من جوا: لما تقطعها ما يكونش فيه لون وردي.',
      'Preheat the grill pan or oven well. Do not flip meat too often: let it brown until it releases by itself. Chicken must be cooked through: no pink inside when cut.'),
  Technique(['تبّل', 'التتبيل', 'تبّلها', 'تبّله'], '🧂', 'التتبيل', 'Marinating', '', '',
      'افرك التتبيلة بإيدك على كل الجهات. كل ما تسيبه أكتر في التلاجة (من 30 دقيقة لحد ليلة) كل ما الطعم يدخل أكتر. اغسل إيدك كويس بعد اللحمة والفراخ النية.',
      'Rub the marinade on all sides. The longer it rests in the fridge (30 minutes to overnight), the more flavor. Wash your hands well after raw meat and chicken.'),
  Technique(['قطّع', 'افرم', 'ابشر', 'مكعبات', 'شرائح'], '🔪', 'التقطيع', 'Cutting', '', '',
      'مكعبات = قطع متساوية حوالي 1 سم. مفروم = صغير جداً. شرائح = رفيعة. مبشور = على البشارة. استخدم سكينة حادة ولوح تقطيع ثابت، وصوابعك منحنية لجوا.',
      'Cubes = even 1 cm pieces. Minced = very small. Slices = thin. Grated = on a grater. Use a sharp knife and a steady board, fingertips curled in.'),
  Technique(['اعجن', 'عجينة'], '🫓', 'العجن', 'Kneading', '', '',
      'ضيف الماء شوية شوية واعجن بباطن إيدك 5 دقائق لحد ما العجينة تبقى ناعمة وما تلزقش في إيدك. لو لزقت ضيف معلقة دقيق.',
      'Add water little by little and knead with the heel of your hand for 5 minutes until smooth and not sticky. If it sticks, add a spoon of flour.'),
  Technique(['اخفق', 'اخفقه'], '🥚', 'الخفق', 'Whisking', '', '',
      'بالشوكة أو المضرب، حركة دائرية سريعة لحد ما الخليط يبقى لونه واحد ومافيش كتل.',
      'With a fork or whisk, fast circular motion until even and smooth with no lumps.'),
  Technique(['اهرس', 'اهرسه', 'اهرسها'], '🥄', 'الهرس', 'Mashing', '', '',
      'بالشوكة أو الهراسة، اضغط لحد ما يبقى ناعم. الخلاط لو عايزه ناعم جداً.',
      'Press with a fork or masher until smooth. Use a blender if you want it very smooth.'),
  Technique(['اخلط', 'الخلاط', 'اضرب'], '🌀', 'الخلط', 'Blending', '', '',
      'لو الخلاط: سيب الأكل يبرد شوية قبل ما تخلطه، وما تملاش الخلاط أكتر من النص لو سخن.',
      'If using a blender: let hot food cool a little first, and never fill it more than halfway with hot liquid.'),
  Technique(['صفّ', 'صفّي', 'صفّيه', 'مصفّى', 'مصفاة'], '🫗', 'التصفية', 'Draining', '', '',
      'استخدم مصفاة في الحوض واسكب الماء بعيد عن وشك عشان البخار.',
      'Use a colander in the sink and pour away from your face because of the steam.'),
  Technique(['غطّ', 'غطّي', 'غطّيه', 'غطّها'], '🍲', 'التغطية', 'Covering', '', '',
      'الغطا بيحبس البخار فالأكل يستوي أسرع ومايتنشفش. افتح الغطا بعيد عن وشك.',
      'A lid traps steam so food cooks faster and stays moist. Lift the lid away from your face.'),
  Technique(['{rice}', 'الرز', 'الأرز'], '🍚', 'طبخ الرز', 'Cooking rice', 'عالية ثم هادية', 'high, then low',
      'اغسل الرز لحد ما الماء يروق. لكل كوباية رز تقريباً كوباية ونص ماء سخن. أول ما يغلي وطّي النار لأقل حاجة وغطّيه 18-20 دقيقة وما تفتحش الغطا.',
      'Rinse the rice until the water runs clear. About 1.5 cups of hot water per cup of rice. Once it boils, turn the heat to the lowest, cover for 18-20 minutes and do not lift the lid.'),
  Technique(['{garlic}', 'الثوم'], '🧄', 'الثوم', 'Garlic', 'متوسطة', 'medium',
      'الثوم بيتحرق بسرعة ويطعم مر: دقيقة واحدة على نار متوسطة كفاية لحد ما ريحته تطلع ولونه يصفر.',
      'Garlic burns fast and turns bitter: one minute on medium heat is enough, until fragrant and pale golden.'),
  Technique(['التقلية'], '🧄', 'التقلية', 'Garlic finish (ta’leya)', 'متوسطة', 'medium',
      'ثوم مفروم مع كزبرة في زبدة أو سمن على نار متوسطة لحد ما يصفر، وتضاف للأكل في الآخر وهي بتطش.',
      'Minced garlic and coriander in butter or ghee on medium heat until golden, added to the dish at the end while sizzling.'),
];

List<Technique> techniquesFor(String step) {
  final out = <Technique>[];
  for (final t in techniques) {
    if (t.words.any(step.contains)) out.add(t);
    if (out.length >= 3) break;
  }
  return out;
}

String stepEmoji(String step) {
  final t = techniquesFor(step);
  return t.isEmpty ? '👩‍🍳' : t.first.emoji;
}

String heatFor(String step) {
  for (final t in techniquesFor(step)) {
    if (t.heat.isNotEmpty) return t.heat;
  }
  return '';
}

List<(String, String, String)> get kitchenBasics => [
      ('🧼', tx('قبل ما تبدأ', 'Before you start'),
          tx('اغسل إيدك، وجهّز كل المكونات مقطعة ومتقاسة قبل ما تشغّل النار. كده مش هتتلخبط.',
              'Wash your hands and get every ingredient cut and measured before turning on the heat. That keeps it calm.')),
      ('🔥', tx('درجات النار', 'Heat levels'),
          tx('هادية = أصغر شعلة. متوسطة = نص الشعلة. عالية = الشعلة كلها. لو مش متأكد، ابدأ متوسطة.',
              'Low = smallest flame. Medium = half. High = full flame. If unsure, start on medium.')),
      ('🥄', tx('المقادير', 'Measures'),
          tx('ملعقة صغيرة = معلقة الشاي. ملعقة كبيرة = معلقة الأكل. الكوب = كوباية الماء العادية (240 مل).',
              'tsp = teaspoon. tbsp = tablespoon. Cup = a regular water glass (240 ml).')),
      ('🧂', tx('الملح', 'Salt'),
          tx('حط نص الملح المكتوب ودوق في الآخر وزوّد. الملح الزيادة ما يتصلحش.',
              'Add half the salt, taste at the end and add more. Too much salt cannot be fixed.')),
      ('🍗', tx('الأمان', 'Safety'),
          tx('الفراخ واللحمة لازم يستووا من جوا. لا تحط الأكل السخن في التلاجة إلا بعد ما يبرد شوية، وخلّص البواقي في يومين.',
              'Chicken and meat must be cooked through. Let hot food cool a little before the fridge, and finish leftovers within two days.')),
    ];
