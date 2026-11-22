# -*- coding: utf-8 -*-
"""Egyptian kitchen: شعبيات، مكرونات، طاسة واحدة، أكلات سريعة (original recipes)."""
from recipes import R

# Explicit vibes (quick / batch / fresh / fiber are derived automatically).
VIBES = {}


def V(ids, vibes):
    for i in ids.split():
        VIBES.setdefault(i, set()).update(vibes.split())


# ======================================================== فطار شعبي
R("foul_zeit_har", "فول بالزيت الحار والكمون", "🫘", "b d", "egyptian", 10, "",
  "fava_can 2 pc; veg_oil 3 tbsp; cumin 1 tsp; chili_flakes 0.5 tsp; garlic 2 pc; lemon 1 pc; salt 0.5 tsp; arabic_bread 4 pc",
  ["سخّن {fava_can} بمائه في حلة صغيرة 5 دقائق ثم اهرسه بالشوكة.",
   "في طاسة صغيرة سخّن {veg_oil} وضع {garlic} مفروم لحد ما يصفر، ثم أطفئ النار وأضف {chili_flakes} و{cumin}.",
   "صبّ الزيت الحار على الفول وأضف {salt} وعصير {lemon}.",
   "قدّمه مع {arabic_bread}."])

R("foul_eskandarani", "فول إسكندراني", "🫘", "b d", "egyptian", 15, "",
  "fava_can 2 pc; tomato 2 pc; onion 1 pc; bell_pepper 1 pc; green_chili 1 pc; garlic 2 pc; cumin 1 tsp; olive_oil 3 tbsp; lemon 1 pc; salt 0.5 tsp; arabic_bread 4 pc",
  ["قطّع {onion} و{bell_pepper} و{green_chili} و{tomato} مكعبات صغيرة.",
   "شوّح البصل والفلفل في {olive_oil} على نار متوسطة 3 دقائق، ثم أضف {garlic} والطماطم دقيقتين.",
   "أضف {fava_can} المهروس و{cumin} و{salt} وقلّب 3 دقائق.",
   "اعصر {lemon} وقدّمه مع {arabic_bread}."])

R("foul_eggs", "فول بالبيض", "🍳", "b", "egyptian", 12, "",
  "fava_can 2 pc; eggs 4 pc; butter 2 tbsp; cumin 0.5 tsp; salt 0.5 tsp; black_pepper 0.25 tsp; arabic_bread 4 pc",
  ["ذوّب {butter} في طاسة وضع {fava_can} المهروس وقلّب دقيقتين.",
   "اعمل 4 حفر في الفول واكسر في كل حفرة بيضة من {eggs}.",
   "رشّ {cumin} و{salt} و{black_pepper}، وغطّ الطاسة 4 دقائق لحد ما البيض يستوي.",
   "قدّمه سخن مع {arabic_bread}."])
V("foul_eggs", "one_pan")

R("taameya", "طعمية مصري", "🧆", "b d", "egyptian", 40, "blender",
  "broad_beans_dry 300 g; onion 1 pc; garlic 4 pc; parsley 1 pc; coriander 1 pc; dill 1 pc; cumin 1 tsp; baking_powder 1 tsp; sesame 2 tbsp; veg_oil 500 ml; salt 1.5 tsp; arabic_bread 4 pc; tahini 3 tbsp",
  ["انقع {broad_beans_dry} في ماء من الليلة اللي قبلها (8 ساعات على الأقل) وصفّيه كويس.",
   "اطحن الفول مع {onion} و{garlic} و{parsley} و{coriander} و{dill} في الخلاط لحد ما يبقى عجينة خضرا ناعمة.",
   "أضف {cumin} و{salt} و{baking_powder} وقلّب، وسيبها 15 دقيقة.",
   "سخّن {veg_oil} على نار متوسطة، شكّل أقراص صغيرة وارشّ عليها {sesame}، واقليها 3 دقائق لحد ما تبقى بنية.",
   "قدّمها في {arabic_bread} مع طحينة: {tahini} مع ماء وليمون."])
V("taameya", "family takeout")

R("eggs_pastrami", "بيض بالبسطرمة", "🥓", "b", "egyptian", 10, "",
  "eggs 6 pc; pastrami 100 g; butter 1 tbsp; black_pepper 0.25 tsp; arabic_bread 4 pc",
  ["قطّع {pastrami} شرائح صغيرة.",
   "ذوّب {butter} في طاسة على نار متوسطة وقلّب البسطرمة دقيقة.",
   "اكسر {eggs} فوقها وارشّ {black_pepper} (من غير ملح لأن البسطرمة مالحة).",
   "غطّيها دقيقتين لحد ما البيض يستوي، وقدّمها مع {arabic_bread}."])
V("eggs_pastrami", "one_pan family")

R("roumi_omelette", "عجة بالجبنة الرومي", "🧀", "b d", "egyptian", 12, "",
  "eggs 6 pc; roumi 80 g; milk 50 ml; parsley 0.5 pc; butter 1 tbsp; black_pepper 0.25 tsp; arabic_bread 4 pc",
  ["ابشر {roumi} وافرم {parsley}.",
   "اخفق {eggs} مع {milk} و{black_pepper} ونص الجبنة والبقدونس.",
   "ذوّب {butter} في طاسة واسكب البيض، وسيبه على نار هادية 3 دقائق.",
   "رشّ باقي الجبنة واطوي العجة نصين، وقدّمها مع {arabic_bread}."])
V("roumi_omelette", "one_pan")

R("cottage_tomato", "جبنة قريش بالطماطم والخيار", "🥗", "b d", "egyptian healthy", 5, "",
  "cottage 300 g; tomato 2 pc; cucumber 2 pc; green_chili 1 pc; olive_oil 2 tbsp; mint 0.5 pc; black_pepper 0.25 tsp; arabic_bread 4 pc",
  ["قطّع {tomato} و{cucumber} و{green_chili} مكعبات صغيرة.",
   "اخلطها مع {cottage} و{black_pepper}.",
   "زيّنها بـ {olive_oil} و{mint}، وقدّمها مع {arabic_bread}."])

R("feta_tomato", "جبنة بيضا بالطماطم", "🍅", "b", "egyptian", 5, "",
  "feta 200 g; tomato 2 pc; onion 0.5 pc; olive_oil 2 tbsp; cumin 0.25 tsp; arabic_bread 4 pc",
  ["اهرس {feta} بالشوكة.",
   "أضف {tomato} و{onion} مفرومين ناعم.",
   "رشّ {cumin} وصبّ {olive_oil}، وقدّمها مع {arabic_bread}."])

R("baba_ghanoug", "بابا غنوج", "🍆", "b d", "egyptian levant healthy", 30, "oven",
  "eggplant 2 pc; tahini 3 tbsp; garlic 2 pc; lemon 1 pc; yogurt 3 tbsp; olive_oil 2 tbsp; cumin 0.5 tsp; salt 0.5 tsp; arabic_bread 4 pc",
  ["اشوي {eggplant} كاملة في الفرن على 220 درجة 25 دقيقة لحد ما تكرمش وتطرى.",
   "قشّرها واهرسها بالشوكة.",
   "اخلطها مع {tahini} و{yogurt} و{garlic} مهروس وعصير {lemon} و{cumin} و{salt}.",
   "صبّ {olive_oil} وقدّمها مع {arabic_bread}."])

R("mezze_plate", "طبق طحينة وسلطة بلدي وبابا غنوج", "🥙", "d", "egyptian healthy", 20, "",
  "tahini 5 tbsp; lemon 2 pc; garlic 2 pc; tomato 3 pc; cucumber 3 pc; onion 1 pc; green_chili 1 pc; parsley 1 pc; cumin 1 tsp; olive_oil 3 tbsp; salt 1 tsp; arabic_bread 4 pc; eggs 4 pc",
  ["الطحينة: اخفق {tahini} مع عصير نص {lemon} و{garlic} ونص كوب ماء وشوية {salt} لحد ما تبقى كريمية.",
   "السلطة البلدي: قطّع {tomato} و{cucumber} و{onion} و{green_chili} صغير جداً، وأضف {parsley} وعصير الليمونة التانية و{cumin} و{olive_oil}.",
   "اسلق {eggs} 9 دقائق وقشّرها.",
   "قدّم الكل مع {arabic_bread}."])

R("besara", "بصارة", "🥣", "l d", "egyptian healthy", 45, "blender",
  "broad_beans_dry 250 g; parsley 1 pc; coriander 1 pc; dill 1 pc; garlic 5 pc; onion 2 pc; cumin 1.5 tsp; chili_flakes 0.5 tsp; veg_oil 4 tbsp; salt 1.5 tsp; arabic_bread 4 pc",
  ["اغسل {broad_beans_dry} واسلقه في 5 كوبايات ماء 30 دقيقة لحد ما يستوي ويتهرس.",
   "أضف {parsley} و{coriander} و{dill} و{garlic} واطبخهم 5 دقائق، ثم اضربهم في الخلاط مع {cumin} و{salt}.",
   "قطّع {onion} شرائح رفيعة وحمّرها في {veg_oil} لحد ما تبقى بنية مقرمشة (التقلية).",
   "قدّم البصارة وعليها البصل و{chili_flakes} مع {arabic_bread}."])
V("besara", "comfort")

R("belila", "بليلة باللبن", "🥣", "b", "egyptian", 15, "",
  "wheat 200 g; milk 800 ml; sugar 3 tbsp; raisins 40 g; almonds 30 g; cinnamon 0.5 tsp",
  ["اسلق {wheat} من الليلة اللي قبلها في ماء ساعة لحد ما يطرى (أو استخدم قمح مسلوق جاهز).",
   "سخّن {milk} مع {sugar} لحد ما يغلي.",
   "وزّع القمح في الأطباق واسكب اللبن السخن عليه.",
   "زيّنها بـ {raisins} و{almonds} و{cinnamon}."])
V("belila", "comfort family")

