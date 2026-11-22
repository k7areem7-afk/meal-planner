# -*- coding: utf-8 -*-
"""Original recipe library for سفرة (written for this app).

R(id, title, emoji, meals, styles, minutes, appliances, ingredients, steps)
- meals: any of b (فطور) l (غداء) d (عشاء)
- appliances: stove is assumed; others: oven air_fryer microwave blender pressure_cooker
- ingredients: "id qty unit; ..." for 4 servings. unit: g ml pc tsp tbsp cup
- steps: {id} is replaced in the app by the scaled amount and name.
"""

STYLES = [
    ("saudi", "سعودي وخليجي"),
    ("levant", "شامي"),
    ("egyptian", "مصري"),
    ("italian", "إيطالي"),
    ("asian", "آسيوي"),
    ("indian", "هندي"),
    ("mexican", "مكسيكي"),
    ("healthy", "صحي وخفيف"),
]

REC = []


def R(id, title, emoji, meals, styles, mins, appl, ings, steps, servings=4):
    REC.append(dict(id=id, title=title, emoji=emoji, meals=meals.split(),
                    styles=styles.split(), mins=mins, appl=appl.split(),
                    ings=ings, steps=steps, servings=servings))


# ======================================================== breakfast
R("foul", "فول مدمس بالليمون والكمون", "🫘", "b d", "egyptian saudi", 15, "",
  "fava_can 2 pc; garlic 2 pc; lemon 1 pc; cumin 1 tsp; olive_oil 3 tbsp; tomato 1 pc; salt 0.5 tsp; arabic_bread 4 pc",
  ["سخّن {fava_can} مع قليل من الماء على نار هادئة 5 دقائق.",
   "اهرس الفول جزئياً، وأضف {garlic} مهروساً و{cumin} و{salt}.",
   "اعصر {lemon} وقطّع {tomato} مكعبات صغيرة فوقه.",
   "زيّنه بـ {olive_oil} وقدّمه مع {arabic_bread}."])

R("shakshuka", "شكشوكة", "🍳", "b d", "levant", 20, "",
  "eggs 6 pc; tomato 4 pc; onion 1 pc; bell_pepper 1 pc; garlic 2 pc; cumin 1 tsp; paprika 1 tsp; olive_oil 2 tbsp; salt 0.5 tsp; arabic_bread 4 pc",
  ["قطّع {onion} و{bell_pepper} صغيراً، وحمّسهما في {olive_oil} 5 دقائق.",
   "أضف {garlic} و{cumin} و{paprika} وقلّب دقيقة.",
   "أضف {tomato} مقطعة و{salt}، واتركها تتسبك 8 دقائق.",
   "اعمل حفراً واكسر فيها {eggs}، وغطّ المقلاة 5 دقائق حتى يستوي البيض.",
   "قدّمها ساخنة مع {arabic_bread}."])

R("eggs_cheese", "بيض مقلي مع جبن وخضار", "🥚", "b", "saudi", 10, "",
  "eggs 8 pc; feta 150 g; cucumber 2 pc; tomato 2 pc; butter 1 tbsp; arabic_bread 4 pc; salt 0.25 tsp",
  ["ذوّب {butter} في مقلاة واقلِ {eggs} مع رشة {salt}.",
   "قطّع {cucumber} و{tomato} شرائح.",
   "قدّم البيض مع {feta} والخضار و{arabic_bread}."])

R("ejjeh", "عجة بالبقدونس والبصل", "🌿", "b d", "levant", 20, "",
  "eggs 6 pc; parsley 1 pc; onion 1 pc; flour 2 tbsp; seven_spice 0.5 tsp; salt 0.5 tsp; veg_oil 3 tbsp; arabic_bread 4 pc",
  ["افرم {parsley} و{onion} ناعماً.",
   "اخفق {eggs} مع {flour} و{seven_spice} و{salt}، ثم أضف الخضار.",
   "سخّن {veg_oil} واسكب مغرفة صغيرة لكل قرص، واقلِه دقيقتين لكل جهة.",
   "قدّمها مع {arabic_bread}."])

R("labneh_plate", "لبنة بزيت الزيتون مع زعتر وخضار", "🫒", "b d", "levant", 5, "",
  "labneh 300 g; olive_oil 3 tbsp; zaatar 2 tbsp; cucumber 2 pc; tomato 2 pc; mint 1 pc; arabic_bread 4 pc",
  ["افرد {labneh} في صحن واعمل فيها خطوطاً بالملعقة.",
   "اسكب {olive_oil} ورشّ نصف {zaatar}.",
   "قطّع {cucumber} و{tomato} وقدّمها مع {mint}.",
   "قدّم الباقي من الزعتر مع زيت للتغميس و{arabic_bread}."])

R("oats_banana", "شوفان بالموز والعسل", "🥣", "b", "healthy", 10, "",
  "oats 160 g; milk 800 ml; banana 2 pc; honey 3 tbsp; cinnamon 0.5 tsp",
  ["اطبخ {oats} مع {milk} على نار متوسطة 5 دقائق مع التحريك.",
   "أضف {cinnamon} ونصف {honey}.",
   "قطّع {banana} شرائح ووزعها فوق الأطباق مع باقي العسل."])

R("balaleet", "بلاليط بالبيض", "🍝", "b", "saudi", 25, "",
  "vermicelli 250 g; sugar 4 tbsp; cardamom 6 pc; butter 2 tbsp; eggs 4 pc; salt 0.25 tsp",
  ["اسلق {vermicelli} في ماء مغلي مع {salt} 4 دقائق وصفّها.",
   "في قدر، ذوّب نصف {butter} وأضف الشعيرية و{sugar} و{cardamom} مطحوناً، وقلّب 3 دقائق.",
   "اخفق {eggs} واطهها كعجة رقيقة بباقي الزبدة.",
   "قدّم الشعيرية وفوقها البيض."])

R("halloumi_grill", "حلوم مشوي مع طماطم وخيار", "🧀", "b d", "levant", 10, "",
  "halloumi 250 g; tomato 2 pc; cucumber 2 pc; olive_oil 1 tbsp; mint 1 pc; arabic_bread 4 pc",
  ["قطّع {halloumi} شرائح سميكة.",
   "اشوِها في مقلاة مع {olive_oil} دقيقتين لكل جهة حتى تتحمّر.",
   "قدّمها مع {tomato} و{cucumber} و{mint} و{arabic_bread}."])

R("fatteh_hummus", "فتة حمص باللبن", "🥙", "b d", "levant", 20, "",
  "chickpeas_can 2 pc; yogurt 500 g; tahini 3 tbsp; garlic 2 pc; lemon 1 pc; arabic_bread 2 pc; butter 2 tbsp; almonds 30 g; cumin 0.5 tsp; salt 0.5 tsp",
  ["قطّع {arabic_bread} مربعات وحمّصها في الفرن أو المقلاة حتى تقرمش.",
   "سخّن {chickpeas_can} بمائه 5 دقائق.",
   "اخلط {yogurt} مع {tahini} و{garlic} مهروساً وعصير {lemon} و{salt}.",
   "رتّب الخبز ثم الحمص (مع قليل من مائه) ثم صلصة اللبن.",
   "حمّر {almonds} في {butter} واسكبها فوق الفتة مع رشة {cumin}."])

R("eggs_tomato", "بيض بالطماطم والفلفل الحار", "🍅", "b d", "saudi egyptian", 15, "",
  "eggs 6 pc; tomato 3 pc; onion 1 pc; green_chili 1 pc; veg_oil 2 tbsp; salt 0.5 tsp; black_pepper 0.25 tsp; arabic_bread 4 pc",
  ["حمّر {onion} مفروماً في {veg_oil}.",
   "أضف {tomato} مقطعة و{green_chili} واتركها 5 دقائق.",
   "اخفق {eggs} مع {salt} و{black_pepper} واسكبها فوق الطماطم مع التقليب حتى تستوي.",
   "قدّمها مع {arabic_bread}."])

R("cheese_sandwich", "ساندويتش جبن وخضار", "🥪", "b d", "healthy", 10, "",
  "toast 8 pc; cheddar 8 pc; cucumber 1 pc; tomato 2 pc; lettuce 0.5 pc; mayo 2 tbsp",
  ["ادهن {toast} بطبقة رقيقة من {mayo}.",
   "رتّب {cheddar} و{lettuce} وشرائح {tomato} و{cucumber}.",
   "أغلق الساندويتش وقطّعه نصفين. يمكن تحميصه في المقلاة دقيقتين."])

R("pancakes", "بان كيك سريع بالعسل", "🥞", "b", "", 25, "",
  "flour 250 g; milk 300 ml; eggs 2 pc; sugar 2 tbsp; baking_powder 2 tsp; butter 2 tbsp; honey 4 tbsp; salt 0.25 tsp",
  ["اخلط {flour} و{sugar} و{baking_powder} و{salt}.",
   "اخفق {eggs} مع {milk} ونصف {butter} مذاباً، ثم أضفها للخليط الجاف وقلّب بخفة.",
   "سخّن مقلاة غير لاصقة بقليل من الزبدة، واسكب ربع كوب لكل قرص.",
   "اقلبه عند ظهور الفقاعات، ثم قدّمه مع {honey}."])

R("avocado_toast", "توست أفوكادو مع بيض", "🥑", "b", "healthy", 15, "",
  "toast 8 pc; avocado 2 pc; eggs 4 pc; lemon 1 pc; chili_flakes 0.5 tsp; salt 0.5 tsp; olive_oil 1 tbsp",
  ["حمّص {toast}.",
   "اهرس {avocado} مع عصير {lemon} و{salt}.",
   "اقلِ {eggs} في {olive_oil}.",
   "افرد الأفوكادو على التوست وضع البيض فوقه مع {chili_flakes}."])

R("yogurt_dates", "زبادي بالتمر والشوفان", "🍯", "b", "healthy saudi", 5, "",
  "yogurt 600 g; dates 12 pc; oats 80 g; honey 2 tbsp; almonds 30 g",
  ["وزّع {yogurt} على 4 أكواب.",
   "انزع نوى {dates} وقطّعه.",
   "أضف {oats} والتمر و{almonds} مقطعاً، واسكب {honey} فوقه."])

R("zaatar_manakish", "منقوشة زعتر سريعة", "🫓", "b d", "levant", 15, "oven",
  "arabic_bread 4 pc; zaatar 4 tbsp; olive_oil 6 tbsp; tomato 2 pc; cucumber 1 pc; mint 1 pc",
  ["سخّن الفرن على 200 درجة.",
   "اخلط {zaatar} مع {olive_oil} وافرده على {arabic_bread}.",
   "اخبزه 6 دقائق حتى تقرمش الأطراف.",
   "قدّمه مع {tomato} و{cucumber} و{mint}."])

# ======================================================== saudi / gulf
R("kabsa_chicken", "كبسة دجاج", "🍗", "l", "saudi", 75, "",
  "chicken_whole 1 pc; rice 3 cup; onion 2 pc; tomato 2 pc; tomato_paste 2 tbsp; garlic 4 pc; kabsa_spice 1 tbsp; black_lime 2 pc; cardamom 5 pc; cinnamon 1 pc; bay_leaf 2 pc; veg_oil 4 tbsp; stock_cube 1 pc; salt 1 tsp; raisins 40 g; almonds 40 g",
  ["قطّع {chicken_whole} إلى 4 أو 8 قطع واغسله.",
   "حمّر {onion} مفروماً في {veg_oil}، ثم أضف {garlic} والدجاج وقلّبه 5 دقائق.",
   "أضف {tomato} مبشورة و{tomato_paste} و{kabsa_spice} و{black_lime} و{cardamom} و{cinnamon} و{bay_leaf}.",
   "أضف 5 أكواب ماء ساخن مع {stock_cube} و{salt}، واتركه 35 دقيقة.",
   "أخرج الدجاج وحمّره في الفرن أو المقلاة. أضف {rice} المنقوع للمرق (يجب أن يغطيه بإصبع) واطبخه على نار هادئة 25 دقيقة.",
   "قدّم الأرز وفوقه الدجاج و{raisins} و{almonds} المحمّرة."])

R("kabsa_lamb", "كبسة لحم", "🍖", "l", "saudi", 120, "",
  "lamb 1200 g; rice 3 cup; onion 2 pc; tomato 2 pc; tomato_paste 2 tbsp; garlic 4 pc; kabsa_spice 1 tbsp; black_lime 2 pc; cardamom 6 pc; cinnamon 1 pc; veg_oil 4 tbsp; salt 1.5 tsp",
  ["حمّر {onion} في {veg_oil}، ثم أضف {lamb} واتركه يتحمّر من كل الجهات.",
   "أضف {garlic} و{tomato} و{tomato_paste} و{kabsa_spice} و{black_lime} و{cardamom} و{cinnamon} و{salt}.",
   "غطّه بالماء واتركه يطبخ ساعة ونصف حتى ينضج.",
   "أخرج اللحم، وقِس المرق: 5 أكواب. أضف {rice} المنقوع واطبخه على نار هادئة 25 دقيقة.",
   "قدّم الأرز وفوقه اللحم."])

R("mandi_chicken", "مندي دجاج بالفرن", "🔥", "l", "saudi", 90, "oven",
  "chicken_whole 1 pc; rice 3 cup; onion 1 pc; kabsa_spice 1 tbsp; turmeric 1 tsp; cardamom 6 pc; black_lime 2 pc; butter 3 tbsp; veg_oil 2 tbsp; stock_cube 1 pc; salt 1.5 tsp",
  ["تبّل {chicken_whole} بـ {kabsa_spice} و{turmeric} و{salt} و{butter} واتركه 30 دقيقة على الأقل.",
   "حمّر {onion} في {veg_oil}، وأضف {rice} المنقوع و{cardamom} و{black_lime} و5 أكواب ماء مع {stock_cube}.",
   "انقل الأرز إلى صينية فرن عميقة، وضع شبكاً فوقها وعليه الدجاج.",
   "غطّ الصينية بورق القصدير بإحكام واخبزها على 200 درجة ساعة.",
   "اكشف الغطاء واشوِ الدجاج 10 دقائق إضافية حتى يتحمّر."])

R("maqluba", "مقلوبة باذنجان بالدجاج", "🍆", "l", "levant", 90, "",
  "chicken_thigh 700 g; eggplant 2 pc; rice 2.5 cup; onion 1 pc; tomato 2 pc; seven_spice 2 tsp; turmeric 0.5 tsp; veg_oil 6 tbsp; stock_cube 1 pc; salt 1.5 tsp; almonds 30 g",
  ["قطّع {eggplant} شرائح، رشّها بالملح، ثم اقلها في {veg_oil} أو اشوها في الفرن.",
   "اسلق {chicken_thigh} مع {onion} و{stock_cube} في 4 أكواب ماء 20 دقيقة، واحتفظ بالمرق.",
   "تبّل {rice} المنقوع بـ {seven_spice} و{turmeric} و{salt}.",
   "في قدر: شرائح {tomato} ثم الدجاج ثم الباذنجان ثم الأرز. اسكب المرق حتى يغطي الأرز.",
   "اطبخه على نار هادئة 35 دقيقة، ثم اتركه 10 دقائق واقلبه في صينية. زيّنه بـ {almonds}."])