R("roz_bel_laban", "أرز باللبن", "🍚", "b", "egyptian", 40, "",
  "rice 0.75 cup; milk 1000 ml; sugar 5 tbsp; cinnamon 0.5 tsp; raisins 30 g",
  ["اغسل {rice} واسلقه في كوباية ماء 10 دقائق لحد ما ينشف.",
   "أضف {milk} وسيبه على نار هادية 25 دقيقة مع التقليب كل شوية عشان ما يلزقش.",
   "أضف {sugar} وقلّب 3 دقائق.",
   "صبّه في أكواب وزيّنه بـ {cinnamon} و{raisins}. يتاكل سخن أو بارد."])
V("roz_bel_laban", "comfort family")

R("veg_omelette", "أومليت بالخضار", "🍳", "b d", "egyptian healthy", 12, "",
  "eggs 6 pc; tomato 1 pc; bell_pepper 1 pc; onion 0.5 pc; parsley 0.5 pc; olive_oil 1 tbsp; salt 0.5 tsp; black_pepper 0.25 tsp; toast 4 pc",
  ["قطّع {onion} و{bell_pepper} و{tomato} صغير وافرم {parsley}.",
   "شوّح الخضار في {olive_oil} 3 دقائق.",
   "اخفق {eggs} مع {salt} و{black_pepper} وصبّه على الخضار، وغطّي الطاسة على نار هادية 4 دقائق.",
   "قدّمه مع {toast}."])
V("veg_omelette", "one_pan")

R("shakshuka_roumi", "شكشوكة بالجبنة الرومي", "🍳", "b d", "egyptian", 15, "",
  "eggs 6 pc; tomato 3 pc; onion 1 pc; green_chili 1 pc; roumi 60 g; cumin 0.5 tsp; veg_oil 2 tbsp; salt 0.5 tsp; arabic_bread 4 pc",
  ["حمّر {onion} مفروم في {veg_oil} 3 دقائق، ثم أضف {green_chili} و{tomato} مبشورة و{cumin} و{salt} وسيبها 5 دقائق.",
   "اكسر {eggs} فوق الصلصة وقلّب بالراحة.",
   "ابشر {roumi} فوقها وغطّيها دقيقتين.",
   "قدّمها مع {arabic_bread}."])
V("shakshuka_roumi", "one_pan")

R("liver_alex", "كبدة إسكندراني", "🌶️", "b d", "egyptian", 20, "",
  "beef_liver 500 g; bell_pepper 2 pc; green_chili 2 pc; garlic 5 pc; cumin 1 tsp; lemon 1 pc; vinegar 1 tbsp; veg_oil 3 tbsp; salt 1 tsp; black_pepper 0.5 tsp; arabic_bread 4 pc",
  ["قطّع {beef_liver} شرائح رفيعة جداً وتبّلها بـ {cumin} و{black_pepper} و{vinegar} (الملح في الآخر عشان ما تنشفش).",
   "سخّن {veg_oil} على نار عالية جداً وقلّب الكبدة 4 دقائق بس.",
   "أضف {garlic} و{bell_pepper} و{green_chili} شرائح وقلّب دقيقتين.",
   "أضف {salt} وعصير {lemon}، واحشيها في {arabic_bread}."])
V("liver_alex", "one_pan takeout")

R("cheese_pasta_eg", "مكرونة بالجبنة والصلصة البيضا", "🧀", "l d", "egyptian italian", 20, "",
  "pasta 500 g; milk 500 ml; butter 2 tbsp; flour 2 tbsp; roumi 100 g; mozzarella 100 g; salt 1 tsp; black_pepper 0.5 tsp",
  ["اسلق {pasta} في ماء مغلي بملح حسب الكيس وصفّيها.",
   "في نفس الحلة ذوّب {butter} وأضف {flour} وقلّب دقيقة.",
   "أضف {milk} شوية شوية وأنت بتقلّب لحد ما يتقل، ثم {roumi} و{mozzarella} و{salt} و{black_pepper}.",
   "رجّع المكرونة وقلّبها في الصوص وقدّمها على طول."])
V("cheese_pasta_eg", "family comfort")

# ======================================================== محاشي وطبيخ
R("mahshi_mix", "محشي مشكل (كوسة وباذنجان وفلفل)", "🫑", "l", "egyptian", 100, "",
  "zucchini 600 g; eggplant 2 pc; bell_pepper 4 pc; rice 2 cup; tomato 3 pc; onion 1 pc; parsley 1 pc; dill 1 pc; mint 1 pc; tomato_paste 2 tbsp; veg_oil 4 tbsp; stock_cube 1 pc; salt 2 tsp; black_pepper 0.5 tsp",
  ["فرّغ {zucchini} و{eggplant} الصغيرة و{bell_pepper} من جوه بالمقورة أو ملعقة صغيرة.",
   "الخلطة: اغسل {rice} واخلطه مع {onion} و{tomato} مفرومين، و{parsley} و{dill} و{mint} مفرومين، ونص {veg_oil} ونص {salt} و{black_pepper}.",
   "احشي الخضار لحد ثلاثة أرباعها بس (الرز بيكبر)، ورصّها واقفة في حلة.",
   "اخلط {tomato_paste} مع 3 كوبايات ماء سخن و{stock_cube} وباقي الزيت والملح، وصبّه على المحشي.",
   "حط طبق مقلوب فوق المحشي، وسيبه على نار عالية لحد ما يغلي ثم هادية 50 دقيقة لحد ما الرز يستوي."])
V("mahshi_mix", "family comfort")

R("warak_enab", "ورق عنب محشي", "🍃", "l d", "egyptian levant", 90, "",
  "grape_leaves 400 g; rice 2 cup; tomato 3 pc; onion 1 pc; parsley 1 pc; dill 1 pc; lemon 2 pc; veg_oil 5 tbsp; stock_cube 1 pc; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["اغسل {grape_leaves} وحطه في ماء سخن دقيقتين عشان يطرى، وشيل العروق التخينة.",
   "اخلط {rice} المغسول مع {tomato} و{onion} مفرومين و{parsley} و{dill} ونص {veg_oil} و{salt} و{black_pepper}.",
   "حط ورقة الوش الناعم لتحت، ملعقة صغيرة خلطة، واطوي الجوانب ولفّها زي السيجارة مش مشدودة أوي.",
   "رصّها في الحلة، وأضف 3 كوبايات ماء سخن مع {stock_cube} وعصير {lemon} وباقي الزيت.",
   "حط طبق فوقها واطبخها على نار هادية 50 دقيقة."])
V("warak_enab", "family comfort")

R("cabbage_mahshi_eg", "محشي كرنب مصري", "🥬", "l", "egyptian", 100, "",
  "cabbage 1 pc; rice 2 cup; tomato 3 pc; onion 1 pc; garlic 4 pc; parsley 1 pc; dill 1 pc; cumin 2 tsp; tomato_paste 2 tbsp; veg_oil 4 tbsp; stock_cube 1 pc; salt 2 tsp",
  ["افصل ورق {cabbage} واسلقه 5 دقائق لحد ما يطرى، وقطّع كل ورقة 2 أو 3.",
   "اخلط {rice} مع {tomato} و{onion} مفرومين و{parsley} و{dill} ونص {cumin} ونص {salt} و{tomato_paste} ونص {veg_oil}.",
   "لفّ كل قطعة كرنب على ملعقة صغيرة خلطة زي الصابع، ورصّها في الحلة.",
   "أضف 3 كوبايات ماء سخن مع {stock_cube} وباقي الملح والزيت، واطبخه 50 دقيقة على نار هادية.",
   "آخر 5 دقائق: حمّر {garlic} مفروم مع باقي الكمون في معلقة زيت وصبّه عليه."])
V("cabbage_mahshi_eg", "family comfort")

R("stuffed_peppers_meat", "فلفل محشي باللحمة المفرومة", "🫑", "l", "egyptian levant", 70, "oven",
  "bell_pepper 6 pc; minced_beef 400 g; rice 1 cup; onion 1 pc; tomato 2 pc; tomato_paste 2 tbsp; seven_spice 1.5 tsp; parsley 1 pc; veg_oil 2 tbsp; salt 1.5 tsp",
  ["اقطع غطا {bell_pepper} وفضّيه من البذر.",
   "اخلط {minced_beef} مع {rice} المغسول و{onion} و{tomato} مفرومين و{parsley} و{seven_spice} ونص {salt}.",
   "احشي الفلفل ورصّه في صينية عميقة.",
   "اخلط {tomato_paste} مع كوبايتين ماء وباقي الملح و{veg_oil} وصبّه حواليه، وغطّي الصينية بالقصدير.",
   "اخبزه على 190 درجة 50 دقيقة، وشيل القصدير آخر 10 دقائق."])
V("stuffed_peppers_meat", "family comfort")

R("molokhia_shrimp", "ملوخية بالجمبري", "🦐", "l", "egyptian", 30, "",
  "molokhia 800 g; shrimp 500 g; garlic 8 pc; coriander 1 pc; butter 2 tbsp; stock_cube 1 pc; lemon 1 pc; salt 1 tsp; rice 2 cup",
  ["اطبخ {rice} أبيض.",
   "غلّي 4 كوبايات ماء مع {stock_cube}، وأضف {molokhia} وقلّب، وأول ما تغلي وطّي النار (ما تسيبهاش تغلي كتير عشان ما تنزلش).",
   "في طاسة، ذوّب {butter} وقلّب {shrimp} مع نص {garlic} و{salt} 3 دقائق.",
   "التقلية: حمّر باقي الثوم مع {coriander} لحد ما يصفر وضيفه على الملوخية، ثم الجمبري.",
   "قدّمها مع الرز و{lemon}."])

R("bamia_chicken", "بامية بالفراخ", "🌱", "l", "egyptian", 50, "",
  "okra 800 g; chicken_thigh 700 g; onion 1 pc; garlic 4 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; coriander 1 pc; veg_oil 3 tbsp; stock_cube 1 pc; salt 1 tsp; black_pepper 0.5 tsp; rice 2 cup",
  ["حمّر {chicken_thigh} مقطع مع {onion} في {veg_oil} 7 دقائق.",
   "أضف {tomato_paste} و{crushed_tomatoes} و2 كوباية ماء و{stock_cube} و{salt} و{black_pepper}، وسيبه 15 دقيقة.",
   "أضف {okra} واطبخه 20 دقيقة على نار هادية.",
   "حمّر {garlic} مع {coriander} في معلقة زيت وضيفها آخر 5 دقائق.",
   "قدّمها مع {rice}."])
V("bamia_chicken", "family comfort")

R("peas_chicken", "بسلة بالجزر والفراخ", "🫛", "l", "egyptian", 45, "",
  "peas_carrots 900 g; chicken_breast 600 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; veg_oil 2 tbsp; stock_cube 1 pc; salt 1 tsp; black_pepper 0.5 tsp; rice 2 cup; vermicelli 50 g",
  ["قطّع {chicken_breast} مكعبات وحمّرها مع {onion} في {veg_oil} 5 دقائق.",
   "أضف {garlic} و{tomato_paste} وقلّب دقيقة، ثم {peas_carrots} و2 كوباية ماء و{stock_cube} و{salt} و{black_pepper}.",
   "سيبها 25 دقيقة على نار هادية لحد ما الصلصة تتقل.",
   "حمّر {vermicelli} في شوية زيت لحد ما تبقى بنية، وأضف {rice} و3.5 كوباية ماء واطبخه 20 دقيقة.",
   "قدّم البسلة مع الرز بالشعرية."])
V("peas_chicken", "family comfort")

R("chicken_potato_tray", "صينية فراخ بالبطاطس والصلصة", "🥔", "l", "egyptian", 70, "oven",
  "chicken_thigh 900 g; potato 5 pc; onion 2 pc; tomato 3 pc; tomato_paste 2 tbsp; garlic 4 pc; bell_pepper 1 pc; seven_spice 1.5 tsp; paprika 1 tsp; veg_oil 3 tbsp; stock_cube 1 pc; salt 1.5 tsp",
  ["تبّل {chicken_thigh} بـ {seven_spice} و{paprika} و{garlic} ونص {salt}.",
   "قطّع {potato} و{onion} شرائح، و{bell_pepper} و{tomato} حلقات، ورصّهم في صينية.",
   "اخلط {tomato_paste} مع كوباية ونص ماء سخن و{stock_cube} و{veg_oil} وباقي الملح وصبّه على الخضار.",
   "حط الفراخ فوق، وغطّي الصينية بالقصدير واخبزها على 200 درجة 40 دقيقة.",
   "شيل القصدير وسيبها 15 دقيقة كمان لحد ما الفراخ تحمر."])
V("chicken_potato_tray", "family comfort one_pan")

R("zucchini_sauce", "كوسة بالصلصة", "🥒", "l d", "egyptian healthy", 35, "",
  "zucchini 1000 g; onion 1 pc; garlic 3 pc; tomato_paste 2 tbsp; crushed_tomatoes 1 pc; veg_oil 2 tbsp; stock_cube 1 pc; salt 1 tsp; black_pepper 0.5 tsp; rice 2 cup",
  ["قطّع {zucchini} حلقات وحمّرها شوية في {veg_oil} وطلّعها.",
   "حمّر {onion} و{garlic}، وأضف {tomato_paste} و{crushed_tomatoes} وكوباية ماء و{stock_cube} و{salt} و{black_pepper}.",
   "رجّع الكوسة واطبخها 15 دقيقة لحد ما تطرى.",
   "قدّمها مع {rice}."])

R("qolqas", "قلقاس بالخضرة", "🥔", "l", "egyptian", 60, "",
  "taro 800 g; beef_cubes 400 g; spinach 300 g; coriander 1 pc; garlic 6 pc; lemon 1 pc; butter 2 tbsp; stock_cube 1 pc; salt 1.5 tsp; rice 2 cup",
  ["اسلق {beef_cubes} في ماء يغطيه مع {stock_cube} 40 دقيقة.",
   "قشّر {taro} بجوانتي (عشان ما يهرشش)، وقطّعه مكعبات واغسله كويس.",
   "اضرب {spinach} و{coriander} في الخلاط مع شوية مرقة.",
   "أضف القلقاس والخضرة للحمة و{salt}، واطبخه 20 دقيقة.",
   "حمّر {garlic} في {butter} وضيفه مع عصير {lemon}، وقدّمه مع {rice}."])
V("qolqas", "comfort")

R("lobia", "لوبيا بالصلصة", "🫘", "l", "egyptian healthy", 30, "",
  "black_eyed_peas 2 pc; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; cumin 1 tsp; coriander 1 pc; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup",
  ["حمّر {onion} في {veg_oil} 4 دقائق، وأضف {garlic} و{tomato_paste} وقلّب دقيقة.",
   "أضف {crushed_tomatoes} و{black_eyed_peas} بمائها و{cumin} و{salt} ونص كوباية ماء.",
   "سيبها 15 دقيقة على نار هادية، وأضف {coriander} مفرومة.",
   "قدّمها مع {rice}."])

R("adas_abu_gebba", "عدس أبو جبة بالصلصة", "🫘", "l d", "egyptian healthy", 45, "",
  "brown_lentils 300 g; onion 2 pc; garlic 3 pc; tomato_paste 2 tbsp; tomato 2 pc; cumin 1.5 tsp; veg_oil 3 tbsp; salt 1.5 tsp; lemon 1 pc; arabic_bread 4 pc",
  ["اسلق {brown_lentils} في 5 كوبايات ماء 25 دقيقة.",
   "حمّر {onion} و{garlic} في {veg_oil}، وأضف {tomato} مبشورة و{tomato_paste} و{cumin}.",
   "ضيف الصلصة للعدس مع {salt} وسيبه 10 دقائق لحد ما يتقل.",
   "اعصر {lemon} وقدّمه مع {arabic_bread}."])
V("adas_abu_gebba", "comfort")

R("roz_moammar", "رز معمر بالفرن", "🍚", "l", "egyptian", 75, "oven",
  "rice 2.5 cup; milk 750 ml; cream 200 ml; butter 4 tbsp; chicken_whole 1 pc; stock_cube 1 pc; salt 1.5 tsp",
  ["اسلق {chicken_whole} مقطع في ماء مع {stock_cube} 35 دقيقة، وخلّي كوباية من المرقة.",
   "اخلط {rice} المغسول مع {milk} و{cream} والمرقة و{salt} ونص {butter} في صينية فخار أو بايركس.",
   "حط باقي الزبدة على الوش، واخبزه على 180 درجة 45 دقيقة لحد ما الوش يحمر.",
   "حمّر الفراخ وقدّمها معاه."])
V("roz_moammar", "family comfort")

R("roz_khalta", "رز بالخلطة (بالكبد والمكسرات)", "🍚", "l", "egyptian", 50, "",
  "rice 3 cup; chicken_liver 300 g; onion 1 pc; almonds 50 g; raisins 40 g; cardamom 4 pc; cinnamon 1 pc; butter 3 tbsp; stock_cube 1 pc; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["قطّع {chicken_liver} صغير جداً وحمّره مع {onion} في نص {butter} 5 دقائق.",
   "أضف {rice} المغسول و{cardamom} و{cinnamon} و{black_pepper} وقلّب دقيقتين.",
   "أضف 5 كوبايات ماء سخن مع {stock_cube} و{salt}، واطبخه على نار هادية 20 دقيقة.",
   "حمّر {almonds} و{raisins} في باقي الزبدة ورشّهم على الرز."])
V("roz_khalta", "family")

R("fried_chicken_eg", "فراخ محمرة مع رز", "🍗", "l", "egyptian", 60, "",
  "chicken_whole 1 pc; onion 1 pc; cardamom 4 pc; bay_leaf 2 pc; garlic 3 pc; paprika 1 tsp; butter 3 tbsp; salt 1.5 tsp; black_pepper 0.5 tsp; rice 2 cup; vermicelli 50 g",
  ["اسلق {chicken_whole} مقطع مع {onion} و{cardamom} و{bay_leaf} في 5 كوبايات ماء 30 دقيقة.",
   "طلّع الفراخ ونشّفها، وادهنها بـ {garlic} و{paprika} و{black_pepper} ونص {salt}.",
   "حمّرها في {butter} في طاسة 4 دقائق كل جهة لحد ما تبقى دهبية.",
   "حمّر {vermicelli} وأضف {rice} و3.5 كوباية من المرقة وباقي الملح، واطبخه 20 دقيقة.",
   "قدّم الفراخ مع الرز."])
V("fried_chicken_eg", "family comfort")

R("yogurt_chicken_legs", "أوراك فراخ بالزبادي والليمون", "🍗", "l d", "egyptian healthy", 50, "oven",
  "chicken_thigh 1000 g; yogurt 200 g; lemon 2 pc; garlic 5 pc; paprika 2 tsp; cumin 1 tsp; olive_oil 2 tbsp; salt 1.5 tsp; rice 2 cup",
  ["اخلط {yogurt} مع عصير {lemon} و{garlic} و{paprika} و{cumin} و{olive_oil} و{salt}.",
   "تبّل {chicken_thigh} وسيبها ساعة في التلاجة لو تقدر.",
   "رصّها في صينية واشويها على 210 درجة 35 دقيقة لحد ما تحمر.",
   "قدّمها مع {rice}."])

R("kofta_tray_eg", "كفتة صينية بالطماطم والبطاطس", "🥘", "l", "egyptian", 60, "oven",
  "minced_beef 600 g; onion 2 pc; parsley 1 pc; potato 4 pc; tomato 3 pc; bell_pepper 1 pc; tomato_paste 2 tbsp; seven_spice 2 tsp; veg_oil 2 tbsp; salt 1.5 tsp; rice 2 cup",
  ["اخلط {minced_beef} مع نص {onion} مبشور ومعصور و{parsley} و{seven_spice} ونص {salt}، وشكّلها أصابع.",
   "قطّع {potato} و{tomato} و{bell_pepper} والبصلة التانية حلقات، ورصّهم مع الكفتة في صينية.",
   "اخلط {tomato_paste} مع كوباية ونص ماء و{veg_oil} وباقي الملح وصبّه.",
   "اخبزها على 200 درجة 40 دقيقة، وقدّمها مع {rice}."])
V("kofta_tray_eg", "family comfort")