R("jareesh", "جريش باللبن والدجاج", "🥣", "l d", "saudi", 90, "",
  "jareesh 400 g; chicken_breast 400 g; yogurt 400 g; onion 2 pc; butter 2 tbsp; cumin 1 tsp; black_pepper 0.5 tsp; stock_cube 1 pc; salt 1 tsp; black_lime 1 pc",
  ["انقع {jareesh} ساعة على الأقل ثم اغسله.",
   "اسلق {chicken_breast} مع {stock_cube} في 6 أكواب ماء 15 دقيقة، ثم قطّعه قطعاً صغيرة.",
   "أضف الجريش للمرق مع {black_lime} واطبخه على نار هادئة 60 دقيقة مع التحريك وإضافة ماء عند الحاجة.",
   "أضف الدجاج و{yogurt} و{cumin} و{black_pepper} و{salt} وقلّب جيداً.",
   "حمّر {onion} شرائح في {butter} حتى يتكرمل، وزيّن به الجريش."])

R("saleeg", "سليق دجاج", "🍚", "l d", "saudi", 60, "",
  "chicken_whole 1 pc; rice 2 cup; milk 500 ml; butter 3 tbsp; cardamom 4 pc; cinnamon 1 pc; bay_leaf 2 pc; stock_cube 1 pc; salt 1 tsp; black_pepper 0.5 tsp",
  ["اسلق {chicken_whole} مقطعاً مع {cardamom} و{cinnamon} و{bay_leaf} و{stock_cube} في 6 أكواب ماء 35 دقيقة.",
   "أخرج الدجاج، وادهنه بنصف {butter} و{black_pepper} وحمّره في الفرن أو المقلاة.",
   "اطبخ {rice} في 4 أكواب من المرق مع التحريك المستمر حتى يصير طرياً جداً.",
   "أضف {milk} و{salt} وباقي الزبدة، وقلّب حتى يصبح القوام كريمياً.",
   "قدّم السليق وفوقه الدجاج."])

R("saudi_macaroni", "معكرونة بالصلصة الحمراء واللحم المفروم", "🍝", "l d", "saudi", 35, "",
  "pasta 500 g; minced_beef 400 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; seven_spice 1 tsp; paprika 1 tsp; veg_oil 2 tbsp; salt 1 tsp; bell_pepper 1 pc",
  ["اسلق {pasta} حسب التعليمات وصفّها.",
   "حمّر {onion} و{bell_pepper} في {veg_oil}، ثم أضف {minced_beef} وقلّبه حتى يتغير لونه.",
   "أضف {garlic} و{tomato_paste} و{crushed_tomatoes} و{seven_spice} و{paprika} و{salt} ونصف كوب ماء.",
   "اترك الصلصة 15 دقيقة، ثم اخلطها مع المعكرونة."])

R("madhghout", "مضغوط دجاج بقدر الضغط", "♨️", "l", "saudi", 45, "pressure_cooker",
  "chicken_whole 1 pc; rice 3 cup; onion 2 pc; tomato 3 pc; tomato_paste 2 tbsp; garlic 4 pc; kabsa_spice 1 tbsp; black_lime 2 pc; carrot 1 pc; veg_oil 3 tbsp; salt 1.5 tsp",
  ["في قدر الضغط، حمّر {onion} في {veg_oil} ثم أضف {chicken_whole} مقطعاً وقلّبه.",
   "أضف {garlic} و{tomato} و{tomato_paste} و{kabsa_spice} و{black_lime} و{carrot} مبشوراً و{salt}.",
   "أضف {rice} المنقوع و5 أكواب ماء.",
   "أغلق القدر واطبخه 12 دقيقة من الصفير، ثم اترك الضغط ينزل وحده."])

R("saloona_chicken", "صالونة دجاج بالخضار", "🥘", "l d", "saudi", 50, "",
  "chicken_thigh 700 g; potato 2 pc; carrot 2 pc; zucchini 2 pc; onion 1 pc; tomato 3 pc; tomato_paste 2 tbsp; garlic 3 pc; kabsa_spice 2 tsp; turmeric 0.5 tsp; veg_oil 3 tbsp; salt 1 tsp; rice 2 cup",
  ["حمّر {onion} في {veg_oil}، ثم أضف {chicken_thigh} مقطعاً وقلّبه 5 دقائق.",
   "أضف {garlic} و{tomato} و{tomato_paste} و{kabsa_spice} و{turmeric} و{salt}.",
   "أضف {potato} و{carrot} مكعبات و3 أكواب ماء، واتركه 20 دقيقة.",
   "أضف {zucchini} واطبخه 10 دقائق إضافية.",
   "اطبخ {rice} أبيض وقدّمه مع الصالونة."])

R("bamia_meat", "بامية باللحم", "🌱", "l", "saudi egyptian levant", 70, "",
  "beef_cubes 500 g; okra 800 g; onion 1 pc; garlic 4 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; coriander 1 pc; seven_spice 1 tsp; veg_oil 3 tbsp; lemon 1 pc; salt 1 tsp; rice 2 cup",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، ثم غطّه بالماء واتركه 40 دقيقة.",
   "اقلِ {garlic} مع {coriander} مفرومة دقيقة.",
   "أضف {okra} و{tomato_paste} و{crushed_tomatoes} و{seven_spice} و{salt} وخليط الثوم إلى اللحم.",
   "اطبخه 20 دقيقة على نار هادئة، ثم أضف عصير {lemon}.",
   "قدّمه مع {rice} أبيض."])

R("lentil_soup", "شوربة عدس", "🥣", "l d", "saudi levant egyptian healthy", 35, "",
  "red_lentils 300 g; onion 1 pc; carrot 2 pc; potato 1 pc; garlic 2 pc; cumin 1.5 tsp; turmeric 0.5 tsp; olive_oil 2 tbsp; stock_cube 1 pc; lemon 1 pc; salt 1 tsp; arabic_bread 2 pc",
  ["حمّر {onion} و{garlic} في {olive_oil}.",
   "أضف {red_lentils} المغسول و{carrot} و{potato} مقطعة و{cumin} و{turmeric}.",
   "أضف 7 أكواب ماء مع {stock_cube} و{salt} واتركها 25 دقيقة.",
   "اخلطها بالخلاط اليدوي أو اهرسها، وقدّمها مع {lemon} و{arabic_bread} محمّص."])

R("oat_soup", "شوربة شوفان بالدجاج", "🍲", "d", "saudi", 30, "",
  "oats 120 g; chicken_breast 300 g; onion 1 pc; tomato 2 pc; tomato_paste 1 tbsp; garlic 2 pc; cumin 1 tsp; black_pepper 0.5 tsp; veg_oil 2 tbsp; stock_cube 1 pc; coriander 1 pc; salt 1 tsp",
  ["قطّع {chicken_breast} قطعاً صغيرة وحمّرها مع {onion} في {veg_oil}.",
   "أضف {garlic} و{tomato} مبشورة و{tomato_paste} و{cumin} و{black_pepper}.",
   "أضف 7 أكواب ماء مع {stock_cube} و{salt}، ثم {oats}.",
   "اطبخها 15 دقيقة مع التحريك، وزيّنها بـ {coriander}."])

R("sayadiyah", "صيادية سمك", "🐟", "l", "saudi levant", 60, "",
  "fish_fillet 700 g; rice 2.5 cup; onion 3 pc; cumin 2 tsp; turmeric 0.5 tsp; cinnamon 1 pc; veg_oil 6 tbsp; lemon 1 pc; flour 3 tbsp; salt 1.5 tsp; almonds 30 g",
  ["تبّل {fish_fillet} بنصف {cumin} و{salt} وعصير {lemon}، ثم غلّفه بـ {flour}.",
   "اقلِ السمك في نصف {veg_oil} وارفعه.",
   "في الزيت الباقي، حمّر {onion} شرائح حتى يصبح بنياً غامقاً.",
   "أضف 5 أكواب ماء وباقي الكمون و{turmeric} و{cinnamon}، ثم {rice} المنقوع.",
   "اطبخه على نار هادئة 25 دقيقة، وقدّمه مع السمك و{almonds}."])