R("kofta_rice", "كفتة الرز بالصلصة", "🧆", "l", "egyptian", 60, "",
  "minced_beef 500 g; rice 0.5 cup; onion 2 pc; parsley 1 pc; dill 1 pc; flour 4 tbsp; crushed_tomatoes 2 pc; tomato_paste 1 tbsp; seven_spice 1.5 tsp; veg_oil 4 tbsp; salt 1.5 tsp; arabic_bread 4 pc",
  ["اطحن {rice} النيء في الخلاط شوية، واخلطه مع {minced_beef} ونص {onion} مبشور و{parsley} و{dill} و{seven_spice} ونص {salt}.",
   "شكّلها كور متوسطة وغلّفها بـ {flour}، وحمّرها في {veg_oil}.",
   "حمّر البصلة التانية وأضف {crushed_tomatoes} و{tomato_paste} وكوبايتين ماء وباقي الملح.",
   "حط الكور في الصلصة واطبخها 30 دقيقة على نار هادية.",
   "قدّمها مع {arabic_bread}."])
V("kofta_rice", "family comfort")

R("kebab_halla", "كباب حلة", "🥩", "l", "egyptian", 90, "",
  "beef_cubes 800 g; onion 4 pc; garlic 3 pc; tomato_paste 1 tbsp; cardamom 3 pc; bay_leaf 2 pc; veg_oil 3 tbsp; salt 1.5 tsp; black_pepper 0.5 tsp; rice 2 cup; potato 3 pc",
  ["حمّر {beef_cubes} في {veg_oil} على نار عالية من كل الجهات.",
   "أضف {onion} شرائح كتير وقلّب لحد ما يدبل ويبقى دهبي.",
   "أضف {garlic} و{tomato_paste} و{cardamom} و{bay_leaf} و{black_pepper} وكوبايتين ماء، وغطّيه على نار هادية ساعة.",
   "أضف {potato} مكعبات و{salt} آخر 20 دقيقة.",
   "قدّمه مع {rice}."])
V("kebab_halla", "comfort family")

R("fatta_eid", "فتة مصري باللحمة", "🍖", "l", "egyptian", 100, "",
  "beef_cubes 800 g; rice 2.5 cup; arabic_bread 3 pc; garlic 8 pc; vinegar 4 tbsp; tomato_paste 2 tbsp; crushed_tomatoes 1 pc; butter 3 tbsp; cardamom 4 pc; bay_leaf 2 pc; salt 2 tsp",
  ["اسلق {beef_cubes} في ماء مع {cardamom} و{bay_leaf} ساعة وربع لحد ما تستوي، وخلّي المرقة.",
   "اطبخ {rice} في 4 كوبايات مرقة مع نص {salt}.",
   "حمّص {arabic_bread} مقطّع في الفرن، وبلّه بكوباية مرقة.",
   "الصلصة: حمّر {garlic} في {butter}، وأضف {vinegar} (هتفور)، ثم {tomato_paste} و{crushed_tomatoes} وكوباية مرقة وباقي الملح 10 دقائق.",
   "رصّ العيش ثم الرز ثم اللحمة، وصبّ الصلصة."])
V("fatta_eid", "family comfort")

R("koshari_alex", "كشري إسكندراني أصفر", "🍛", "l d", "egyptian healthy", 40, "",
  "rice 2 cup; red_lentils 200 g; onion 2 pc; cumin 1.5 tsp; veg_oil 4 tbsp; salt 1.5 tsp; tomato 3 pc; cucumber 2 pc; lemon 1 pc",
  ["اغسل {red_lentils} و{rice}.",
   "حمّر نص {onion} شرائح في {veg_oil} لحد ما تبقى بنية وطلّعها.",
   "في نفس الزيت أضف العدس والرز و{cumin} و{salt} وقلّب، ثم 4.5 كوباية ماء.",
   "اطبخه على نار هادية 25 دقيقة.",
   "قدّمه بالبصل المحمر وسلطة {tomato} و{cucumber} والبصلة التانية بعصير {lemon}."])

R("lesan_asfour_soup", "شوربة لسان عصفور", "🍲", "d", "egyptian", 25, "",
  "orzo 200 g; chicken_breast 300 g; onion 1 pc; carrot 1 pc; butter 1 tbsp; stock_cube 1 pc; cardamom 2 pc; lemon 1 pc; salt 1 tsp; black_pepper 0.25 tsp",
  ["اسلق {chicken_breast} مع {onion} و{carrot} و{cardamom} و{stock_cube} في 7 كوبايات ماء 15 دقيقة، وقطّع الفراخ صغير.",
   "حمّر {orzo} في {butter} لحد ما يبقى دهبي.",
   "أضف المرقة المصفاة و{salt} و{black_pepper}، واطبخها 10 دقائق.",
   "رجّع الفراخ وقدّمها مع {lemon}."])
V("lesan_asfour_soup", "comfort family")

R("lentil_vermicelli_soup", "شوربة عدس بالشعرية", "🥣", "d", "egyptian healthy", 30, "blender",
  "red_lentils 250 g; vermicelli 60 g; onion 1 pc; carrot 1 pc; tomato 1 pc; garlic 2 pc; cumin 1.5 tsp; butter 1 tbsp; stock_cube 1 pc; salt 1 tsp; lemon 1 pc; arabic_bread 2 pc",
  ["اسلق {red_lentils} مع {onion} و{carrot} و{tomato} و{garlic} في 6 كوبايات ماء مع {stock_cube} 20 دقيقة.",
   "اضربها في الخلاط مع {cumin} و{salt}.",
   "حمّر {vermicelli} في {butter} وضيفها للشوربة واطبخها 5 دقائق.",
   "قدّمها مع {lemon} و{arabic_bread} محمص."])
V("lentil_vermicelli_soup", "comfort")

R("fish_alex_oven", "سمك بالفرن على الطريقة السكندراني", "🐟", "l d", "egyptian healthy", 40, "oven",
  "fish_fillet 800 g; tomato 3 pc; bell_pepper 1 pc; onion 1 pc; garlic 5 pc; lemon 2 pc; cumin 1.5 tsp; coriander 1 pc; olive_oil 4 tbsp; salt 1.5 tsp; rice 2 cup",
  ["الردة: اخلط {garlic} مهروس مع {cumin} و{coriander} مفرومة وعصير نص {lemon} و{olive_oil} و{salt}.",
   "ادهن {fish_fillet} بالخلطة كويس.",
   "رصّ {onion} و{tomato} و{bell_pepper} حلقات في صينية، وحط السمك فوقهم مع الليمونة التانية شرايح.",
   "اخبزه على 200 درجة 25 دقيقة، وقدّمه مع {rice}."])

R("shrimp_grill_eg", "جمبري مشوي بالردة مع رز صيادية", "🦐", "l d", "egyptian", 40, "oven",
  "shrimp 700 g; garlic 5 pc; cumin 1.5 tsp; lemon 2 pc; coriander 1 pc; olive_oil 3 tbsp; paprika 1 tsp; rice 2 cup; onion 1 pc; salt 1.5 tsp",
  ["تبّل {shrimp} بـ {garlic} و{cumin} و{paprika} وعصير نص {lemon} و{olive_oil} ونص {salt}.",
   "حمّر {onion} شرائح لحد ما تبقى غامقة، وأضف {rice} و3.5 كوباية ماء وباقي الملح واطبخه 20 دقيقة.",
   "اشوي الجمبري في الفرن على 220 درجة 8 دقائق بس.",
   "زيّنه بـ {coriander} والليمونة التانية، وقدّمه مع الرز."])

R("fish_pane", "فيليه سمك بانيه مع طحينة", "🐟", "l d", "egyptian", 30, "",
  "fish_fillet 700 g; eggs 2 pc; breadcrumbs 150 g; flour 4 tbsp; cumin 1 tsp; lemon 1 pc; veg_oil 6 tbsp; salt 1 tsp; tahini 4 tbsp; tomato 2 pc; cucumber 2 pc",
  ["تبّل {fish_fillet} بـ {cumin} و{salt} ونص عصير {lemon}.",
   "عدّيه على {flour} ثم {eggs} المخفوق ثم {breadcrumbs}.",
   "اقليه في {veg_oil} 3 دقائق كل جهة على نار متوسطة.",
   "اعمل طحينة بـ {tahini} وباقي الليمون وماء، وقدّمه مع سلطة {tomato} و{cucumber}."])
V("fish_pane", "family takeout")

R("chicken_strips", "استربس فراخ مقرمش", "🍗", "d", "egyptian western", 30, "air_fryer",
  "chicken_breast 700 g; breadcrumbs 150 g; flour 4 tbsp; eggs 2 pc; paprika 2 tsp; garlic 2 pc; salt 1.5 tsp; veg_oil 2 tbsp; potato 4 pc; ketchup 4 tbsp",
  ["قطّع {chicken_breast} أصابع، وتبّلها بـ {paprika} و{garlic} ونص {salt}.",
   "عدّيها على {flour} ثم {eggs} ثم {breadcrumbs}، وادهنها بـ {veg_oil}.",
   "قطّع {potato} صوابع بباقي الملح.",
   "اشوي البطاطس 15 دقيقة ثم الفراخ 12 دقيقة في القلاية على 200 درجة.",
   "قدّمها مع {ketchup}."])
V("chicken_strips", "family takeout")

R("shawarma_fatta", "فتة شاورما فراخ", "🌯", "l d", "egyptian levant", 40, "",
  "chicken_thigh 700 g; arabic_bread 3 pc; rice 2 cup; yogurt 300 g; mayo 3 tbsp; garlic 6 pc; lemon 2 pc; seven_spice 2 tsp; paprika 1 tsp; vinegar 1 tbsp; veg_oil 2 tbsp; salt 1.5 tsp",
  ["قطّع {chicken_thigh} شرايح وتبّلها بـ {seven_spice} و{paprika} و{vinegar} ونص {garlic} وعصير نص {lemon} ونص {salt}.",
   "شوّحها في {veg_oil} على نار عالية لحد ما تحمر.",
   "اطبخ {rice} أبيض بباقي الملح، وحمّص {arabic_bread} مقطّع.",
   "الثومية: {yogurt} مع {mayo} وباقي الثوم والليمون.",
   "رصّ العيش ثم الرز ثم الشاورما، وصبّ الثومية."])
V("shawarma_fatta", "takeout family")

R("mashed_grilled_chicken", "فراخ مشوية مع بطاطس بيوريه", "🥔", "l d", "egyptian western", 45, "oven",
  "chicken_breast 700 g; potato 5 pc; milk 150 ml; butter 2 tbsp; garlic 3 pc; lemon 1 pc; paprika 1 tsp; oregano 1 tsp; olive_oil 2 tbsp; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["تبّل {chicken_breast} بـ {garlic} و{paprika} و{oregano} وعصير {lemon} و{olive_oil} ونص {salt}.",
   "اشويها في الفرن على 210 درجة 20 دقيقة.",
   "اسلق {potato} مقشر 20 دقيقة، واهرسه مع {milk} السخن و{butter} وباقي الملح و{black_pepper}.",
   "قدّم الفراخ شرائح مع البيوريه."])
V("mashed_grilled_chicken", "family")

# ======================================================== مكرونات
R("pasta_red_sauce", "مكرونة بالصلصة الحمرا", "🍝", "l d", "egyptian italian", 25, "",
  "pasta 500 g; crushed_tomatoes 2 pc; tomato_paste 1 tbsp; onion 1 pc; garlic 3 pc; bell_pepper 1 pc; veg_oil 2 tbsp; sugar 0.5 tsp; salt 1 tsp; black_pepper 0.5 tsp",
  ["اسلق {pasta} حسب الكيس وصفّيها.",
   "حمّر {onion} و{bell_pepper} في {veg_oil}، وأضف {garlic} دقيقة.",
   "أضف {crushed_tomatoes} و{tomato_paste} و{sugar} و{salt} و{black_pepper} وسيبها 10 دقائق.",
   "قلّب المكرونة في الصلصة وقدّمها."])
V("pasta_red_sauce", "family")

R("pasta_white_chicken", "مكرونة بالوايت صوص والفراخ", "🍗", "l d", "egyptian italian", 30, "",
  "pasta 500 g; chicken_breast 500 g; milk 500 ml; cream 200 ml; butter 2 tbsp; flour 2 tbsp; garlic 3 pc; mushroom 200 g; mozzarella 100 g; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["اسلق {pasta} وصفّيها.",
   "قطّع {chicken_breast} مكعبات وشوّحها في {butter} مع {garlic} ونص {salt} 6 دقائق، وأضف {mushroom} 3 دقائق.",
   "رشّ {flour} وقلّب دقيقة، ثم {milk} و{cream} شوية شوية لحد ما الصوص يتقل.",
   "أضف {mozzarella} وباقي الملح و{black_pepper}، وقلّب المكرونة فيه."])
V("pasta_white_chicken", "family comfort")

R("pasta_shrimp_sauce", "مكرونة بالجمبري والصلصة", "🦐", "l d", "egyptian italian", 25, "",
  "spaghetti 500 g; shrimp 500 g; crushed_tomatoes 2 pc; garlic 5 pc; onion 1 pc; chili_flakes 0.5 tsp; coriander 1 pc; olive_oil 3 tbsp; salt 1 tsp",
  ["اسلق {spaghetti}.",
   "حمّر {onion} و{garlic} في {olive_oil}، وأضف {crushed_tomatoes} و{chili_flakes} و{salt} 8 دقائق.",
   "أضف {shrimp} وسيبه 4 دقائق بس.",
   "قلّب المكرونة في الصلصة وزيّنها بـ {coriander}."])

R("pasta_oven_veg", "مكرونة فرن بالخضار", "🥦", "l d", "egyptian italian", 45, "oven",
  "pasta 500 g; zucchini 1 pc; bell_pepper 1 pc; broccoli 300 g; mushroom 200 g; crushed_tomatoes 1 pc; milk 400 ml; butter 2 tbsp; flour 2 tbsp; mozzarella 150 g; salt 1.5 tsp",
  ["اسلق {pasta} 6 دقائق بس.",
   "شوّح {zucchini} و{bell_pepper} و{mushroom} و{broccoli} 5 دقائق، وأضف {crushed_tomatoes} ونص {salt}.",
   "اعمل صوص أبيض: {butter} + {flour} ثم {milk} شوية شوية وباقي الملح.",
   "اخلط المكرونة مع الخضار والصوص في صينية، ورشّ {mozzarella}.",
   "اخبزها على 200 درجة 20 دقيقة."])
V("pasta_oven_veg", "family")

R("pasta_pastrami_cream", "مكرونة بالبسطرمة والكريمة", "🥓", "l d", "egyptian italian", 20, "",
  "pasta 500 g; pastrami 150 g; cream 250 ml; milk 150 ml; garlic 2 pc; butter 1 tbsp; black_pepper 0.5 tsp; mozzarella 80 g",
  ["اسلق {pasta}.",
   "قطّع {pastrami} صغير وشوّحها في {butter} مع {garlic} دقيقتين.",
   "أضف {cream} و{milk} و{black_pepper} وسيبهم يغلوا دقيقتين، ثم {mozzarella}.",
   "قلّب المكرونة في الصوص. (من غير ملح، البسطرمة مالحة)"])
V("pasta_pastrami_cream", "takeout")

R("one_pot_pasta_meat", "مكرونة طاسة واحدة باللحمة والصلصة", "🍝", "l d", "egyptian", 25, "",
  "pasta 400 g; minced_beef 400 g; onion 1 pc; garlic 3 pc; crushed_tomatoes 2 pc; tomato_paste 1 tbsp; seven_spice 1 tsp; veg_oil 1 tbsp; stock_cube 1 pc; salt 1 tsp; mozzarella 80 g",
  ["في طاسة عميقة، حمّر {onion} في {veg_oil} ثم {minced_beef} و{garlic} و{seven_spice} لحد ما اللحمة تتحمر.",
   "أضف {crushed_tomatoes} و{tomato_paste} و3 كوبايات ماء و{stock_cube} و{salt}.",
   "أول ما يغلي أضف {pasta} النية وقلّب، وغطّيها على نار متوسطة 12 دقيقة مع التقليب كل شوية.",
   "رشّ {mozzarella} وغطّيها دقيقة لحد ما تسيح."])
V("one_pot_pasta_meat", "one_pan family")

R("pasta_tuna_eg", "مكرونة بالتونة والفلفل الألوان", "🐟", "l d", "egyptian", 20, "",
  "pasta 500 g; tuna_can 2 pc; bell_pepper 2 pc; onion 1 pc; garlic 2 pc; crushed_tomatoes 1 pc; olive_oil 2 tbsp; oregano 1 tsp; salt 1 tsp",
  ["اسلق {pasta}.",
   "شوّح {onion} و{bell_pepper} و{garlic} في {olive_oil} 4 دقائق.",
   "أضف {crushed_tomatoes} و{oregano} و{salt} 6 دقائق، ثم {tuna_can} مصفاة.",
   "قلّب المكرونة فيها."])

R("macarona_kofta", "مكرونة بالكفتة والصلصة", "🍝", "l d", "egyptian", 35, "",
  "spaghetti 500 g; minced_beef 400 g; onion 1 pc; parsley 0.5 pc; crushed_tomatoes 2 pc; garlic 2 pc; seven_spice 1 tsp; veg_oil 2 tbsp; salt 1.5 tsp",
  ["اخلط {minced_beef} مع نص {onion} مبشور و{parsley} و{seven_spice} ونص {salt}، واعمل كور صغيرة.",
   "حمّر الكور في {veg_oil} وطلّعها.",
   "حمّر باقي البصل و{garlic}، وأضف {crushed_tomatoes} وباقي الملح ونص كوباية ماء، ورجّع الكور 15 دقيقة.",
   "اسلق {spaghetti} وقدّمها بالصلصة والكفتة."])
V("macarona_kofta", "family")

R("pasta_alfredo_shrimp", "مكرونة ألفريدو بالجمبري", "🦐", "l d", "egyptian italian", 25, "",
  "pasta 500 g; shrimp 400 g; cream 300 ml; butter 2 tbsp; garlic 4 pc; mozzarella 100 g; parsley 0.5 pc; salt 1 tsp; black_pepper 0.5 tsp",
  ["اسلق {pasta}.",
   "شوّح {shrimp} في {butter} مع {garlic} ونص {salt} 3 دقائق.",
   "أضف {cream} و{mozzarella} و{black_pepper} وباقي الملح لحد ما يتقل.",
   "قلّب المكرونة وزيّنها بـ {parsley}."])

R("pasta_eggplant", "مكرونة بالباذنجان والصلصة", "🍆", "l d", "egyptian italian healthy", 30, "",
  "pasta 500 g; eggplant 2 pc; crushed_tomatoes 2 pc; garlic 3 pc; onion 1 pc; olive_oil 4 tbsp; oregano 1 tsp; salt 1.5 tsp; feta 100 g",
  ["قطّع {eggplant} مكعبات وشوّحها في {olive_oil} 8 دقائق لحد ما تطرى وتحمر.",
   "أضف {onion} و{garlic} دقيقتين، ثم {crushed_tomatoes} و{oregano} و{salt} 10 دقائق.",
   "اسلق {pasta} وقلّبها في الصلصة.",
   "فتّت {feta} فوقها."])

R("macarona_bechamel_chicken", "مكرونة بشاميل بالفراخ", "🍗", "l", "egyptian", 70, "oven",
  "pasta 500 g; minced_chicken 500 g; onion 1 pc; tomato_paste 1 tbsp; milk 800 ml; butter 4 tbsp; flour 5 tbsp; eggs 1 pc; mozzarella 100 g; nutmeg 0.25 tsp; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["اسلق {pasta} 6 دقائق.",
   "حمّر {onion} و{minced_chicken}، وأضف {tomato_paste} ونص {salt} و{black_pepper}.",
   "البشاميل: {butter} ثم {flour} ثم {milk} شوية شوية لحد ما يتقل، وأضف {nutmeg} وباقي الملح، وبعد ما يبرد شوية {eggs}.",
   "صينية: نص المكرونة بشوية بشاميل، الفراخ، باقي المكرونة، باقي البشاميل و{mozzarella}.",
   "اخبزها على 200 درجة 30 دقيقة."])