R("shrimp_rice", "روبيان بالثوم مع أرز", "🍤", "l d", "saudi healthy", 30, "",
  "shrimp 600 g; garlic 6 pc; lemon 1 pc; butter 2 tbsp; paprika 1 tsp; coriander 1 pc; rice 2 cup; salt 1 tsp; chili_flakes 0.5 tsp",
  ["اطبخ {rice} أبيض.",
   "ذوّب {butter} وحمّر {garlic} مفروماً دقيقة.",
   "أضف {shrimp} و{paprika} و{chili_flakes} و{salt}، وقلّبه 4 دقائق فقط حتى يتلون.",
   "أضف عصير {lemon} و{coriander} مفرومة، وقدّمه مع الأرز."])

R("chicken_liver", "كبدة دجاج بالبصل والفلفل", "🫑", "b d", "saudi", 20, "",
  "chicken_liver 500 g; onion 2 pc; bell_pepper 1 pc; garlic 3 pc; green_chili 1 pc; cumin 1 tsp; lemon 1 pc; veg_oil 2 tbsp; salt 0.75 tsp; arabic_bread 4 pc",
  ["نظّف {chicken_liver} وقطّعه.",
   "حمّر {onion} شرائح في {veg_oil}، ثم أضف الكبدة على نار عالية 5 دقائق.",
   "أضف {garlic} و{bell_pepper} و{green_chili} و{cumin} و{salt} وقلّب 3 دقائق.",
   "أضف عصير {lemon}، وقدّمها مع {arabic_bread}."])

R("marqooq", "مرقوق باللحم والخضار", "🥟", "l", "saudi", 100, "",
  "beef_cubes 500 g; flour 300 g; zucchini 2 pc; carrot 2 pc; potato 2 pc; onion 1 pc; tomato 3 pc; tomato_paste 2 tbsp; kabsa_spice 2 tsp; black_lime 1 pc; veg_oil 2 tbsp; salt 1.5 tsp",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، وأضف {tomato} و{tomato_paste} و{kabsa_spice} و{black_lime}، ثم 6 أكواب ماء. اتركه 50 دقيقة.",
   "اعجن {flour} مع نصف {salt} وماء حتى تصير عجينة طرية، واتركها 15 دقيقة.",
   "أضف {potato} و{carrot} للمرق واتركها 10 دقائق.",
   "افرد العجين رقيقاً جداً وقطّعه مربعات، وأضفه للمرق تدريجياً مع {zucchini}.",
   "اطبخه 15 دقيقة على نار هادئة حتى تنضج العجينة."])

# ======================================================== levant
R("shawarma", "شاورما دجاج بالبيت", "🌯", "d l", "levant saudi", 40, "",
  "chicken_thigh 800 g; yogurt 100 g; garlic 6 pc; lemon 2 pc; seven_spice 1 tbsp; paprika 1 tsp; turmeric 0.5 tsp; veg_oil 3 tbsp; mayo 4 tbsp; arabic_bread 6 pc; tomato 2 pc; potato 3 pc; salt 1 tsp",
  ["تبّل {chicken_thigh} بـ {yogurt} وعصير نصف {lemon} و{seven_spice} و{paprika} و{turmeric} و{salt} ونصف {garlic}. اتركه 30 دقيقة.",
   "اطهه في مقلاة واسعة مع {veg_oil} على نار عالية حتى يتحمّر، ثم قطّعه شرائح.",
   "اعمل الثومية: اخلط {mayo} مع باقي الثوم مهروساً وعصير الليمونة الثانية.",
   "اقطع {potato} أصابع واقلها أو اشوها.",
   "لفّ الدجاج في {arabic_bread} مع الثومية و{tomato} والبطاطس."])

R("kofta_tahini", "كفتة بالطحينة في الفرن", "🥔", "l d", "levant", 60, "oven",
  "minced_beef 600 g; onion 1 pc; parsley 1 pc; potato 4 pc; tahini 120 g; lemon 2 pc; garlic 2 pc; seven_spice 2 tsp; veg_oil 2 tbsp; salt 1.5 tsp; rice 2 cup",
  ["اخلط {minced_beef} مع {onion} مبشوراً و{parsley} مفرومة و{seven_spice} ونصف {salt}، وشكّلها أقراصاً.",
   "قطّع {potato} شرائح، وادهنها بـ {veg_oil}، واشوِها مع الكفتة في الفرن على 200 درجة 20 دقيقة.",
   "اخفق {tahini} مع عصير {lemon} و{garlic} وباقي الملح وكوب ماء حتى تصير صلصة سائلة.",
   "اسكب الصلصة فوق الكفتة والبطاطس، وأرجعها للفرن 15 دقيقة.",
   "قدّمها مع {rice} أبيض."])

R("mujaddara", "مجدرة بالبصل المقرمش", "🧅", "l d", "levant healthy", 50, "",
  "brown_lentils 250 g; rice 1.5 cup; onion 3 pc; cumin 1.5 tsp; olive_oil 6 tbsp; salt 1.5 tsp; yogurt 400 g; cucumber 2 pc",
  ["اسلق {brown_lentils} في 5 أكواب ماء 15 دقيقة.",
   "قطّع {onion} شرائح رفيعة وحمّرها في {olive_oil} حتى تصبح بنية مقرمشة، وارفع نصفها للتزيين.",
   "أضف {rice} المنقوع و{cumin} و{salt} للعدس مع البصل المتبقي وزيته.",
   "اطبخها على نار هادئة 20 دقيقة.",
   "قدّمها مع البصل المقرمش وسلطة {yogurt} بـ {cucumber}."])

R("fattoush", "فتوش", "🥗", "d", "levant healthy", 15, "",
  "lettuce 1 pc; tomato 3 pc; cucumber 3 pc; bell_pepper 1 pc; mint 1 pc; parsley 1 pc; arabic_bread 2 pc; lemon 2 pc; olive_oil 5 tbsp; salt 0.75 tsp; halloumi 250 g",
  ["قطّع {arabic_bread} مربعات وحمّصها حتى تقرمش.",
   "قطّع {lettuce} و{tomato} و{cucumber} و{bell_pepper}، وافرم {mint} و{parsley}.",
   "اخفق عصير {lemon} مع {olive_oil} و{salt}.",
   "اشوِ {halloumi} مكعبات في مقلاة.",
   "اخلط الكل مع الخبز قبل التقديم مباشرة."])

R("tabbouleh", "تبولة مع حمص", "🌿", "d", "levant healthy", 20, "",
  "bulgur 80 g; parsley 3 pc; mint 1 pc; tomato 3 pc; onion 0.5 pc; lemon 3 pc; olive_oil 6 tbsp; salt 1 tsp; chickpeas_can 1 pc; tahini 3 tbsp; garlic 1 pc; arabic_bread 2 pc",
  ["انقع {bulgur} في عصير ثلث {lemon} و3 ملاعق ماء 10 دقائق.",
   "افرم {parsley} و{mint} ناعماً، وقطّع {tomato} و{onion} صغيراً.",
   "اخلط الكل مع عصير ليمونة و{olive_oil} و{salt}.",
   "للحمص: اخلط {chickpeas_can} مع {tahini} و{garlic} وعصير الليمونة الباقية بالخلاط أو اهرسه جيداً.",
   "قدّمها مع {arabic_bread}."])

R("freekeh_chicken", "فريكة بالدجاج", "🌾", "l", "levant", 70, "",
  "freekeh 400 g; chicken_whole 1 pc; onion 1 pc; seven_spice 2 tsp; cinnamon 1 pc; cardamom 4 pc; butter 2 tbsp; stock_cube 1 pc; salt 1.5 tsp; almonds 40 g",
  ["اسلق {chicken_whole} مقطعاً مع {cinnamon} و{cardamom} و{stock_cube} في 7 أكواب ماء 35 دقيقة.",
   "اغسل {freekeh} جيداً.",
   "حمّر {onion} في {butter}، وأضف الفريكة و{seven_spice} و{salt}، ثم 5 أكواب من المرق.",
   "اطبخها على نار هادئة 35 دقيقة.",
   "حمّر الدجاج وقدّمه فوق الفريكة مع {almonds}."])