V("macarona_bechamel_chicken", "family comfort")

R("lasagna_eg_veg", "لازانيا خضار مصري", "🥬", "l", "egyptian italian", 70, "oven",
  "lasagna 300 g; spinach 400 g; mushroom 250 g; zucchini 1 pc; onion 1 pc; crushed_tomatoes 2 pc; milk 700 ml; butter 3 tbsp; flour 4 tbsp; mozzarella 200 g; cottage 200 g; salt 1.5 tsp",
  ["شوّح {onion} و{mushroom} و{zucchini} و{spinach} لحد ما ينشفوا، وأضف {crushed_tomatoes} ونص {salt}.",
   "الصوص الأبيض: {butter} و{flour} ثم {milk} حتى يتقل، وباقي الملح و{cottage}.",
   "رصّ: صوص خضار، {lasagna}، صوص أبيض، وكرر 3 مرات.",
   "رشّ {mozzarella} واخبزها مغطاة 30 دقيقة على 190 ثم مكشوفة 10."])

# ======================================================== أكل سريع في طاسة واحدة (≤ 20 دقيقة)
R("chicken_mushroom_cream", "فراخ بالمشروم والكريمة في طاسة", "🍄", "l d", "egyptian western", 20, "",
  "chicken_breast 600 g; mushroom 250 g; cream 200 ml; garlic 3 pc; onion 0.5 pc; butter 1 tbsp; olive_oil 1 tbsp; salt 1 tsp; black_pepper 0.5 tsp; toast 4 pc",
  ["قطّع {chicken_breast} شرائح رفيعة وتبّلها بنص {salt} و{black_pepper}.",
   "حمّرها في {olive_oil} على نار عالية 5 دقائق وطلّعها.",
   "في نفس الطاسة {butter} و{onion} و{garlic} و{mushroom} 4 دقائق.",
   "أضف {cream} وباقي الملح، ورجّع الفراخ دقيقتين، وقدّمها مع {toast}."])
V("chicken_mushroom_cream", "one_pan family")

R("lemon_garlic_chicken", "فراخ بالليمون والثوم في طاسة", "🍋", "l d", "egyptian healthy", 20, "",
  "chicken_breast 700 g; lemon 2 pc; garlic 6 pc; olive_oil 2 tbsp; butter 1 tbsp; oregano 1 tsp; paprika 0.5 tsp; salt 1 tsp; zucchini 2 pc; rice 1.5 cup",
  ["اطبخ {rice} أبيض.",
   "قطّع {chicken_breast} مكعبات وتبّلها بـ {oregano} و{paprika} و{salt}.",
   "حمّرها في {olive_oil} 6 دقائق، وأضف {zucchini} مكعبات 3 دقائق.",
   "أضف {butter} و{garlic} مفروم دقيقة، ثم عصير {lemon}، وقدّمها مع الرز."])
V("lemon_garlic_chicken", "one_pan")

R("minced_potato_pan", "لحمة مفرومة بالبطاطس في طاسة", "🥔", "l d", "egyptian", 20, "",
  "minced_beef 500 g; potato 3 pc; onion 1 pc; tomato 2 pc; garlic 2 pc; seven_spice 1 tsp; paprika 1 tsp; veg_oil 2 tbsp; salt 1.5 tsp; arabic_bread 4 pc",
  ["قطّع {potato} مكعبات صغيرة جداً (عشان تستوي بسرعة) وشوّحها في {veg_oil} 7 دقائق مغطاة.",
   "أضف {onion} و{minced_beef} و{garlic} و{seven_spice} و{paprika} وقلّب 6 دقائق.",
   "أضف {tomato} مبشورة و{salt} وسيبها 4 دقائق.",
   "قدّمها مع {arabic_bread}."])
V("minced_potato_pan", "one_pan family")

R("tuna_pan", "تونة بالبصل والطماطم في طاسة", "🐟", "b d", "egyptian", 12, "",
  "tuna_can 3 pc; onion 1 pc; tomato 2 pc; bell_pepper 1 pc; green_chili 1 pc; cumin 0.5 tsp; olive_oil 1 tbsp; lemon 1 pc; arabic_bread 4 pc",
  ["شوّح {onion} و{bell_pepper} و{green_chili} في {olive_oil} 3 دقائق.",
   "أضف {tomato} مكعبات و{cumin} دقيقتين.",
   "أضف {tuna_can} مصفاة وقلّب دقيقتين.",
   "اعصر {lemon} وقدّمها مع {arabic_bread}."])
V("tuna_pan", "one_pan")

R("shrimp_pan_rice", "جمبري بالطماطم في طاسة", "🦐", "l d", "egyptian", 20, "",
  "shrimp 500 g; tomato 3 pc; onion 1 pc; garlic 4 pc; cumin 1 tsp; coriander 1 pc; olive_oil 2 tbsp; salt 1 tsp; rice 1.5 cup",
  ["اطبخ {rice}.",
   "شوّح {onion} و{garlic} في {olive_oil}، وأضف {tomato} مبشورة و{cumin} و{salt} 6 دقائق.",
   "أضف {shrimp} 4 دقائق بس لحد ما يحمر لونه.",
   "رشّ {coriander} وقدّمه مع الرز."])
V("shrimp_pan_rice", "one_pan")

R("eggs_tomato_cheese_pan", "بيض بالطماطم والجبنة في طاسة", "🍳", "b d", "egyptian", 10, "",
  "eggs 6 pc; tomato 2 pc; feta 100 g; onion 0.5 pc; butter 1 tbsp; black_pepper 0.25 tsp; arabic_bread 4 pc",
  ["شوّح {onion} في {butter} دقيقتين وأضف {tomato} مكعبات دقيقتين.",
   "اكسر {eggs} وقلّب بالراحة.",
   "فتّت {feta} فوقه و{black_pepper}، وقدّمه مع {arabic_bread}."])
V("eggs_tomato_cheese_pan", "one_pan")

R("chicken_veg_pan_eg", "فراخ بالخضار والصلصة في طاسة", "🥘", "l d", "egyptian", 20, "",
  "chicken_breast 600 g; bell_pepper 2 pc; onion 1 pc; zucchini 1 pc; crushed_tomatoes 1 pc; garlic 2 pc; seven_spice 1 tsp; veg_oil 2 tbsp; salt 1 tsp; arabic_bread 4 pc",
  ["قطّع {chicken_breast} شرائح وشوّحها في {veg_oil} مع {seven_spice} 6 دقائق.",
   "أضف {onion} و{bell_pepper} و{zucchini} شرائح و{garlic} 4 دقائق.",
   "أضف {crushed_tomatoes} و{salt} 5 دقائق.",
   "قدّمها مع {arabic_bread}."])
V("chicken_veg_pan_eg", "one_pan family")

R("liver_onion_pan", "كبدة فراخ بالبصل والرمان", "🫀", "b d", "egyptian", 15, "",
  "chicken_liver 500 g; onion 2 pc; garlic 3 pc; pom_molasses 2 tbsp; cumin 0.5 tsp; veg_oil 2 tbsp; salt 0.75 tsp; black_pepper 0.5 tsp; arabic_bread 4 pc",
  ["حمّر {onion} شرائح في {veg_oil} 4 دقائق.",
   "أضف {chicken_liver} و{garlic} على نار عالية 5 دقائق.",
   "أضف {pom_molasses} و{cumin} و{salt} و{black_pepper} دقيقة.",
   "قدّمها مع {arabic_bread}."])
V("liver_onion_pan", "one_pan")

R("pastrami_potato_pan", "بطاطس بالبسطرمة والبيض", "🥔", "b d", "egyptian", 20, "",
  "potato 3 pc; pastrami 100 g; eggs 4 pc; onion 0.5 pc; veg_oil 2 tbsp; black_pepper 0.25 tsp",
  ["قطّع {potato} مكعبات صغيرة واقليها في {veg_oil} مغطاة 10 دقائق.",
   "أضف {onion} و{pastrami} مقطعين دقيقتين.",
   "اكسر {eggs} وقلّب لحد ما يستوي، ورشّ {black_pepper}."])
V("pastrami_potato_pan", "one_pan")

R("kofta_pan_quick", "كفتة طاسة سريعة بالصلصة", "🧆", "l d", "egyptian", 20, "",
  "minced_beef 500 g; onion 1 pc; parsley 0.5 pc; crushed_tomatoes 1 pc; seven_spice 1 tsp; veg_oil 1 tbsp; salt 1 tsp; arabic_bread 4 pc",
  ["اخلط {minced_beef} مع نص {onion} مبشور و{parsley} و{seven_spice} و{salt}، واعمل أقراص صغيرة.",
   "حمّرها في {veg_oil} دقيقتين كل جهة.",
   "أضف باقي البصل و{crushed_tomatoes} وغطّيها 8 دقائق.",
   "قدّمها مع {arabic_bread}."])
V("kofta_pan_quick", "one_pan family")

R("sausage_free_hawawshi_pan", "حواوشي طاسة", "🥙", "d", "egyptian", 20, "",
  "arabic_bread 4 pc; minced_beef 400 g; onion 1 pc; bell_pepper 1 pc; green_chili 1 pc; seven_spice 1 tsp; veg_oil 1 tbsp; salt 1 tsp",
  ["اخلط {minced_beef} مع {onion} و{bell_pepper} و{green_chili} مفرومين و{seven_spice} و{salt}.",
   "افتح {arabic_bread} واحشيه طبقة رقيقة.",
   "ادهن الطاسة بـ {veg_oil} وحمّر الرغيف على نار هادية 5 دقائق كل جهة مع الضغط عليه.",
   "قطّعه وقدّمه سخن."])
V("sausage_free_hawawshi_pan", "one_pan takeout")

R("egg_potato_tortilla", "عجة بطاطس في الطاسة", "🥔", "b d", "egyptian", 20, "",
  "potato 2 pc; eggs 6 pc; onion 0.5 pc; parsley 0.5 pc; veg_oil 2 tbsp; salt 0.75 tsp; black_pepper 0.25 tsp",
  ["ابشر {potato} وأعصره من المية.",
   "اخلطه مع {eggs} و{onion} و{parsley} مفرومين و{salt} و{black_pepper}.",
   "صبّه في {veg_oil} سخن، وغطّيه على نار هادية 7 دقائق، واقلبه بطبق 3 دقائق."])