R("shish_tawook", "شيش طاووق مع أرز", "🍢", "l d", "levant healthy", 40, "air_fryer",
  "chicken_breast 800 g; yogurt 150 g; garlic 4 pc; lemon 1 pc; paprika 2 tsp; tomato_paste 1 tbsp; olive_oil 2 tbsp; bell_pepper 1 pc; onion 1 pc; salt 1 tsp; rice 2 cup",
  ["قطّع {chicken_breast} مكعبات، وتبّلها بـ {yogurt} و{garlic} وعصير {lemon} و{paprika} و{tomato_paste} و{olive_oil} و{salt}. اتركها 30 دقيقة.",
   "اشبكها في أسياخ مع {bell_pepper} و{onion}.",
   "اشوِها في القلاية الهوائية على 200 درجة 14 دقيقة مع التقليب في المنتصف.",
   "قدّمها مع {rice} أبيض."])

R("kousa_mahshi", "كوسا محشي باللحم", "🥒", "l", "levant", 90, "",
  "zucchini 1200 g; rice 1 cup; minced_beef 300 g; tomato_paste 3 tbsp; tomato 2 pc; garlic 4 pc; mint 1 pc; seven_spice 2 tsp; lemon 1 pc; salt 1.5 tsp; veg_oil 1 tbsp",
  ["افرغ {zucchini} من الداخل.",
   "اخلط {rice} المغسول مع {minced_beef} و{seven_spice} ونصف {salt} و{tomato} مفرومة و{veg_oil}.",
   "احشُ الكوسا إلى ثلاثة أرباعها ورتبها في قدر.",
   "اخلط {tomato_paste} مع 4 أكواب ماء وباقي الملح واسكبه فوقها.",
   "اطبخها 45 دقيقة على نار هادئة، ثم أضف {garlic} مهروساً مع {mint} مجففة أو مفرومة و{lemon} آخر 5 دقائق."])

R("peas_stew", "يخنة بازلاء وجزر باللحم", "🟢", "l", "levant egyptian", 60, "",
  "beef_cubes 500 g; peas_carrots 900 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; seven_spice 1 tsp; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup; vermicelli 50 g",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، وأضف ماء يغطيه واتركه 40 دقيقة.",
   "أضف {peas_carrots} و{garlic} و{tomato_paste} و{seven_spice} و{salt} واطبخه 15 دقيقة.",
   "حمّر {vermicelli} في قليل من الزيت، وأضف {rice} و3.5 أكواب ماء واطبخه 20 دقيقة.",
   "قدّم اليخنة مع أرز بالشعيرية."])

R("musaqaa", "مسقعة باذنجان باللحم", "🍆", "l d", "levant egyptian", 60, "oven",
  "eggplant 3 pc; minced_beef 400 g; onion 1 pc; bell_pepper 1 pc; garlic 3 pc; crushed_tomatoes 2 pc; seven_spice 1 tsp; veg_oil 4 tbsp; salt 1 tsp; arabic_bread 4 pc",
  ["قطّع {eggplant} شرائح، ادهنها بـ {veg_oil} واشوِها في الفرن 20 دقيقة.",
   "حمّر {onion} و{bell_pepper} ثم أضف {minced_beef} و{garlic} و{seven_spice} و{salt}.",
   "رتّب الباذنجان واللحم في صينية، واسكب {crushed_tomatoes} فوقه.",
   "اخبزها على 190 درجة 25 دقيقة، وقدّمها مع {arabic_bread}."])

R("baba_tahini", "باذنجان مشوي بالطحينة واللبن", "🍆", "d", "levant healthy", 35, "oven",
  "eggplant 3 pc; tahini 4 tbsp; yogurt 200 g; garlic 2 pc; lemon 1 pc; olive_oil 3 tbsp; parsley 1 pc; salt 0.75 tsp; arabic_bread 4 pc; chickpeas_can 1 pc",
  ["اشوِ {eggplant} كاملاً في الفرن على 220 درجة 30 دقيقة حتى يطرى، ثم قشّره.",
   "اهرسه مع {tahini} و{yogurt} و{garlic} وعصير {lemon} و{salt}.",
   "سخّن {chickpeas_can} وضعه فوق المتبل مع {olive_oil} و{parsley} مفرومة.",
   "قدّمه مع {arabic_bread}."])

# ======================================================== egyptian
R("koshari", "كشري", "🍛", "l", "egyptian", 60, "",
  "rice 1.5 cup; brown_lentils 200 g; pasta 250 g; vermicelli 50 g; chickpeas_can 1 pc; onion 3 pc; crushed_tomatoes 2 pc; garlic 4 pc; vinegar 3 tbsp; cumin 2 tsp; chili_flakes 0.5 tsp; veg_oil 6 tbsp; salt 2 tsp",
  ["اسلق {brown_lentils} 15 دقيقة.",
   "حمّر {vermicelli} في قليل من الزيت، وأضف {rice} والعدس و3 أكواب ماء ونصف {salt} واطبخه 20 دقيقة.",
   "اسلق {pasta} وصفّها.",
   "حمّر {onion} شرائح في {veg_oil} حتى تقرمش.",
   "للصلصة: حمّر {garlic} في قليل من زيت البصل، وأضف {crushed_tomatoes} و{cumin} و{chili_flakes} وباقي الملح، ثم {vinegar}.",
   "قدّم الأرز والعدس ثم المعكرونة ثم {chickpeas_can} والصلصة والبصل المقرمش."])

R("molokhia_chicken", "ملوخية بالدجاج", "🥬", "l", "egyptian", 60, "",
  "molokhia 800 g; chicken_whole 1 pc; garlic 8 pc; coriander 1 pc; butter 2 tbsp; stock_cube 1 pc; cardamom 3 pc; bay_leaf 2 pc; salt 1.5 tsp; rice 2 cup",
  ["اسلق {chicken_whole} مقطعاً مع {cardamom} و{bay_leaf} و{stock_cube} في 6 أكواب ماء 35 دقيقة.",
   "أضف {molokhia} لـ 4 أكواب من المرق المغلي مع {salt} وقلّبها دقيقتين، ولا تتركها تغلي كثيراً.",
   "حمّر {garlic} مفروماً مع {coriander} في {butter} حتى يذهب لونه، وأضفه للملوخية (التقلية).",
   "حمّر الدجاج، وقدّمه مع الملوخية و{rice} أبيض."])

R("bechamel_pasta", "معكرونة بالبشاميل", "🧈", "l", "egyptian", 70, "oven",
  "pasta 500 g; minced_beef 400 g; onion 1 pc; tomato_paste 2 tbsp; milk 800 ml; butter 4 tbsp; flour 5 tbsp; nutmeg 0.25 tsp; eggs 1 pc; mozzarella 100 g; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["اسلق {pasta} 6 دقائق فقط وصفّها.",
   "حمّر {onion} و{minced_beef}، وأضف {tomato_paste} ونصف {salt} و{black_pepper}.",
   "البشاميل: ذوّب {butter} وأضف {flour} وقلّب دقيقة، ثم {milk} تدريجياً مع التحريك حتى يتكاثف. أضف {nutmeg} وباقي الملح، ثم {eggs} مخفوقة.",
   "في صينية: نصف المعكرونة مع قليل من البشاميل، ثم اللحم، ثم باقي المعكرونة، ثم باقي البشاميل و{mozzarella}.",
   "اخبزها على 200 درجة 30 دقيقة حتى يتحمّر الوجه."])

R("green_beans_meat", "فاصوليا خضراء باللحم", "🫛", "l", "egyptian levant", 60, "",
  "beef_cubes 500 g; green_beans 800 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; seven_spice 1 tsp; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، وأضف ماء يغطيه واتركه 40 دقيقة.",
   "أضف {green_beans} و{garlic} و{tomato_paste} و{crushed_tomatoes} و{seven_spice} و{salt}.",
   "اطبخها 20 دقيقة على نار هادئة.",
   "قدّمها مع {rice} أبيض."])

R("potato_tagine", "طاجن بطاطس باللحم في الفرن", "🥔", "l", "egyptian", 80, "oven",
  "beef_cubes 500 g; potato 5 pc; onion 2 pc; tomato 3 pc; tomato_paste 2 tbsp; bell_pepper 1 pc; garlic 3 pc; seven_spice 1 tsp; veg_oil 3 tbsp; salt 1.5 tsp; arabic_bread 4 pc",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، وأضف ماء واتركه 40 دقيقة.",
   "قطّع {potato} مكعبات و{bell_pepper} و{tomato} شرائح.",
   "رتّب البطاطس واللحم ومرقته في صينية، وأضف {tomato_paste} و{garlic} و{seven_spice} و{salt}.",
   "ضع شرائح الطماطم والفلفل فوقها واخبزها على 200 درجة 35 دقيقة.",
   "قدّمها مع {arabic_bread}."])

# ======================================================== italian
R("bolognese", "سباغيتي بولونيز", "🍝", "l d", "italian", 40, "",
  "spaghetti 500 g; minced_beef 500 g; onion 1 pc; carrot 1 pc; garlic 3 pc; crushed_tomatoes 2 pc; tomato_paste 1 tbsp; oregano 1 tsp; olive_oil 2 tbsp; salt 1 tsp; black_pepper 0.5 tsp; mozzarella 60 g",
  ["حمّر {onion} و{carrot} مبشوراً في {olive_oil}.",
   "أضف {minced_beef} وقلّبه حتى يتحمّر، ثم {garlic}.",
   "أضف {crushed_tomatoes} و{tomato_paste} و{oregano} و{salt} و{black_pepper}، واتركها 20 دقيقة.",
   "اسلق {spaghetti} وقدّمها مع الصلصة و{mozzarella} مبشورة."])

R("alfredo", "باستا ألفريدو بالدجاج", "🍗", "l d", "italian", 30, "",
  "pasta 500 g; chicken_breast 500 g; cream 400 ml; butter 2 tbsp; garlic 3 pc; mushroom 250 g; mozzarella 100 g; black_pepper 0.5 tsp; salt 1 tsp",
  ["اسلق {pasta} وصفّها مع الاحتفاظ بكوب من الماء.",
   "قطّع {chicken_breast} شرائح وحمّرها في {butter} مع {salt}.",
   "أضف {garlic} و{mushroom} وقلّب 4 دقائق.",
   "أضف {cream} و{mozzarella} و{black_pepper} حتى يذوب الجبن.",
   "اخلطها مع المعكرونة، وخفّفها بقليل من ماء السلق إن احتجت."])

R("tortilla_pizza", "بيتزا تورتيلا سريعة", "🍕", "d", "italian", 20, "oven",
  "tortilla 4 pc; crushed_tomatoes 1 pc; mozzarella 250 g; bell_pepper 1 pc; mushroom 150 g; oregano 1 tsp; olive_oil 1 tbsp; salt 0.25 tsp",
  ["سخّن الفرن على 220 درجة.",
   "اخلط {crushed_tomatoes} مع {oregano} و{salt} و{olive_oil}.",
   "افرد الصلصة على {tortilla}، ثم {mozzarella} و{bell_pepper} و{mushroom}.",
   "اخبزها 8 دقائق حتى يذوب الجبن ويقرمش الخبز."])

R("tuna_pasta", "معكرونة بالتونة والطماطم", "🐟", "l d", "italian", 25, "",
  "pasta 500 g; tuna_can 2 pc; crushed_tomatoes 1 pc; garlic 3 pc; onion 1 pc; olive_oil 3 tbsp; oregano 1 tsp; chili_flakes 0.25 tsp; salt 1 tsp; parsley 1 pc",
  ["اسلق {pasta} وصفّها.",
   "حمّر {onion} و{garlic} في {olive_oil}.",
   "أضف {crushed_tomatoes} و{oregano} و{chili_flakes} و{salt} واتركها 10 دقائق.",
   "أضف {tuna_can} مصفّاة، ثم اخلطها مع المعكرونة و{parsley}."])

R("arrabbiata", "سباغيتي أرابياتا بالخضار", "🌶️", "l d", "italian healthy", 25, "",
  "spaghetti 500 g; crushed_tomatoes 2 pc; garlic 4 pc; chili_flakes 1 tsp; zucchini 1 pc; bell_pepper 1 pc; olive_oil 4 tbsp; salt 1 tsp; mozzarella 80 g",
  ["اسلق {spaghetti}.",
   "حمّر {garlic} و{chili_flakes} في {olive_oil} دقيقة.",
   "أضف {zucchini} و{bell_pepper} مكعبات وقلّبها 4 دقائق.",
   "أضف {crushed_tomatoes} و{salt} واتركها 10 دقائق، ثم اخلطها مع الباستا و{mozzarella}."])

R("tomato_soup", "شوربة طماطم مع توست بالجبن", "🍅", "d", "italian healthy", 30, "",
  "tomato 6 pc; crushed_tomatoes 1 pc; onion 1 pc; garlic 2 pc; olive_oil 2 tbsp; stock_cube 1 pc; cream 100 ml; salt 0.75 tsp; toast 8 pc; cheddar 4 pc; butter 1 tbsp",
  ["حمّر {onion} و{garlic} في {olive_oil}.",
   "أضف {tomato} مقطعة و{crushed_tomatoes} و3 أكواب ماء مع {stock_cube} و{salt}، واتركها 20 دقيقة.",
   "اخلطها بالخلاط اليدوي وأضف {cream}.",
   "اعمل ساندويتشات {toast} مع {cheddar} وحمّرها في {butter}."])

# ======================================================== asian
R("soy_chicken", "دجاج بالصويا والثوم مع أرز", "🥢", "l d", "asian", 30, "",
  "chicken_thigh 700 g; soy_sauce 5 tbsp; honey 2 tbsp; garlic 5 pc; ginger 1 tsp; sesame 1 tbsp; veg_oil 2 tbsp; broccoli 400 g; rice 2 cup",
  ["اطبخ {rice} أبيض.",
   "قطّع {chicken_thigh} مكعبات وحمّرها في {veg_oil} على نار عالية.",
   "أضف {garlic} و{ginger}، ثم {soy_sauce} و{honey} وقلّب حتى تتكاثف الصلصة.",
   "اسلق {broccoli} على البخار 4 دقائق.",
   "قدّمه مع الأرز والبروكلي ورشّ {sesame}."])

R("chicken_noodles", "نودلز بالدجاج والخضار", "🍜", "l d", "asian", 25, "",
  "noodles 400 g; chicken_breast 400 g; carrot 2 pc; bell_pepper 1 pc; onion 1 pc; garlic 3 pc; soy_sauce 5 tbsp; honey 1 tbsp; veg_oil 2 tbsp; sesame 1 tbsp",
  ["اسلق {noodles} وصفّها.",
   "قطّع {chicken_breast} شرائح وحمّرها في {veg_oil}.",
   "أضف {onion} و{carrot} و{bell_pepper} شرائح رفيعة و{garlic} وقلّب 3 دقائق.",
   "أضف النودلز و{soy_sauce} و{honey} وقلّب على نار عالية دقيقتين.",
   "رشّ {sesame} وقدّمها."])