V("egg_potato_tortilla", "one_pan")

R("halloumi_veg_pan", "حلوم بالخضار في طاسة", "🧀", "d", "egyptian healthy", 15, "",
  "halloumi 250 g; zucchini 1 pc; bell_pepper 1 pc; tomato 2 pc; olive_oil 2 tbsp; oregano 1 tsp; arabic_bread 4 pc",
  ["قطّع {halloumi} و{zucchini} و{bell_pepper} مكعبات.",
   "حمّر الحلوم في {olive_oil} وطلّعه.",
   "شوّح الخضار 5 دقائق مع {tomato} و{oregano}، ورجّع الحلوم.",
   "قدّمه مع {arabic_bread}."])
V("halloumi_veg_pan", "one_pan")

R("beef_strips_pepper", "شرائح لحمة بالفلفل في طاسة", "🥩", "l d", "egyptian", 20, "",
  "beef_cubes 500 g; bell_pepper 2 pc; onion 1 pc; garlic 3 pc; soy_sauce 2 tbsp; black_pepper 1 tsp; veg_oil 2 tbsp; salt 0.5 tsp; rice 1.5 cup",
  ["اطبخ {rice}.",
   "قطّع {beef_cubes} شرايح رفيعة جداً وتبّلها بـ {black_pepper} و{garlic}.",
   "سخّن {veg_oil} على نار عالية جداً وقلّب اللحمة 4 دقائق.",
   "أضف {onion} و{bell_pepper} شرايح دقيقتين، ثم {soy_sauce} و{salt}، وقدّمها مع الرز."])
V("beef_strips_pepper", "one_pan takeout")

R("quick_chicken_shawarma_pan", "شاورما فراخ سريعة في الطاسة", "🌯", "d", "egyptian", 20, "",
  "chicken_breast 600 g; seven_spice 1.5 tsp; paprika 1 tsp; vinegar 1 tbsp; garlic 4 pc; lemon 1 pc; mayo 3 tbsp; veg_oil 2 tbsp; salt 1 tsp; arabic_bread 4 pc; tomato 2 pc",
  ["قطّع {chicken_breast} شرايح رفيعة وتبّلها بـ {seven_spice} و{paprika} و{vinegar} ونص {garlic} و{salt}.",
   "شوّحها في {veg_oil} على نار عالية 7 دقائق.",
   "الثومية: {mayo} مع باقي الثوم وعصير {lemon}.",
   "لفّها في {arabic_bread} مع {tomato} والثومية."])
V("quick_chicken_shawarma_pan", "one_pan takeout family")

R("foul_pan_tomato_egg", "فول بالطماطم والبيض في طاسة", "🫘", "b", "egyptian", 12, "",
  "fava_can 1 pc; eggs 4 pc; tomato 2 pc; onion 0.5 pc; cumin 0.5 tsp; veg_oil 1 tbsp; salt 0.25 tsp; arabic_bread 4 pc",
  ["شوّح {onion} في {veg_oil} وأضف {tomato} مكعبات دقيقتين.",
   "أضف {fava_can} و{cumin} و{salt} واهرسه شوية.",
   "اكسر {eggs} فوقه وغطّيه 4 دقائق، وقدّمه مع {arabic_bread}."])
V("foul_pan_tomato_egg", "one_pan")

R("noodles_egyptian_quick", "إندومي بالفراخ والخضار (سريع)", "🍜", "d", "egyptian asian", 15, "",
  "noodles 300 g; chicken_breast 300 g; carrot 1 pc; bell_pepper 1 pc; soy_sauce 3 tbsp; garlic 2 pc; veg_oil 1 tbsp",
  ["اسلق {noodles} 3 دقائق وصفّيها.",
   "شوّح {chicken_breast} شرايح رفيعة في {veg_oil} 5 دقائق.",
   "أضف {carrot} و{bell_pepper} شرايح و{garlic} دقيقتين.",
   "أضف النودلز و{soy_sauce} وقلّب دقيقة."])
V("noodles_egyptian_quick", "one_pan takeout")

R("cheese_sandwich_oven_eg", "عيش محمص بالجبنة والطماطم", "🫓", "b d", "egyptian", 12, "oven",
  "arabic_bread 4 pc; roumi 100 g; feta 100 g; tomato 2 pc; green_chili 1 pc; oregano 0.5 tsp; olive_oil 1 tbsp",
  ["افتح {arabic_bread} وادهنه بـ {olive_oil}.",
   "رصّ {feta} مفتتة و{roumi} مبشورة و{tomato} و{green_chili} شرايح.",
   "رشّ {oregano} واخبزه على 200 درجة 7 دقائق."])

R("chicken_liver_sandwich", "سندوتشات كبدة فراخ بالفلفل", "🥪", "d", "egyptian", 15, "",
  "chicken_liver 500 g; bell_pepper 1 pc; green_chili 1 pc; garlic 3 pc; cumin 1 tsp; lemon 1 pc; veg_oil 2 tbsp; salt 0.75 tsp; arabic_bread 4 pc; tahini 2 tbsp",
  ["قطّع {chicken_liver} صغير وشوّحها على نار عالية في {veg_oil} 5 دقائق.",
   "أضف {garlic} و{bell_pepper} و{green_chili} و{cumin} دقيقتين.",
   "أضف {salt} وعصير {lemon}.",
   "احشيها في {arabic_bread} مع {tahini}."])
V("chicken_liver_sandwich", "takeout one_pan")

R("potato_tagine_veg", "طاجن بطاطس بالصلصة (بدون لحمة)", "🥔", "l d", "egyptian", 50, "oven",
  "potato 5 pc; onion 2 pc; tomato 3 pc; bell_pepper 1 pc; garlic 3 pc; tomato_paste 2 tbsp; cumin 1 tsp; veg_oil 3 tbsp; stock_cube 1 pc; salt 1.5 tsp; arabic_bread 4 pc",
  ["قطّع {potato} و{onion} و{tomato} و{bell_pepper} شرايح.",
   "رصّهم في صينية مع {garlic}.",
   "اخلط {tomato_paste} مع كوباية ونص ماء و{stock_cube} و{cumin} و{salt} و{veg_oil} وصبّه.",
   "اخبزه على 200 درجة 40 دقيقة، وقدّمه مع {arabic_bread}."])

R("okra_veg", "بامية بالصلصة (صيامي)", "🌱", "l", "egyptian healthy", 35, "",
  "okra 800 g; onion 1 pc; garlic 4 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; coriander 1 pc; veg_oil 2 tbsp; lemon 1 pc; salt 1 tsp; rice 2 cup",
  ["حمّر {onion} في {veg_oil}، وأضف {tomato_paste} و{crushed_tomatoes} وكوباية ماء و{salt}.",
   "أضف {okra} واطبخها 20 دقيقة.",
   "حمّر {garlic} مع {coriander} وضيفها مع عصير {lemon}.",
   "قدّمها مع {rice}."])

R("green_beans_veg", "فاصوليا خضرا بالصلصة (صيامي)", "🫛", "l", "egyptian healthy", 35, "",
  "green_beans 800 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; veg_oil 2 tbsp; stock_cube 1 pc; salt 1 tsp; rice 2 cup",
  ["حمّر {onion} و{garlic} في {veg_oil}.",
   "أضف {green_beans} و{tomato_paste} و{crushed_tomatoes} وكوباية ماء و{stock_cube} و{salt}.",
   "اطبخها 25 دقيقة على نار هادية.",
   "قدّمها مع {rice}."])

R("spinach_eggs", "سبانخ بالبيض", "🥬", "b d", "egyptian healthy", 15, "",
  "spinach 400 g; eggs 4 pc; onion 1 pc; garlic 2 pc; olive_oil 2 tbsp; cumin 0.5 tsp; salt 0.5 tsp; arabic_bread 4 pc",
  ["شوّح {onion} و{garlic} في {olive_oil} 3 دقائق.",
   "أضف {spinach} وسيبها لحد ما مايتها تنشف (5 دقائق).",
   "اكسر {eggs} وقلّب، وأضف {cumin} و{salt}.",
   "قدّمها مع {arabic_bread}."])
V("spinach_eggs", "one_pan")

R("cauliflower_fried", "قرنبيط مقلي بالبيض والكمون", "🥦", "d", "egyptian", 30, "",
  "cauliflower 1 pc; eggs 3 pc; flour 4 tbsp; garlic 2 pc; cumin 1.5 tsp; veg_oil 6 tbsp; salt 1 tsp; tahini 3 tbsp; lemon 1 pc; arabic_bread 4 pc",
  ["قطّع {cauliflower} زهرات واسلقها 5 دقائق وصفّيها كويس.",
   "اخفق {eggs} مع {flour} و{garlic} و{cumin} و{salt}.",
   "اغمس الزهرات في الخليط واقليها في {veg_oil} لحد ما تحمر.",
   "قدّمها مع طحينة ({tahini} + {lemon} + ماء) و{arabic_bread}."])

R("eggplant_fried_eg", "باذنجان مقلي بالتقلية", "🍆", "d", "egyptian", 30, "",
  "eggplant 3 pc; garlic 5 pc; vinegar 3 tbsp; cumin 1 tsp; green_chili 1 pc; veg_oil 6 tbsp; salt 1 tsp; arabic_bread 4 pc",
  ["قطّع {eggplant} حلقات ورشّ عليها {salt}، وسيبها 10 دقائق ونشّفها.",
   "اقليها في {veg_oil} لحد ما تحمر.",
   "اهرس {garlic} مع {green_chili} و{cumin} و{vinegar} (الدقة).",
   "صبّ الدقة على الباذنجان وقدّمه مع {arabic_bread}."])