R("egg_fried_rice", "أرز مقلي بالبيض والخضار", "🍳", "l d", "asian", 20, "",
  "rice 2 cup; eggs 4 pc; peas_carrots 300 g; onion 1 pc; garlic 2 pc; soy_sauce 4 tbsp; veg_oil 3 tbsp; chicken_breast 300 g",
  ["اطبخ {rice} ويُفضّل أن يبرد تماماً (أرز من اليوم السابق ممتاز).",
   "حمّر {chicken_breast} مكعبات صغيرة في {veg_oil}، ثم {onion} و{garlic} و{peas_carrots}.",
   "ادفع الخضار للجانب واخفق {eggs} في المقلاة حتى تستوي.",
   "أضف الأرز و{soy_sauce} وقلّب على نار عالية 3 دقائق."])

R("coconut_curry", "كاري دجاج بحليب جوز الهند", "🥥", "l d", "asian indian", 40, "",
  "chicken_thigh 700 g; coconut_milk 1 pc; onion 1 pc; garlic 3 pc; ginger 1 tsp; curry 2 tbsp; tomato 2 pc; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup; coriander 1 pc",
  ["حمّر {onion} في {veg_oil}، ثم أضف {garlic} و{ginger} و{curry} وقلّب دقيقة.",
   "أضف {chicken_thigh} مقطعاً وقلّبه 5 دقائق.",
   "أضف {tomato} و{coconut_milk} و{salt} واتركه 20 دقيقة على نار هادئة.",
   "قدّمه مع {rice} أبيض و{coriander}."])

# ======================================================== indian
R("biryani", "برياني دجاج", "🍛", "l", "indian", 75, "",
  "chicken_thigh 800 g; rice 3 cup; yogurt 200 g; onion 3 pc; tomato 2 pc; garlic 4 pc; ginger 1 tsp; curry 1 tbsp; turmeric 0.5 tsp; cardamom 6 pc; cinnamon 1 pc; bay_leaf 2 pc; veg_oil 5 tbsp; mint 1 pc; salt 2 tsp",
  ["تبّل {chicken_thigh} بـ {yogurt} و{curry} و{turmeric} و{ginger} و{garlic} ونصف {salt}.",
   "حمّر {onion} شرائح في {veg_oil} حتى يصبح بنياً، وارفع نصفه.",
   "أضف الدجاج و{tomato} للبصل الباقي واطبخه 20 دقيقة.",
   "اسلق {rice} مع {cardamom} و{cinnamon} و{bay_leaf} وباقي الملح 6 دقائق فقط وصفّه.",
   "افرد الأرز فوق الدجاج مع البصل المحمّر و{mint}، وغطّه بإحكام على نار هادئة جداً 20 دقيقة."])

R("dal", "دال عدس هندي", "🍲", "l d", "indian healthy", 35, "",
  "red_lentils 300 g; onion 1 pc; tomato 2 pc; garlic 3 pc; ginger 1 tsp; cumin 1 tsp; turmeric 1 tsp; curry 1 tsp; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup; coriander 1 pc; lemon 1 pc",
  ["اسلق {red_lentils} في 4 أكواب ماء مع {turmeric} 20 دقيقة حتى يتهرس.",
   "حمّر {onion} في {veg_oil}، ثم {garlic} و{ginger} و{cumin} و{curry}، ثم {tomato}.",
   "اخلطها مع العدس وأضف {salt} وعصير {lemon}.",
   "قدّمه مع {rice} و{coriander}."])

R("aloo_gobi", "بطاطس وقرنبيط بالكاري", "🥔", "l d", "indian healthy", 35, "",
  "potato 3 pc; cauliflower 1 pc; onion 1 pc; tomato 2 pc; garlic 3 pc; ginger 1 tsp; curry 1 tbsp; turmeric 0.5 tsp; cumin 1 tsp; veg_oil 4 tbsp; salt 1 tsp; arabic_bread 4 pc; yogurt 300 g",
  ["قطّع {potato} مكعبات و{cauliflower} زهرات.",
   "حمّر {onion} في {veg_oil}، وأضف {garlic} و{ginger} و{cumin} و{curry} و{turmeric}.",
   "أضف البطاطس والقرنبيط و{tomato} و{salt} ونصف كوب ماء، وغطّه 20 دقيقة.",
   "قدّمه مع {arabic_bread} و{yogurt}."])

# ======================================================== mexican
R("beef_tacos", "تاكو لحم مفروم", "🌮", "d", "mexican", 25, "",
  "tortilla 8 pc; minced_beef 500 g; onion 1 pc; garlic 2 pc; cumin 1 tsp; paprika 2 tsp; tomato 2 pc; lettuce 0.5 pc; cheddar 6 pc; lemon 1 pc; veg_oil 1 tbsp; salt 1 tsp",
  ["حمّر {onion} في {veg_oil}، ثم {minced_beef} و{garlic} و{cumin} و{paprika} و{salt}.",
   "قطّع {tomato} و{lettuce} صغيراً.",
   "سخّن {tortilla} في مقلاة جافة.",
   "احشُها باللحم والخضار و{cheddar} مقطعاً، وأضف عصير {lemon}."])

R("chicken_burrito", "بوريتو دجاج بالأرز والفاصوليا", "🌯", "l d", "mexican", 35, "",
  "tortilla 8 pc; chicken_breast 500 g; rice 1 cup; kidney_beans 1 pc; corn_can 1 pc; tomato 2 pc; onion 1 pc; paprika 2 tsp; cumin 1 tsp; cheddar 6 pc; lemon 1 pc; veg_oil 2 tbsp; salt 1 tsp",
  ["اطبخ {rice} أبيض وأضف له عصير {lemon}.",
   "قطّع {chicken_breast} شرائح وتبّلها بـ {paprika} و{cumin} و{salt} وحمّرها في {veg_oil}.",
   "سخّن {kidney_beans} و{corn_can}.",
   "افرد {tortilla} وضع الأرز والدجاج والفاصوليا والذرة و{tomato} و{onion} و{cheddar}، ثم لفّها."])

R("quesadilla", "كساديا دجاج بالجبن", "🧀", "d", "mexican", 25, "",
  "tortilla 8 pc; chicken_breast 400 g; mozzarella 250 g; bell_pepper 1 pc; onion 1 pc; paprika 1 tsp; veg_oil 1 tbsp; salt 0.75 tsp; yogurt 200 g",
  ["قطّع {chicken_breast} صغيراً وتبّله بـ {paprika} و{salt}، واطهه مع {onion} و{bell_pepper} في {veg_oil}.",
   "ضع على نصف كل {tortilla} الدجاج و{mozzarella} ثم اطوها.",
   "حمّرها في مقلاة جافة دقيقتين لكل جهة.",
   "قطّعها مثلثات وقدّمها مع {yogurt}."])

# ======================================================== healthy
R("grilled_chicken_veg", "صدور دجاج مشوية مع خضار", "🥦", "l d", "healthy", 35, "air_fryer",
  "chicken_breast 800 g; zucchini 2 pc; bell_pepper 2 pc; broccoli 400 g; olive_oil 3 tbsp; garlic 3 pc; lemon 1 pc; paprika 1 tsp; oregano 1 tsp; salt 1 tsp",
  ["تبّل {chicken_breast} بنصف {olive_oil} و{garlic} وعصير {lemon} و{paprika} ونصف {salt}.",
   "قطّع {zucchini} و{bell_pepper} واخلطها مع {broccoli} وباقي الزيت و{oregano} والملح.",
   "اشوِ الدجاج في القلاية الهوائية على 200 درجة 18 دقيقة مع التقليب.",
   "اشوِ الخضار 10 دقائق، وقدّمها مع الدجاج."])

R("tuna_corn_salad", "سلطة تونة بالذرة", "🥗", "d", "healthy", 10, "",
  "tuna_can 3 pc; corn_can 1 pc; lettuce 1 pc; cucumber 2 pc; tomato 2 pc; lemon 1 pc; olive_oil 3 tbsp; salt 0.5 tsp; arabic_bread 2 pc",
  ["قطّع {lettuce} و{cucumber} و{tomato}.",
   "أضف {tuna_can} و{corn_can} مصفّاة.",
   "اخفق عصير {lemon} مع {olive_oil} و{salt} واسكبه فوق السلطة.",
   "قدّمها مع {arabic_bread} محمّص."])

R("baked_fish", "سمك بالفرن مع بطاطس وليمون", "🐠", "l d", "healthy levant", 45, "oven",
  "fish_fillet 800 g; potato 4 pc; lemon 2 pc; garlic 4 pc; olive_oil 4 tbsp; cumin 1 tsp; paprika 1 tsp; coriander 1 pc; salt 1.5 tsp",
  ["قطّع {potato} شرائح، واخلطها بنصف {olive_oil} ونصف {salt}، واشوِها في الفرن على 210 درجة 20 دقيقة.",
   "اخلط {garlic} مع {coriander} مفرومة و{cumin} و{paprika} وعصير نصف {lemon} وباقي الزيت والملح.",
   "ادهن {fish_fillet} بالخليط وضعه فوق البطاطس مع شرائح الليمونة الثانية.",
   "اخبزه 15 دقيقة حتى يتفتت السمك بسهولة."])

R("airfryer_thighs", "أفخاذ دجاج بالقلاية الهوائية مع بطاطس", "🍟", "l d", "healthy", 35, "air_fryer",
  "chicken_thigh 800 g; potato 4 pc; paprika 2 tsp; garlic 3 pc; olive_oil 2 tbsp; lemon 1 pc; salt 1.5 tsp; black_pepper 0.5 tsp; lettuce 0.5 pc; tomato 2 pc",
  ["تبّل {chicken_thigh} بـ {paprika} و{garlic} ونصف {olive_oil} وعصير {lemon} ونصف {salt} و{black_pepper}.",
   "قطّع {potato} أصابع واخلطها بباقي الزيت والملح.",
   "اشوِ البطاطس 12 دقيقة على 200 درجة، ثم الدجاج 18 دقيقة.",
   "قدّمه مع سلطة {lettuce} و{tomato}."])

R("chicken_salad", "سلطة دجاج مشوي بالأفوكادو", "🥑", "d", "healthy", 20, "",
  "chicken_breast 500 g; lettuce 1 pc; cucumber 2 pc; tomato 2 pc; avocado 1 pc; feta 100 g; lemon 1 pc; olive_oil 4 tbsp; salt 0.75 tsp; black_pepper 0.25 tsp",
  ["تبّل {chicken_breast} بنصف {salt} و{black_pepper}، واشوِه في مقلاة مع ملعقة زيت 6 دقائق لكل جهة، ثم قطّعه.",
   "قطّع {lettuce} و{cucumber} و{tomato} و{avocado}.",
   "اخفق عصير {lemon} مع باقي {olive_oil} والملح.",
   "اجمع الكل مع {feta} مفتتة."])

R("veg_soup", "شوربة خضار", "🥕", "d", "healthy", 35, "",
  "carrot 2 pc; potato 2 pc; zucchini 2 pc; onion 1 pc; tomato_paste 1 tbsp; peas_carrots 200 g; vermicelli 50 g; olive_oil 2 tbsp; stock_cube 1 pc; salt 1 tsp; black_pepper 0.25 tsp; arabic_bread 2 pc",
  ["حمّر {onion} في {olive_oil}، ثم أضف {tomato_paste}.",
   "أضف {carrot} و{potato} و{zucchini} مكعبات و{peas_carrots}.",
   "أضف 7 أكواب ماء مع {stock_cube} و{salt} و{black_pepper} واتركها 20 دقيقة.",
   "أضف {vermicelli} واطبخها 5 دقائق، وقدّمها مع {arabic_bread}."])

R("airfryer_kofta", "كفتة بالقلاية الهوائية مع سلطة", "🥙", "d l", "healthy levant", 30, "air_fryer",
  "minced_beef 600 g; onion 1 pc; parsley 1 pc; seven_spice 2 tsp; salt 1 tsp; cucumber 2 pc; tomato 2 pc; yogurt 300 g; mint 1 pc; arabic_bread 4 pc",
  ["اخلط {minced_beef} مع {onion} مبشوراً ومعصوراً و{parsley} و{seven_spice} و{salt}.",
   "شكّلها أصابع واشوِها في القلاية الهوائية على 200 درجة 12 دقيقة.",
   "اعمل سلطة من {cucumber} و{tomato}، ولبن بالنعناع من {yogurt} و{mint}.",
   "قدّمها مع {arabic_bread}."])

R("tuna_sandwich", "ساندويتش تونة بالذرة", "🥪", "d", "healthy", 10, "",
  "toast 8 pc; tuna_can 2 pc; corn_can 0.5 pc; mayo 3 tbsp; lemon 0.5 pc; lettuce 0.5 pc; tomato 2 pc; black_pepper 0.25 tsp",
  ["اخلط {tuna_can} مصفّاة مع {corn_can} و{mayo} وعصير {lemon} و{black_pepper}.",
   "افرد الخليط على {toast} مع {lettuce} و{tomato}.",
   "أغلق الساندويتش وقطّعه."])

R("halloumi_wrap", "لفائف حلوم وخضار", "🌯", "d", "levant healthy", 15, "",
  "tortilla 4 pc; halloumi 250 g; cucumber 1 pc; tomato 2 pc; lettuce 0.5 pc; mint 1 pc; olive_oil 1 tbsp; labneh 100 g",
  ["قطّع {halloumi} أصابع واشوِها في {olive_oil}.",
   "افرد {labneh} على {tortilla}.",
   "أضف الحلوم و{cucumber} و{tomato} و{lettuce} و{mint}، ثم لفّها."])

R("lentil_rice_stew", "يخنة عدس بني بالخضار", "🍲", "l d", "healthy levant", 45, "",
  "brown_lentils 300 g; carrot 2 pc; potato 2 pc; onion 1 pc; garlic 3 pc; crushed_tomatoes 1 pc; cumin 1.5 tsp; olive_oil 3 tbsp; lemon 1 pc; salt 1.5 tsp; arabic_bread 4 pc",
  ["حمّر {onion} و{garlic} في {olive_oil}.",
   "أضف {brown_lentils} و{carrot} و{potato} مكعبات و{cumin}، ثم 6 أكواب ماء.",
   "اطبخها 30 دقيقة، ثم أضف {crushed_tomatoes} و{salt} واتركها 10 دقائق.",
   "أضف عصير {lemon} وقدّمها مع {arabic_bread}."])

R("veggie_pasta", "معكرونة بالخضار والفطر", "🍄", "l d", "italian healthy", 25, "",
  "pasta 500 g; mushroom 250 g; zucchini 1 pc; bell_pepper 1 pc; garlic 3 pc; crushed_tomatoes 1 pc; cream 100 ml; olive_oil 3 tbsp; oregano 1 tsp; salt 1 tsp; mozzarella 80 g",
  ["اسلق {pasta}.",
   "حمّر {garlic} في {olive_oil}، ثم {mushroom} و{zucchini} و{bell_pepper}.",
   "أضف {crushed_tomatoes} و{oregano} و{salt} واتركها 8 دقائق، ثم {cream}.",
   "اخلطها مع المعكرونة و{mozzarella}."])

R("chicken_wrap", "لفائف دجاج بالخضار", "🌯", "d", "healthy", 20, "",
  "tortilla 6 pc; chicken_breast 500 g; lettuce 0.5 pc; tomato 2 pc; cucumber 1 pc; yogurt 150 g; garlic 1 pc; paprika 1 tsp; lemon 1 pc; veg_oil 1 tbsp; salt 0.75 tsp",
  ["قطّع {chicken_breast} شرائح وتبّلها بـ {paprika} و{salt} ونصف {lemon} وحمّرها في {veg_oil}.",
   "اخلط {yogurt} مع {garlic} وعصير باقي الليمون.",
   "افرد الصلصة على {tortilla} وأضف الدجاج و{lettuce} و{tomato} و{cucumber}، ثم لفّها."])