R("macarona_salad_eg", "سلطة مكرونة بالتونة والذرة", "🥗", "d", "egyptian healthy", 20, "",
  "pasta 300 g; tuna_can 2 pc; corn_can 1 pc; bell_pepper 1 pc; cucumber 1 pc; mayo 3 tbsp; yogurt 3 tbsp; lemon 1 pc; salt 0.75 tsp",
  ["اسلق {pasta} وصفّيها واشطفها بمية ساقعة.",
   "قطّع {bell_pepper} و{cucumber} مكعبات صغيرة.",
   "اخلط {mayo} مع {yogurt} وعصير {lemon} و{salt}.",
   "اخلط الكل مع {tuna_can} و{corn_can}."])

R("rice_veg_chicken_one_pot", "رز بالفراخ والخضار في حلة واحدة", "🍚", "l", "egyptian", 40, "",
  "rice 2.5 cup; chicken_thigh 700 g; peas_carrots 300 g; onion 1 pc; garlic 2 pc; turmeric 0.5 tsp; seven_spice 1.5 tsp; veg_oil 2 tbsp; stock_cube 1 pc; salt 1.5 tsp",
  ["حمّر {chicken_thigh} مقطع مع {onion} في {veg_oil} 7 دقائق.",
   "أضف {garlic} و{turmeric} و{seven_spice} و{peas_carrots}.",
   "أضف {rice} المغسول و4.5 كوباية ماء و{stock_cube} و{salt}.",
   "اطبخها على نار هادية 25 دقيقة."])
V("rice_veg_chicken_one_pot", "one_pan family")

R("bamia_oven_meat", "طاجن بامية باللحمة في الفرن", "🌱", "l", "egyptian", 80, "oven",
  "okra 800 g; beef_cubes 500 g; onion 1 pc; garlic 4 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; coriander 1 pc; veg_oil 2 tbsp; salt 1.5 tsp; rice 2 cup",
  ["اسلق {beef_cubes} مع {onion} 45 دقيقة.",
   "رصّ {okra} واللحمة في طاجن فخار أو بايركس.",
   "اخلط {tomato_paste} و{crushed_tomatoes} مع كوباية مرقة و{salt} و{veg_oil}، وحمّر {garlic} مع {coriander} وضيفهم.",
   "اخبزه على 200 درجة 30 دقيقة، وقدّمه مع {rice}."])
V("bamia_oven_meat", "family comfort")

R("moussaka_bechamel_eg", "مسقعة بالبشاميل", "🍆", "l", "egyptian", 70, "oven",
  "eggplant 3 pc; minced_beef 400 g; onion 1 pc; crushed_tomatoes 1 pc; milk 500 ml; butter 2 tbsp; flour 3 tbsp; mozzarella 80 g; veg_oil 3 tbsp; salt 1.5 tsp; seven_spice 1 tsp",
  ["قطّع {eggplant} شرايح، ادهنها بـ {veg_oil} واشويها 20 دقيقة.",
   "حمّر {onion} و{minced_beef} مع {seven_spice} ونص {salt}، وأضف {crushed_tomatoes}.",
   "بشاميل: {butter} و{flour} ثم {milk} حتى يتقل وباقي الملح.",
   "رصّ باذنجان، لحمة، باذنجان، بشاميل و{mozzarella}، واخبزها 25 دقيقة على 200."])
V("moussaka_bechamel_eg", "family comfort")

R("fasolia_beef_eg", "فاصوليا بيضا باللحمة مصري", "🫘", "l", "egyptian", 60, "",
  "white_beans 2 pc; beef_cubes 500 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; cumin 1 tsp; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup; vermicelli 50 g",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil} واسلقها في ماء 40 دقيقة.",
   "أضف {white_beans} و{garlic} و{tomato_paste} و{crushed_tomatoes} و{cumin} و{salt} 15 دقيقة.",
   "حمّر {vermicelli} وأضف {rice} و3.5 كوباية ماء 20 دقيقة.",
   "قدّمها مع الرز بالشعرية."])
V("fasolia_beef_eg", "family comfort")

R("molokhia_beef", "ملوخية باللحمة", "🥬", "l", "egyptian", 70, "",
  "molokhia 800 g; beef_cubes 500 g; garlic 8 pc; coriander 1 pc; butter 2 tbsp; cardamom 3 pc; bay_leaf 2 pc; stock_cube 1 pc; salt 1.5 tsp; rice 2 cup",
  ["اسلق {beef_cubes} مع {cardamom} و{bay_leaf} و{stock_cube} في 6 كوبايات ماء 50 دقيقة.",
   "صفّي 4 كوبايات من المرقة وغلّيها، وأضف {molokhia} و{salt} وقلّب، وأول ما تغلي وطّي النار.",
   "التقلية: {garlic} مع {coriander} في {butter} لحد ما يصفر.",
   "قدّم الملوخية واللحمة مع {rice}."])
V("molokhia_beef", "family comfort")

R("chicken_fatta_rice_eg", "فراخ بالرز والصلصة (فراخ مسلوقة محمرة)", "🍗", "l", "egyptian", 60, "",
  "chicken_whole 1 pc; rice 2.5 cup; onion 1 pc; crushed_tomatoes 1 pc; garlic 3 pc; vinegar 1 tbsp; butter 2 tbsp; cardamom 3 pc; salt 1.5 tsp",
  ["اسلق {chicken_whole} مع {onion} و{cardamom} في 6 كوبايات ماء 35 دقيقة.",
   "اطبخ {rice} في 4 كوبايات مرقة مع نص {salt}.",
   "حمّر الفراخ في {butter}.",
   "صلصة سريعة: {garlic} في شوية زبدة ثم {vinegar} ثم {crushed_tomatoes} وباقي الملح 8 دقائق، وقدّمها مع الرز والفراخ."])

R("stuffed_eggplant_white", "باذنجان أبيض محشي رز", "🍆", "l", "egyptian", 80, "",
  "eggplant 6 pc; rice 1.5 cup; tomato 2 pc; onion 1 pc; parsley 1 pc; dill 1 pc; garlic 3 pc; vinegar 2 tbsp; tomato_paste 2 tbsp; veg_oil 3 tbsp; salt 2 tsp",
  ["فرّغ {eggplant} الصغيرة من جوه.",
   "اخلط {rice} مع {tomato} و{onion} و{parsley} و{dill} مفرومين ونص {salt} ونص {veg_oil}.",
   "احشي الباذنجان ورصّه في حلة.",
   "اخلط {tomato_paste} مع 3 كوبايات ماء و{garlic} مهروس و{vinegar} وباقي الملح والزيت، وصبّه واطبخه 45 دقيقة."])
V("stuffed_eggplant_white", "comfort family")

R("hawawshi_chicken", "حواوشي فراخ بالفرن", "🥙", "d", "egyptian", 30, "oven",
  "arabic_bread 4 pc; minced_chicken 500 g; onion 1 pc; bell_pepper 1 pc; garlic 2 pc; paprika 1 tsp; seven_spice 1 tsp; mozzarella 100 g; veg_oil 1 tbsp; salt 1 tsp",
  ["اخلط {minced_chicken} مع {onion} و{bell_pepper} و{garlic} مفرومين و{paprika} و{seven_spice} و{salt}.",
   "احشي {arabic_bread} وأضف {mozzarella}.",
   "ادهنه بـ {veg_oil} واخبزه على 200 درجة 15 دقيقة مع القلب."])
V("hawawshi_chicken", "takeout family")

R("mombar_free_rice_liver", "رز بالكبدة والقوانص (سريع)", "🍚", "l d", "egyptian", 30, "",
  "rice 2 cup; chicken_liver 300 g; onion 1 pc; seven_spice 1 tsp; butter 2 tbsp; stock_cube 1 pc; salt 1 tsp; parsley 0.5 pc",
  ["حمّر {onion} و{chicken_liver} مقطعة صغير في {butter} 5 دقائق.",
   "أضف {rice} و{seven_spice} وقلّب.",
   "أضف 3.5 كوباية ماء و{stock_cube} و{salt}، واطبخه 20 دقيقة.",
   "زيّنه بـ {parsley}."])
V("mombar_free_rice_liver", "one_pan")

R("bread_pudding_om_ali", "أم علي", "🥧", "b", "egyptian", 35, "oven",
  "toast 10 pc; milk 800 ml; sugar 5 tbsp; cream 200 ml; raisins 40 g; almonds 40 g; butter 1 tbsp",
  ["حمّص {toast} في الفرن وقطّعه قطع صغيرة.",
   "رصّه في صينية مدهونة بـ {butter} مع {raisins} و{almonds}.",
   "سخّن {milk} مع {sugar} وصبّه على العيش.",
   "اسكب {cream} على الوش واخبزها على 200 درجة 15 دقيقة لحد ما الوش يحمر."])
V("bread_pudding_om_ali", "comfort family")

R("meshaltet_quick", "فطير سريع بالجبنة في الطاسة", "🥞", "b", "egyptian", 25, "",
  "flour 300 g; milk 200 ml; eggs 1 pc; butter 3 tbsp; feta 150 g; honey 3 tbsp; salt 0.5 tsp; baking_powder 1 tsp",
  ["اعجن {flour} مع {milk} و{eggs} و{salt} و{baking_powder} ومعلقة {butter} لحد ما تبقى عجينة طرية، وسيبها 10 دقائق.",
   "قسّمها 4 وافرد كل واحدة رقيقة، وحط {feta} في النص واطويها.",
   "حمّرها في باقي الزبدة في طاسة على نار هادية 4 دقائق كل جهة.",
   "قدّمها مع {honey}."])
V("meshaltet_quick", "family comfort")

R("salata_baladi_chicken", "صدور فراخ مشوية مع سلطة بلدي", "🥗", "l d", "egyptian healthy", 25, "",
  "chicken_breast 700 g; tomato 3 pc; cucumber 3 pc; onion 1 pc; green_chili 1 pc; parsley 1 pc; lemon 2 pc; cumin 1 tsp; olive_oil 3 tbsp; salt 1.5 tsp; arabic_bread 2 pc",
  ["تبّل {chicken_breast} بـ {cumin} ونص {salt} وعصير نص {lemon} وملعقة {olive_oil}.",
   "اشويها في طاسة جريل 6 دقائق كل جهة.",
   "قطّع {tomato} و{cucumber} و{onion} و{green_chili} صغير جداً، وأضف {parsley} والليمونة التانية وباقي الزيت والملح.",
   "قدّمها مع {arabic_bread}."])
