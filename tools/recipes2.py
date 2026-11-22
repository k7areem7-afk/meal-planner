# -*- coding: utf-8 -*-
"""More original recipes (v2) and which dishes keep well for a second day."""
from recipes import R

# ======================================================== breakfast
R("egg_roll_bread", "رول بيض بالخبز العربي", "🌯", "b", "saudi", 10, "",
  "eggs 6 pc; arabic_bread 4 pc; cheese_triangles 4 pc; tomato 1 pc; butter 1 tbsp; salt 0.25 tsp",
  ["اخفق {eggs} مع {salt} واطبخها في {butter} عجة رقيقة.",
   "افرد {cheese_triangles} على {arabic_bread}.",
   "ضع البيض وشرائح {tomato} ولفّه، وحمّره في المقلاة دقيقة لكل جهة."])

R("boiled_eggs_plate", "بيض مسلوق مع جبن وزيتون", "🥚", "b", "levant healthy", 15, "",
  "eggs 8 pc; feta 150 g; olives 100 g; cucumber 2 pc; tomato 2 pc; olive_oil 1 tbsp; arabic_bread 4 pc",
  ["اسلق {eggs} في ماء مغلي 9 دقائق ثم بردها وقشرها.",
   "رتّب {feta} و{olives} وشرائح {cucumber} و{tomato} في صحن.",
   "اسكب {olive_oil} وقدّمها مع البيض و{arabic_bread}."])

R("triangles_olives", "جبنة مثلثات وزيتون وزعتر", "🧀", "b", "saudi levant", 5, "",
  "cheese_triangles 8 pc; olives 100 g; zaatar 3 tbsp; olive_oil 3 tbsp; cucumber 2 pc; arabic_bread 4 pc",
  ["افرد {cheese_triangles} على {arabic_bread}.",
   "قدّمها مع {olives} و{cucumber}.",
   "اخلط {zaatar} مع {olive_oil} للتغميس."])

R("hummus_plate", "حمص بالطحينة", "🥣", "b d", "levant", 15, "blender",
  "chickpeas_can 2 pc; tahini 5 tbsp; lemon 1 pc; garlic 1 pc; olive_oil 3 tbsp; cumin 0.5 tsp; salt 0.5 tsp; arabic_bread 4 pc",
  ["اخلط {chickpeas_can} (مصفّى) مع {tahini} وعصير {lemon} و{garlic} و{salt} وقليل من الماء البارد بالخلاط حتى ينعم.",
   "افرده في صحن واعمل حفرة في الوسط.",
   "اسكب {olive_oil} ورشّ {cumin}، وقدّمه مع {arabic_bread}."])

R("foul_tahini", "فول بالطحينة والطماطم", "🫘", "b", "saudi", 15, "",
  "fava_can 2 pc; tahini 3 tbsp; tomato 2 pc; onion 0.5 pc; lemon 1 pc; cumin 1 tsp; chili_flakes 0.25 tsp; olive_oil 2 tbsp; arabic_bread 4 pc",
  ["سخّن {fava_can} 5 دقائق واهرسه.",
   "اخلط {tahini} مع عصير {lemon} وقليل من الماء، وأضفها للفول مع {cumin}.",
   "قطّع {tomato} و{onion} صغيراً فوقه، ورشّ {chili_flakes} و{olive_oil}.",
   "قدّمه مع {arabic_bread}."])

R("labneh_toast", "توست لبنة وخيار ونعناع", "🥒", "b", "healthy levant", 8, "",
  "toast 8 pc; labneh 200 g; cucumber 2 pc; mint 1 pc; olive_oil 1 tbsp; zaatar 1 tbsp",
  ["حمّص {toast}.",
   "افرد {labneh} عليه، ثم شرائح {cucumber} وأوراق {mint}.",
   "اسكب {olive_oil} ورشّ {zaatar}."])

R("pb_banana_toast", "توست زبدة الفول السوداني والموز", "🍌", "b", "western", 5, "",
  "toast 8 pc; peanut_butter 6 tbsp; banana 2 pc; honey 2 tbsp; milk 800 ml",
  ["حمّص {toast} وافرد عليه {peanut_butter}.",
   "ضع شرائح {banana} واسكب {honey}.",
   "قدّمه مع كوب {milk}."])

R("baked_oats", "شوفان مخبوز بالتفاح والقرفة", "🍎", "b", "healthy western", 35, "oven",
  "oats 200 g; milk 400 ml; eggs 2 pc; apple 2 pc; honey 4 tbsp; cinnamon 1 tsp; baking_powder 1 tsp; butter 1 tbsp",
  ["سخّن الفرن على 180 درجة وادهن صينية صغيرة بـ {butter}.",
   "اخلط {oats} مع {milk} و{eggs} و{honey} و{cinnamon} و{baking_powder}.",
   "أضف {apple} مقطعاً مكعبات صغيرة، واسكب الخليط في الصينية.",
   "اخبزه 25 دقيقة حتى يتماسك ويتحمّر."])

R("areeka", "عريكة بالتمر والعسل", "🍯", "b", "saudi", 40, "",
  "flour 300 g; butter 4 tbsp; dates 15 pc; honey 4 tbsp; salt 0.25 tsp",
  ["اعجن {flour} مع {salt} وماء دافئ حتى تصير عجينة طرية.",
   "اقسمها أقراصاً واخبزها على مقلاة جافة حتى تنضج من الجهتين.",
   "افرك الخبز وهو ساخن ناعماً بيدك أو بالمحضرة.",
   "أضف {dates} منزوع النوى و{butter} واعجنها حتى تتجانس.",
   "شكّلها في صحن واعمل حفرة في الوسط، واسكب {honey} وقليلاً من الزبدة."])

R("masoob", "معصوب بالموز والعسل", "🍌", "b", "saudi", 15, "",
  "arabic_bread 4 pc; banana 4 pc; honey 4 tbsp; butter 2 tbsp; cream 100 ml",
  ["قطّع {arabic_bread} وحمّصه قليلاً في المقلاة.",
   "اهرس {banana} مع الخبز و{butter} حتى يتجانس.",
   "وزّعه في أطباق، واسكب {cream} و{honey} فوقه."])

R("eggs_potato", "بيض بالبطاطس والبصل", "🥔", "b d", "saudi levant", 20, "",
  "eggs 6 pc; potato 3 pc; onion 1 pc; veg_oil 3 tbsp; cumin 0.5 tsp; salt 0.75 tsp; arabic_bread 4 pc",
  ["قطّع {potato} مكعبات صغيرة واقلها في {veg_oil} حتى تتحمّر وتنضج.",
   "أضف {onion} مفروماً وقلّبه دقيقتين.",
   "اخفق {eggs} مع {salt} و{cumin} واسكبها فوق البطاطس مع التقليب حتى تستوي.",
   "قدّمه مع {arabic_bread}."])

R("french_toast", "فرنش توست بالقرفة والعسل", "🍞", "b", "western", 15, "",
  "toast 8 pc; eggs 3 pc; milk 200 ml; cinnamon 1 tsp; sugar 1 tbsp; butter 2 tbsp; honey 4 tbsp",
  ["اخفق {eggs} مع {milk} و{cinnamon} و{sugar}.",
   "اغمس {toast} في الخليط من الجهتين.",
   "حمّره في {butter} على نار متوسطة دقيقتين لكل جهة.",
   "قدّمه مع {honey}."])

R("fruit_yogurt", "زبادي بالفواكه والعسل", "🍓", "b", "healthy", 5, "",
  "yogurt 600 g; banana 2 pc; apple 1 pc; oats 60 g; honey 3 tbsp; raisins 30 g",
  ["قطّع {banana} و{apple} مكعبات.",
   "وزّع {yogurt} في أكواب وأضف الفواكه و{oats} و{raisins}.",
   "اسكب {honey} فوقه."])

R("frittata", "عجة بالخضار والجبن في الفرن", "🥧", "b d", "healthy italian", 30, "oven",
  "eggs 8 pc; spinach 200 g; bell_pepper 1 pc; onion 1 pc; mozzarella 100 g; milk 100 ml; olive_oil 1 tbsp; salt 0.75 tsp; black_pepper 0.25 tsp",
  ["سخّن الفرن على 190 درجة.",
   "حمّر {onion} و{bell_pepper} في {olive_oil}، ثم أضف {spinach} حتى يجف ماؤها.",
   "اخفق {eggs} مع {milk} و{salt} و{black_pepper} و{mozzarella}.",
   "اسكب البيض فوق الخضار في صينية مدهونة واخبزها 18 دقيقة."])

R("halawa_plate", "حلاوة طحينية مع جبن وخبز", "🍬", "b", "levant saudi", 5, "",
  "halawa 150 g; feta 150 g; olives 80 g; cucumber 1 pc; arabic_bread 4 pc",
  ["قطّع {halawa} و{feta} مكعبات.",
   "قدّمها مع {olives} و{cucumber} و{arabic_bread}."])

R("cheese_manakish", "منقوشة جبن", "🫓", "b d", "levant", 15, "oven",
  "arabic_bread 4 pc; mozzarella 200 g; feta 100 g; zaatar 1 tbsp; olive_oil 2 tbsp; tomato 2 pc",
  ["سخّن الفرن على 200 درجة.",
   "اخلط {mozzarella} مع {feta} مفتتاً.",
   "ادهن {arabic_bread} بـ {olive_oil} ووزع الجبن ورشّ {zaatar}.",
   "اخبزه 7 دقائق حتى يذوب الجبن، وقدّمه مع {tomato}."])

R("cheese_sambosa", "سمبوسة جبن بالقلاية الهوائية", "🔺", "b d", "saudi", 30, "air_fryer",
  "sambosa_sheets 16 pc; feta 150 g; mozzarella 150 g; parsley 1 pc; veg_oil 2 tbsp; yogurt 200 g",
  ["اخلط {feta} و{mozzarella} و{parsley} مفرومة.",
   "ضع ملعقة من الخليط على طرف {sambosa_sheets} واطوها مثلثات، وألصق الطرف بقليل من الماء.",
   "ادهنها بـ {veg_oil} واشوِها في القلاية الهوائية على 190 درجة 10 دقائق مع التقليب.",
   "قدّمها مع {yogurt}."])

R("fries_eggs", "بطاطس مقلية مع بيض عيون", "🍳", "b d", "western", 25, "air_fryer",
  "potato 4 pc; eggs 6 pc; veg_oil 2 tbsp; paprika 1 tsp; salt 1 tsp; ketchup 4 tbsp",
  ["قطّع {potato} أصابع، واخلطها بنصف {veg_oil} و{paprika} ونصف {salt}.",
   "اشوِها في القلاية الهوائية على 200 درجة 18 دقيقة مع التقليب.",
   "اقلِ {eggs} عيوناً في باقي الزيت مع باقي الملح.",
   "قدّمها مع {ketchup}."])

# ======================================================== saudi / gulf
R("bukhari_chicken", "رز بخاري بالدجاج", "🍗", "l", "saudi", 80, "",
  "chicken_whole 1 pc; rice 3 cup; onion 2 pc; carrot 2 pc; tomato_paste 1 tbsp; garlic 4 pc; cardamom 5 pc; cinnamon 1 pc; black_lime 2 pc; cumin 1 tsp; raisins 50 g; veg_oil 4 tbsp; stock_cube 1 pc; salt 1.5 tsp",
  ["حمّر {onion} في {veg_oil} حتى يصير ذهبياً، ثم أضف {chicken_whole} مقطعاً و{garlic}.",
   "أضف {tomato_paste} و{cardamom} و{cinnamon} و{black_lime} و{cumin} و{salt} و6 أكواب ماء مع {stock_cube}. اتركه 35 دقيقة.",
   "أخرج الدجاج وحمّره. أضف {rice} المنقوع للمرق مع {carrot} مبشوراً.",
   "اطبخه على نار هادئة 25 دقيقة، ثم وزّع {raisins} فوقه وقدّمه مع الدجاج."])

R("shrimp_kabsa", "كبسة روبيان", "🍤", "l", "saudi", 50, "",
  "shrimp 700 g; rice 3 cup; onion 2 pc; tomato 3 pc; tomato_paste 2 tbsp; garlic 5 pc; kabsa_spice 1 tbsp; black_lime 2 pc; coriander 1 pc; veg_oil 4 tbsp; salt 1.5 tsp",
  ["حمّر {onion} في {veg_oil}، وأضف {garlic} و{tomato} و{tomato_paste} و{kabsa_spice} و{black_lime} و{salt}.",
   "أضف 5 أكواب ماء واتركه يغلي، ثم أضف {rice} المنقوع واطبخه على نار هادئة 20 دقيقة.",
   "قلّب {shrimp} في مقلاة مع قليل من الزيت 4 دقائق.",
   "وزّع الروبيان فوق الرز وغطّه 5 دقائق، وزيّنه بـ {coriander}."])

R("haneeth", "حنيذ لحم بالفرن", "🍖", "l", "saudi", 180, "oven",
  "lamb 1500 g; rice 3 cup; onion 1 pc; kabsa_spice 1 tbsp; turmeric 1 tsp; garlic 5 pc; black_lime 2 pc; cardamom 6 pc; butter 2 tbsp; salt 2 tsp",
  ["تبّل {lamb} بـ {kabsa_spice} و{turmeric} و{garlic} و{salt} و{butter}.",
   "لفّه بورق القصدير بإحكام واطبخه في الفرن على 170 درجة ساعتين ونصف.",
   "اطبخ {rice} مع {onion} و{cardamom} و{black_lime} ومرق اللحم المتجمع في الورق.",
   "افتح الورق وحمّر اللحم 10 دقائق على 220 درجة، وقدّمه فوق الرز."])

R("madhbi_chicken", "دجاج مظبي مع رز أبيض", "🔥", "l d", "saudi", 60, "oven",
  "chicken_whole 1 pc; rice 2.5 cup; lemon 1 pc; garlic 4 pc; kabsa_spice 2 tsp; paprika 1 tsp; olive_oil 3 tbsp; cardamom 4 pc; tomato 3 pc; green_chili 2 pc; salt 1.5 tsp",
  ["افتح {chicken_whole} من الظهر وتبّله بـ {kabsa_spice} و{paprika} و{garlic} وعصير {lemon} و{olive_oil} و{salt}.",
   "اشوِه في الفرن على 220 درجة 45 دقيقة حتى يتحمّر.",
   "اطبخ {rice} أبيض مع {cardamom}.",
   "للصلصة: اهرس {tomato} مع {green_chili} وقليل من الملح، وقدّمها مع الدجاج والرز."])

R("marqa_meat", "مرقة لحم بالخضار", "🍲", "l d", "saudi", 90, "",
  "beef_cubes 600 g; potato 3 pc; carrot 2 pc; zucchini 2 pc; onion 1 pc; tomato 3 pc; tomato_paste 2 tbsp; kabsa_spice 2 tsp; black_lime 1 pc; veg_oil 2 tbsp; salt 1.5 tsp; arabic_bread 4 pc",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}.",
   "أضف {tomato} و{tomato_paste} و{kabsa_spice} و{black_lime} و{salt}، ثم 6 أكواب ماء. اتركه 50 دقيقة.",
   "أضف {potato} و{carrot} مكعبات واتركها 15 دقيقة، ثم {zucchini} 10 دقائق.",
   "قدّمها مع {arabic_bread}."])

R("red_rice_chicken", "رز بالصلصة والدجاج", "🍅", "l", "saudi", 60, "",
  "chicken_thigh 800 g; rice 3 cup; onion 1 pc; tomato 3 pc; tomato_paste 3 tbsp; garlic 3 pc; kabsa_spice 2 tsp; bell_pepper 1 pc; veg_oil 3 tbsp; salt 1.5 tsp",
  ["حمّر {chicken_thigh} مقطعاً مع {onion} في {veg_oil}.",
   "أضف {garlic} و{bell_pepper} و{tomato} مبشورة و{tomato_paste} و{kabsa_spice} و{salt}.",
   "أضف 5 أكواب ماء ثم {rice} المنقوع، واطبخه على نار هادئة 25 دقيقة."])

R("harees", "هريس بالدجاج", "🥣", "l d", "saudi", 120, "",
  "jareesh 400 g; chicken_breast 500 g; butter 3 tbsp; cinnamon 1 pc; cardamom 4 pc; salt 1.5 tsp; sugar 1 tsp",
  ["انقع {jareesh} ساعتين.",
   "اسلق {chicken_breast} مع {cinnamon} و{cardamom} في 8 أكواب ماء 20 دقيقة، ثم فتّته.",
   "أضف الجريش للمرق مع {salt} واطبخه على نار هادئة 90 دقيقة مع التحريك.",
   "أضف الدجاج واضربه بالمضرب الخشبي حتى يصير ناعماً متماسكاً، وأضف {sugar}.",
   "قدّمه وفوقه {butter} مذابة."])

R("fried_fish_daqoos", "سمك مقلي مع رز ودقوس", "🐟", "l", "saudi", 40, "",
  "fish_fillet 800 g; flour 4 tbsp; cumin 1 tsp; turmeric 0.5 tsp; lemon 1 pc; veg_oil 6 tbsp; rice 2 cup; tomato 3 pc; garlic 3 pc; green_chili 2 pc; salt 1.5 tsp",
  ["تبّل {fish_fillet} بـ {cumin} و{turmeric} ونصف {salt} وعصير {lemon}، وغلّفه بـ {flour}.",
   "اقلِه في {veg_oil} حتى يتحمّر من الجهتين.",
   "اطبخ {rice} أبيض.",
   "للدقوس: اطبخ {tomato} مبشورة مع {garlic} و{green_chili} وباقي الملح 10 دقائق.",
   "قدّم السمك مع الرز والدقوس."])

R("chicken_veg_rice", "صينية دجاج وبطاطس بالفرن", "🥔", "l d", "levant saudi", 60, "oven",
  "chicken_thigh 900 g; potato 5 pc; onion 2 pc; lemon 2 pc; garlic 5 pc; seven_spice 2 tsp; paprika 1 tsp; olive_oil 4 tbsp; salt 1.5 tsp",
  ["قطّع {potato} و{onion} شرائح سميكة ورتبها في صينية.",
   "تبّل {chicken_thigh} بـ {seven_spice} و{paprika} و{garlic} وعصير {lemon} و{olive_oil} و{salt}.",
   "ضع الدجاج فوق البطاطس مع نصف كوب ماء.",
   "اخبزها على 200 درجة 45 دقيقة حتى يتحمّر الدجاج وتنضج البطاطس."])

# ======================================================== levant
R("kibbeh_tray", "كبة بالصينية", "🥮", "l", "levant", 75, "oven",
  "bulgur 300 g; minced_beef 700 g; onion 2 pc; seven_spice 2 tsp; cinnamon 0.5 tsp; almonds 50 g; veg_oil 5 tbsp; salt 1.5 tsp; yogurt 400 g; cucumber 2 pc",
  ["انقع {bulgur} 15 دقيقة واعصره، واعجنه مع ثلثي {minced_beef} ونصف {onion} مبشوراً ونصف {salt} و{seven_spice}.",
   "للحشوة: حمّر باقي البصل مع باقي اللحم و{cinnamon} و{almonds} وباقي الملح.",
   "افرد نصف عجينة الكبة في صينية مدهونة، ثم الحشوة، ثم باقي العجينة.",
   "قطّعها معينات واسكب {veg_oil} فوقها، واخبزها على 200 درجة 35 دقيقة.",
   "قدّمها مع {yogurt} و{cucumber}."])

R("mansaf_chicken", "منسف دجاج باللبن", "🍚", "l", "levant", 70, "",
  "chicken_whole 1 pc; yogurt 800 g; rice 3 cup; arabic_bread 2 pc; almonds 50 g; butter 3 tbsp; flour 1 tbsp; turmeric 0.5 tsp; cardamom 4 pc; bay_leaf 2 pc; salt 1.5 tsp",
  ["اسلق {chicken_whole} مقطعاً مع {cardamom} و{bay_leaf} في 6 أكواب ماء 35 دقيقة.",
   "اخفق {yogurt} مع {flour} وسخّنه مع التحريك المستمر في اتجاه واحد حتى يغلي، ثم أضف كوبين من المرق والدجاج 10 دقائق.",
   "اطبخ {rice} مع {turmeric} ونصف {butter} و{salt}.",
   "افرد {arabic_bread} في الصينية، ثم الرز ثم الدجاج، واسكب اللبن. زيّنه بـ {almonds} محمّرة في باقي الزبدة."])

R("musakhan", "مسخن دجاج", "🧅", "l d", "levant", 75, "oven",
  "chicken_whole 1 pc; onion 5 pc; sumac 3 tbsp; olive_oil 8 tbsp; arabic_bread 4 pc; seven_spice 1 tsp; almonds 40 g; salt 1.5 tsp",
  ["تبّل {chicken_whole} مقطعاً بـ {seven_spice} ونصف {sumac} ونصف {salt}، واشوه في الفرن على 200 درجة 45 دقيقة.",
   "قطّع {onion} شرائح واطبخها على نار هادئة في {olive_oil} 20 دقيقة حتى تذبل، وأضف باقي السماق والملح.",
   "افرد البصل على {arabic_bread} وضع فوقه الدجاج.",
   "أدخلها الفرن 8 دقائق، وزيّنها بـ {almonds}."])

R("malfouf", "محشي ملفوف", "🥬", "l", "levant", 100, "",
  "cabbage 1 pc; rice 1.5 cup; minced_beef 400 g; garlic 8 pc; lemon 2 pc; seven_spice 2 tsp; tomato 2 pc; veg_oil 2 tbsp; salt 2 tsp",
  ["افصل أوراق {cabbage} واسلقها 5 دقائق حتى تطرى، واقطعها نصفين.",
   "اخلط {rice} المغسول مع {minced_beef} و{seven_spice} ونصف {salt} و{tomato} مفرومة و{veg_oil}.",
   "لفّ كل ورقة بملعقة من الحشوة كالأصبع، ورتّبها في قدر بين فصوص {garlic}.",
   "أضف ماء يغطيها وباقي الملح، واطبخها على نار هادئة 50 دقيقة.",
   "أضف عصير {lemon} آخر 10 دقائق."])

R("spinach_meat", "سبانخ باللحم مع رز", "🥬", "l", "levant egyptian", 60, "",
  "spinach 800 g; beef_cubes 400 g; onion 1 pc; garlic 4 pc; coriander 1 pc; lemon 1 pc; veg_oil 2 tbsp; salt 1 tsp; black_pepper 0.5 tsp; rice 2 cup",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، وأضف ماء واتركه 35 دقيقة.",
   "أضف {spinach} واتركها 10 دقائق.",
   "حمّر {garlic} مع {coriander} وأضفها للسبانخ مع {salt} و{black_pepper} وعصير {lemon}.",
   "قدّمها مع {rice} أبيض."])

R("white_beans_stew", "فاصوليا بيضاء بالصلصة مع رز", "🫘", "l", "levant egyptian", 45, "",
  "white_beans 2 pc; beef_cubes 400 g; onion 1 pc; garlic 3 pc; tomato_paste 3 tbsp; crushed_tomatoes 1 pc; seven_spice 1 tsp; coriander 1 pc; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup",
  ["حمّر {beef_cubes} مع {onion} في {veg_oil}، وأضف ماء واتركه 30 دقيقة.",
   "أضف {white_beans} و{tomato_paste} و{crushed_tomatoes} و{seven_spice} و{salt}.",
   "حمّر {garlic} مع {coriander} وأضفها، واطبخها 10 دقائق.",
   "قدّمها مع {rice}."])

R("freekeh_soup", "شوربة فريكة بالدجاج", "🍲", "d", "levant saudi", 45, "",
  "freekeh 150 g; chicken_breast 300 g; onion 1 pc; carrot 1 pc; butter 1 tbsp; stock_cube 1 pc; seven_spice 1 tsp; lemon 1 pc; salt 1 tsp",
  ["حمّر {onion} في {butter}، ثم أضف {chicken_breast} مكعبات صغيرة.",
   "أضف {freekeh} المغسولة و{carrot} مبشوراً و{seven_spice}.",
   "أضف 8 أكواب ماء مع {stock_cube} و{salt}، واتركها 35 دقيقة.",
   "قدّمها مع {lemon}."])

R("dawood_basha", "داوود باشا (كرات لحم بالصلصة)", "🧆", "l", "levant", 50, "",
  "minced_beef 600 g; onion 2 pc; crushed_tomatoes 2 pc; tomato_paste 1 tbsp; garlic 2 pc; seven_spice 2 tsp; parsley 1 pc; veg_oil 3 tbsp; salt 1.5 tsp; rice 2 cup",
  ["اخلط {minced_beef} مع {parsley} مفرومة ونصف {seven_spice} ونصف {salt}، وشكّلها كرات صغيرة.",
   "حمّر الكرات في {veg_oil} وارفعها.",
   "حمّر {onion} شرائح في نفس الزيت، ثم {garlic} و{tomato_paste} و{crushed_tomatoes} وباقي البهار والملح.",
   "أرجع الكرات للصلصة واتركها 20 دقيقة، وقدّمها مع {rice}."])

R("fatteh_chicken", "فتة دجاج", "🍗", "l", "levant egyptian", 60, "",
  "chicken_breast 600 g; rice 2 cup; arabic_bread 3 pc; yogurt 500 g; garlic 4 pc; vinegar 2 tbsp; butter 2 tbsp; almonds 40 g; stock_cube 1 pc; salt 1.5 tsp",
  ["اسلق {chicken_breast} مع {stock_cube} في 5 أكواب ماء 20 دقيقة، وقطّعه.",
   "اطبخ {rice} في 3.5 أكواب من المرق مع نصف {salt}.",
   "حمّص {arabic_bread} مقطعاً وبلّله بقليل من المرق و{vinegar}.",
   "اخلط {yogurt} مع {garlic} مهروساً وباقي الملح.",
   "رتّب الخبز ثم الرز ثم الدجاج ثم اللبن، وزيّنها بـ {almonds} محمّرة في {butter}."])

R("adas_hamod", "عدس بحامض", "🍋", "l d", "levant healthy", 45, "",
  "brown_lentils 300 g; potato 2 pc; spinach 300 g; onion 1 pc; garlic 5 pc; coriander 1 pc; lemon 3 pc; flour 2 tbsp; olive_oil 4 tbsp; salt 1.5 tsp; arabic_bread 4 pc",
  ["اسلق {brown_lentils} في 6 أكواب ماء 20 دقيقة.",
   "أضف {potato} مكعبات و{spinach} واتركها 15 دقيقة.",
   "حمّر {onion} و{garlic} و{coriander} في {olive_oil}، وأضفها للعدس.",
   "اخلط {flour} مع عصير {lemon} وأضفه مع {salt} حتى يتكاثف قليلاً.",
   "قدّمه مع {arabic_bread}."])

R("bulgur_tomato", "برغل بالبندورة مع لبن", "🍅", "l d", "levant healthy", 30, "",
  "bulgur 300 g; tomato 4 pc; onion 1 pc; bell_pepper 1 pc; tomato_paste 1 tbsp; olive_oil 4 tbsp; cumin 1 tsp; salt 1 tsp; yogurt 400 g; cucumber 2 pc",
  ["حمّر {onion} و{bell_pepper} في {olive_oil}.",
   "أضف {tomato} مبشورة و{tomato_paste} و{cumin} و{salt} واتركها 5 دقائق.",
   "أضف {bulgur} و2.5 كوب ماء، وغطّه على نار هادئة 15 دقيقة.",
   "قدّمه مع {yogurt} و{cucumber}."])

R("falafel", "فلافل بالقلاية الهوائية", "🧆", "d", "levant egyptian", 40, "air_fryer blender",
  "chickpeas_dry 300 g; onion 1 pc; garlic 4 pc; parsley 1 pc; coriander 1 pc; cumin 2 tsp; baking_powder 1 tsp; salt 1.5 tsp; veg_oil 2 tbsp; tahini 4 tbsp; lemon 1 pc; arabic_bread 4 pc; tomato 2 pc",
  ["انقع {chickpeas_dry} في الماء من الليلة السابقة (12 ساعة) وصفّه.",
   "اطحنه بالخلاط مع {onion} و{garlic} و{parsley} و{coriander} و{cumin} و{salt} حتى يصير خشناً متماسكاً.",
   "أضف {baking_powder} وشكّله أقراصاً، وادهنها بـ {veg_oil}.",
   "اشوها في القلاية الهوائية على 200 درجة 15 دقيقة مع التقليب.",
   "قدّمها في {arabic_bread} مع {tomato} وطحينة: {tahini} مع عصير {lemon} وماء."])

R("shakriyeh", "شاكرية (لحم باللبن)", "🥛", "l", "levant", 80, "",
  "beef_cubes 700 g; yogurt 800 g; onion 1 pc; garlic 3 pc; flour 1 tbsp; eggs 1 pc; cardamom 4 pc; cinnamon 1 pc; butter 1 tbsp; salt 1.5 tsp; rice 2 cup",
  ["اسلق {beef_cubes} مع {onion} و{cardamom} و{cinnamon} في ماء يغطيه 60 دقيقة.",
   "اخفق {yogurt} مع {flour} و{eggs}، وسخّنه مع التحريك المستمر حتى يغلي.",
   "أضف اللحم وكوباً من مرقه للبن و{salt}، واتركه 10 دقائق.",
   "حمّر {garlic} في {butter} وأضفه، وقدّمها مع {rice}."])

# ======================================================== egyptian
R("chicken_pane", "دجاج بانيه مع رز بالشعيرية", "🍗", "l d", "egyptian", 45, "",
  "chicken_breast 700 g; eggs 2 pc; breadcrumbs 150 g; flour 4 tbsp; garlic 2 pc; lemon 1 pc; veg_oil 6 tbsp; rice 2 cup; vermicelli 60 g; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["افرد {chicken_breast} رقيقاً وتبّله بـ {garlic} وعصير {lemon} ونصف {salt} و{black_pepper}.",
   "مرّره على {flour} ثم {eggs} المخفوق ثم {breadcrumbs}.",
   "اقلِه في {veg_oil} 3 دقائق لكل جهة.",
   "حمّر {vermicelli} في قليل من الزيت، وأضف {rice} و3.5 أكواب ماء وباقي الملح واطبخه 20 دقيقة."])

R("hawawshi", "حواوشي بالفرن", "🥙", "d", "egyptian", 35, "oven",
  "arabic_bread 4 pc; minced_beef 500 g; onion 1 pc; bell_pepper 1 pc; green_chili 1 pc; parsley 1 pc; seven_spice 1 tsp; paprika 1 tsp; veg_oil 2 tbsp; salt 1 tsp; tahini 3 tbsp; lemon 1 pc",
  ["اخلط {minced_beef} مع {onion} و{bell_pepper} و{green_chili} و{parsley} مفرومة و{seven_spice} و{paprika} و{salt}.",
   "افتح {arabic_bread} واحشه بطبقة رقيقة من اللحم.",
   "ادهنه بـ {veg_oil} واخبزه على 200 درجة 15 دقيقة مع التقليب.",
   "قدّمه مع طحينة: {tahini} مع عصير {lemon} وماء."])

R("fish_tagine", "طاجن سمك بالطماطم", "🐟", "l d", "egyptian levant", 45, "oven",
  "fish_fillet 800 g; tomato 4 pc; bell_pepper 1 pc; onion 1 pc; garlic 4 pc; cumin 1.5 tsp; lemon 1 pc; olive_oil 3 tbsp; coriander 1 pc; salt 1.5 tsp; rice 2 cup",
  ["تبّل {fish_fillet} بنصف {cumin} ونصف {salt} وعصير {lemon}.",
   "حمّر {onion} و{bell_pepper} و{garlic} في {olive_oil}، وأضف {tomato} وباقي الكمون والملح 5 دقائق.",
   "افرد الصلصة في صينية وضع السمك فوقها، واخبزها على 200 درجة 20 دقيقة.",
   "زيّنها بـ {coriander} وقدّمها مع {rice}."])

R("zucchini_bechamel", "كوسا بالبشاميل", "🥒", "l", "egyptian", 60, "oven",
  "zucchini 1000 g; minced_beef 400 g; onion 1 pc; milk 600 ml; butter 3 tbsp; flour 4 tbsp; nutmeg 0.25 tsp; mozzarella 100 g; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["قطّع {zucchini} شرائح طولية وحمّرها قليلاً في مقلاة أو في الفرن.",
   "حمّر {onion} و{minced_beef} مع نصف {salt} و{black_pepper}.",
   "البشاميل: ذوّب {butter}، أضف {flour}، ثم {milk} تدريجياً حتى يتكاثف، مع {nutmeg} وباقي الملح.",
   "رتّب طبقة كوسا ثم اللحم ثم كوسا، واسكب البشاميل ثم {mozzarella}.",
   "اخبزها على 200 درجة 25 دقيقة."])

# ======================================================== italian
R("lasagna_beef", "لازانيا باللحم", "🍝", "l", "italian", 80, "oven",
  "lasagna 300 g; minced_beef 500 g; onion 1 pc; garlic 3 pc; crushed_tomatoes 2 pc; oregano 1 tsp; milk 700 ml; butter 3 tbsp; flour 4 tbsp; mozzarella 200 g; salt 1.5 tsp",
  ["حمّر {onion} و{garlic} و{minced_beef}، وأضف {crushed_tomatoes} و{oregano} ونصف {salt}، واتركها 15 دقيقة.",
   "البشاميل: ذوّب {butter}، أضف {flour}، ثم {milk} حتى يتكاثف، وباقي الملح.",
   "رتّب في صينية: صلصة، {lasagna}، بشاميل، وكرر 3 مرات.",
   "انهِ ببشاميل و{mozzarella}، واخبزها مغطاة على 190 درجة 30 دقيقة، ثم مكشوفة 10 دقائق."])

R("shrimp_pasta", "باستا بالروبيان والثوم", "🍤", "l d", "italian", 25, "",
  "spaghetti 500 g; shrimp 500 g; garlic 6 pc; olive_oil 4 tbsp; chili_flakes 0.5 tsp; lemon 1 pc; parsley 1 pc; butter 1 tbsp; salt 1 tsp",
  ["اسلق {spaghetti}.",
   "حمّر {garlic} شرائح في {olive_oil} مع {chili_flakes}.",
   "أضف {shrimp} و{salt} وقلّبه 4 دقائق.",
   "أضف الباستا و{butter} وعصير {lemon} و{parsley} مع قليل من ماء السلق."])

R("minestrone", "شوربة مينستروني بالخضار", "🥣", "d", "italian healthy", 40, "",
  "pasta 100 g; white_beans 1 pc; carrot 2 pc; zucchini 1 pc; potato 1 pc; onion 1 pc; crushed_tomatoes 1 pc; garlic 2 pc; olive_oil 2 tbsp; oregano 1 tsp; stock_cube 1 pc; salt 1 tsp",
  ["حمّر {onion} و{garlic} و{carrot} في {olive_oil}.",
   "أضف {potato} و{zucchini} مكعبات و{crushed_tomatoes} و{oregano}، ثم 7 أكواب ماء مع {stock_cube} و{salt}.",
   "اتركها 20 دقيقة، ثم أضف {pasta} و{white_beans} واطبخها 10 دقائق."])

R("chicken_parm", "دجاج بارميجانا", "🧀", "l d", "italian", 45, "oven",
  "chicken_breast 700 g; breadcrumbs 120 g; eggs 2 pc; crushed_tomatoes 1 pc; mozzarella 200 g; oregano 1 tsp; olive_oil 3 tbsp; garlic 2 pc; salt 1.5 tsp; spaghetti 400 g",
  ["افرد {chicken_breast} وتبّله بنصف {salt}، ومرّره على {eggs} ثم {breadcrumbs}.",
   "حمّره في {olive_oil} دقيقتين لكل جهة، وضعه في صينية.",
   "اطبخ {crushed_tomatoes} مع {garlic} و{oregano} وباقي الملح 10 دقائق.",
   "اسكب الصلصة على الدجاج ثم {mozzarella}، واخبزه على 200 درجة 15 دقيقة.",
   "قدّمه مع {spaghetti} مسلوقة."])

# ======================================================== asian
R("sweet_sour_chicken", "دجاج حلو وحامض", "🍍", "l d", "asian", 35, "",
  "chicken_breast 700 g; flour 4 tbsp; eggs 1 pc; bell_pepper 2 pc; onion 1 pc; vinegar 4 tbsp; sugar 4 tbsp; ketchup 4 tbsp; soy_sauce 2 tbsp; veg_oil 5 tbsp; rice 2 cup",
  ["قطّع {chicken_breast} مكعبات، واغمسها في {eggs} ثم {flour}.",
   "اقلها في {veg_oil} حتى تتحمّر وارفعها.",
   "قلّب {bell_pepper} و{onion} في المقلاة دقيقتين.",
   "أضف {vinegar} و{sugar} و{ketchup} و{soy_sauce} ونصف كوب ماء حتى تتكاثف، ثم الدجاج.",
   "قدّمه مع {rice}."])

R("beef_broccoli", "لحم بالبروكلي والصويا", "🥦", "l d", "asian", 35, "",
  "beef_cubes 500 g; broccoli 400 g; garlic 4 pc; ginger 1 tsp; soy_sauce 5 tbsp; honey 1 tbsp; flour 1 tbsp; veg_oil 3 tbsp; sesame 1 tbsp; rice 2 cup",
  ["قطّع {beef_cubes} شرائح رفيعة جداً وغلّفها بـ {flour}.",
   "حمّرها في {veg_oil} على نار عالية وارفعها.",
   "قلّب {broccoli} مع {garlic} و{ginger} 3 دقائق.",
   "أرجع اللحم وأضف {soy_sauce} و{honey} وربع كوب ماء حتى تتكاثف.",
   "رشّ {sesame} وقدّمه مع {rice}."])

R("shrimp_fried_rice", "رز مقلي بالروبيان", "🍤", "l d", "asian", 25, "",
  "rice 2 cup; shrimp 400 g; eggs 3 pc; peas_carrots 300 g; onion 1 pc; garlic 3 pc; soy_sauce 4 tbsp; veg_oil 3 tbsp",
  ["اطبخ {rice} واتركه يبرد.",
   "قلّب {shrimp} في {veg_oil} 3 دقائق وارفعه.",
   "حمّر {onion} و{garlic} و{peas_carrots}، ثم اخفق {eggs} في المقلاة.",
   "أضف الرز والروبيان و{soy_sauce} وقلّب على نار عالية."])

R("noodle_soup", "شوربة نودلز بالدجاج", "🍜", "d", "asian", 30, "",
  "noodles 250 g; chicken_breast 300 g; carrot 2 pc; onion 1 pc; garlic 3 pc; ginger 1 tsp; soy_sauce 3 tbsp; stock_cube 1 pc; coriander 1 pc; veg_oil 1 tbsp",
  ["حمّر {onion} و{garlic} و{ginger} في {veg_oil}.",
   "أضف {chicken_breast} شرائح و{carrot} شرائح رفيعة.",
   "أضف 7 أكواب ماء مع {stock_cube} و{soy_sauce} واتركها 12 دقيقة.",
   "أضف {noodles} 4 دقائق، وزيّنها بـ {coriander}."])

R("almond_chicken", "دجاج باللوز والخضار", "🥢", "l d", "asian", 30, "",
  "chicken_breast 600 g; almonds 80 g; zucchini 1 pc; carrot 1 pc; bell_pepper 1 pc; garlic 3 pc; soy_sauce 4 tbsp; honey 1 tbsp; flour 1 tbsp; veg_oil 3 tbsp; rice 2 cup",
  ["حمّص {almonds} في مقلاة جافة وارفعه.",
   "قطّع {chicken_breast} مكعبات وغلّفه بـ {flour}، وحمّره في {veg_oil}.",
   "أضف {zucchini} و{carrot} و{bell_pepper} و{garlic} 4 دقائق.",
   "أضف {soy_sauce} و{honey} وربع كوب ماء، ثم اللوز.",
   "قدّمه مع {rice}."])

# ======================================================== indian
R("butter_chicken", "دجاج بالزبدة (بتر تشكن)", "🍛", "l d", "indian", 50, "",
  "chicken_thigh 800 g; yogurt 150 g; crushed_tomatoes 2 pc; cream 200 ml; butter 3 tbsp; onion 1 pc; garlic 4 pc; ginger 1 tsp; curry 2 tbsp; sugar 1 tsp; salt 1.5 tsp; rice 2 cup",
  ["تبّل {chicken_thigh} مكعبات بـ {yogurt} ونصف {curry} ونصف {salt} 20 دقيقة.",
   "حمّر الدجاج في نصف {butter} وارفعه.",
   "حمّر {onion} و{garlic} و{ginger} في باقي الزبدة، ثم باقي الكاري و{crushed_tomatoes} و{sugar} وباقي الملح 15 دقيقة.",
   "أضف {cream} والدجاج واتركه 10 دقائق.",
   "قدّمه مع {rice}."])

R("chana_masala", "كاري حمص (تشانا ماسالا)", "🍛", "l d", "indian healthy", 35, "",
  "chickpeas_can 2 pc; onion 1 pc; tomato 3 pc; garlic 3 pc; ginger 1 tsp; curry 1.5 tbsp; cumin 1 tsp; veg_oil 3 tbsp; lemon 1 pc; coriander 1 pc; salt 1 tsp; rice 2 cup",
  ["حمّر {onion} في {veg_oil}، ثم {garlic} و{ginger} و{curry} و{cumin}.",
   "أضف {tomato} مقطعة و{salt} واتركها 8 دقائق.",
   "أضف {chickpeas_can} وكوب ماء واتركه 15 دقيقة.",
   "أضف عصير {lemon} و{coriander}، وقدّمه مع {rice}."])

R("keema", "كيما (لحم مفروم بالبازلاء)", "🍛", "l d", "indian", 35, "",
  "minced_beef 500 g; peas_carrots 400 g; onion 1 pc; tomato 2 pc; garlic 3 pc; ginger 1 tsp; curry 1.5 tbsp; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup; yogurt 200 g",
  ["حمّر {onion} في {veg_oil}، ثم {garlic} و{ginger} و{curry}.",
   "أضف {minced_beef} وقلّبه حتى يتحمّر.",
   "أضف {tomato} و{peas_carrots} و{salt} ونصف كوب ماء واتركه 15 دقيقة.",
   "قدّمه مع {rice} و{yogurt}."])

R("spinach_halloumi_curry", "سبانخ بالكاري مع حلوم", "🥬", "l d", "indian healthy", 30, "blender",
  "spinach 800 g; halloumi 250 g; onion 1 pc; garlic 3 pc; ginger 1 tsp; curry 1 tbsp; cream 100 ml; veg_oil 2 tbsp; salt 0.5 tsp; rice 2 cup",
  ["حمّر {onion} و{garlic} و{ginger} و{curry} في {veg_oil}.",
   "أضف {spinach} وقليلاً من الماء 8 دقائق، ثم اخلطها بالخلاط حتى تنعم.",
   "أضف {cream} و{salt}.",
   "حمّر {halloumi} مكعبات وأضفه فوق السبانخ، وقدّمه مع {rice}."])

# ======================================================== mexican
R("chili_con_carne", "تشيلي كون كارني", "🌶️", "l d", "mexican", 50, "",
  "minced_beef 500 g; kidney_beans 2 pc; onion 1 pc; bell_pepper 1 pc; garlic 3 pc; crushed_tomatoes 2 pc; paprika 2 tsp; cumin 2 tsp; chili_flakes 0.5 tsp; veg_oil 2 tbsp; salt 1.5 tsp; rice 2 cup",
  ["حمّر {onion} و{bell_pepper} في {veg_oil}، ثم {minced_beef} و{garlic}.",
   "أضف {paprika} و{cumin} و{chili_flakes} و{crushed_tomatoes} و{salt}.",
   "أضف {kidney_beans} واتركه على نار هادئة 30 دقيقة.",
   "قدّمه مع {rice}."])

R("chicken_fajita", "فاهيتا دجاج", "🫑", "d", "mexican", 30, "",
  "chicken_breast 600 g; bell_pepper 3 pc; onion 2 pc; tortilla 8 pc; paprika 2 tsp; cumin 1 tsp; garlic 2 pc; lemon 1 pc; veg_oil 2 tbsp; salt 1 tsp; yogurt 200 g",
  ["قطّع {chicken_breast} شرائح وتبّلها بـ {paprika} و{cumin} و{garlic} وعصير {lemon} و{salt}.",
   "حمّرها في {veg_oil} على نار عالية وارفعها.",
   "قلّب {bell_pepper} و{onion} شرائح 4 دقائق، وأرجع الدجاج.",
   "قدّمها في {tortilla} مع {yogurt}."])

R("mexican_salad", "سلطة مكسيكية بالدجاج والذرة", "🥗", "d", "mexican healthy", 25, "",
  "chicken_breast 400 g; kidney_beans 1 pc; corn_can 1 pc; lettuce 1 pc; tomato 2 pc; avocado 1 pc; lemon 2 pc; olive_oil 3 tbsp; paprika 1 tsp; cumin 1 tsp; salt 1 tsp",
  ["تبّل {chicken_breast} بـ {paprika} و{cumin} ونصف {salt}، واشوه في مقلاة وقطّعه.",
   "قطّع {lettuce} و{tomato} و{avocado}.",
   "أضف {kidney_beans} و{corn_can} مصفّاة.",
   "اخفق عصير {lemon} مع {olive_oil} وباقي الملح، واخلط الكل."])

R("mexican_rice", "رز مكسيكي بالفاصوليا والخضار", "🍚", "l d", "mexican healthy", 35, "",
  "rice 2 cup; kidney_beans 1 pc; corn_can 1 pc; bell_pepper 1 pc; onion 1 pc; tomato_paste 2 tbsp; garlic 2 pc; paprika 1 tsp; cumin 1 tsp; veg_oil 2 tbsp; salt 1.5 tsp; lemon 1 pc",
  ["حمّر {onion} و{bell_pepper} و{garlic} في {veg_oil}.",
   "أضف {rice} و{tomato_paste} و{paprika} و{cumin} وقلّب دقيقتين.",
   "أضف 3.5 أكواب ماء و{salt}، واطبخه 18 دقيقة.",
   "أضف {kidney_beans} و{corn_can} وعصير {lemon} وقلّب."])

# ======================================================== western
R("beef_burger", "برجر لحم بالبيت", "🍔", "d", "western", 35, "",
  "minced_beef 600 g; burger_buns 4 pc; cheddar 4 pc; lettuce 0.5 pc; tomato 2 pc; onion 1 pc; ketchup 3 tbsp; mayo 2 tbsp; potato 4 pc; veg_oil 2 tbsp; salt 1.5 tsp; black_pepper 0.5 tsp",
  ["اقسم {minced_beef} إلى 4 أقراص وتبّلها بنصف {salt} و{black_pepper}.",
   "قطّع {potato} أصابع واشوها أو اقلها بـ {veg_oil} وباقي الملح.",
   "اشوِ الأقراص في مقلاة ساخنة 4 دقائق لكل جهة، وضع {cheddar} آخر دقيقة.",
   "حمّص {burger_buns} وركّب البرجر مع {lettuce} و{tomato} و{onion} و{ketchup} و{mayo}."])

R("crispy_chicken_burger", "برجر دجاج مقرمش", "🍔", "d", "western", 40, "air_fryer",
  "chicken_breast 600 g; breadcrumbs 120 g; eggs 2 pc; burger_buns 4 pc; lettuce 0.5 pc; tomato 1 pc; mayo 3 tbsp; paprika 1 tsp; garlic 1 pc; salt 1 tsp; veg_oil 1 tbsp",
  ["اقسم {chicken_breast} إلى 4 قطع مسطحة، وتبّلها بـ {paprika} و{garlic} و{salt}.",
   "مرّرها على {eggs} ثم {breadcrumbs}، وادهنها بـ {veg_oil}.",
   "اشوها في القلاية الهوائية على 200 درجة 14 دقيقة مع التقليب.",
   "ركّب البرجر في {burger_buns} مع {mayo} و{lettuce} و{tomato}."])

R("honey_wings", "أجنحة دجاج بالعسل والثوم", "🍗", "d", "western asian", 40, "air_fryer",
  "chicken_wings 1000 g; honey 4 tbsp; garlic 5 pc; soy_sauce 3 tbsp; paprika 1 tsp; salt 1 tsp; potato 4 pc; veg_oil 2 tbsp",
  ["تبّل {chicken_wings} بـ {paprika} و{salt}.",
   "اشوها في القلاية الهوائية على 200 درجة 22 دقيقة مع التقليب.",
   "سخّن {honey} مع {garlic} مهروساً و{soy_sauce} دقيقتين، واخلطها مع الأجنحة.",
   "قدّمها مع {potato} مشوية بـ {veg_oil}."])

R("stuffed_potato", "بطاطس محشية بالفرن", "🥔", "d", "western", 60, "oven",
  "potato 4 pc; minced_beef 300 g; onion 1 pc; cheddar 4 pc; cream_cheese 100 g; butter 1 tbsp; paprika 1 tsp; salt 1 tsp; lettuce 0.5 pc",
  ["اخبز {potato} كاملة على 200 درجة 45 دقيقة حتى تطرى.",
   "حمّر {onion} و{minced_beef} مع {paprika} و{salt}.",
   "افتح البطاطس وافرغ نصف داخلها، واهرسه مع {cream_cheese} و{butter}.",
   "أرجع الهريس واللحم داخلها وضع {cheddar} فوقها، واخبزها 8 دقائق.",
   "قدّمها مع {lettuce}."])

R("roast_chicken", "دجاج مشوي كامل مع خضار", "🍗", "l d", "western healthy", 90, "oven",
  "chicken_whole 1 pc; potato 4 pc; carrot 3 pc; onion 2 pc; lemon 1 pc; garlic 6 pc; olive_oil 4 tbsp; paprika 1 tsp; oregano 1 tsp; salt 2 tsp",
  ["ادهن {chicken_whole} بـ {olive_oil} و{paprika} و{oregano} و{salt} و{garlic}، وضع {lemon} مقطعاً داخله.",
   "قطّع {potato} و{carrot} و{onion} ورتبها حوله في الصينية.",
   "اشوه على 200 درجة 75 دقيقة حتى يتحمّر وتنضج الخضار."])

R("chicken_vermicelli_soup", "شوربة دجاج بالشعيرية", "🍲", "d", "saudi western", 30, "",
  "chicken_breast 300 g; vermicelli 100 g; carrot 2 pc; onion 1 pc; stock_cube 1 pc; butter 1 tbsp; lemon 1 pc; parsley 1 pc; salt 1 tsp; black_pepper 0.25 tsp",
  ["حمّر {onion} في {butter}، ثم {chicken_breast} مكعبات صغيرة.",
   "أضف {carrot} مكعبات و7 أكواب ماء مع {stock_cube} و{salt} و{black_pepper}، واتركها 15 دقيقة.",
   "أضف {vermicelli} واطبخها 5 دقائق.",
   "قدّمها مع {parsley} و{lemon}."])

R("quinoa_salad", "سلطة كينوا بالحمص", "🥗", "d", "healthy levant", 25, "",
  "quinoa 200 g; chickpeas_can 1 pc; cucumber 2 pc; tomato 2 pc; parsley 1 pc; mint 1 pc; lemon 2 pc; olive_oil 4 tbsp; pom_molasses 1 tbsp; salt 1 tsp; feta 100 g",
  ["اغسل {quinoa} واطبخها في كوبين ماء 15 دقيقة، ثم بردها.",
   "قطّع {cucumber} و{tomato}، وافرم {parsley} و{mint}.",
   "أضف {chickpeas_can} المصفى.",
   "اخفق عصير {lemon} مع {olive_oil} و{pom_molasses} و{salt}، واخلط الكل مع {feta}."])

R("coconut_lentil_curry", "عدس بالكاري وجوز الهند", "🥥", "l d", "indian healthy", 35, "",
  "red_lentils 300 g; coconut_milk 1 pc; onion 1 pc; garlic 3 pc; ginger 1 tsp; curry 1.5 tbsp; tomato 2 pc; spinach 200 g; veg_oil 2 tbsp; salt 1 tsp; rice 2 cup",
  ["حمّر {onion} و{garlic} و{ginger} و{curry} في {veg_oil}.",
   "أضف {red_lentils} و{tomato} و{coconut_milk} وكوبين ماء و{salt}.",
   "اطبخه 20 دقيقة حتى ينضج العدس، ثم أضف {spinach} 5 دقائق.",
   "قدّمه مع {rice}."])

R("mushroom_soup", "شوربة كريمة الفطر", "🍄", "d", "western", 30, "blender",
  "mushroom 500 g; onion 1 pc; garlic 2 pc; butter 2 tbsp; flour 2 tbsp; cream 200 ml; stock_cube 1 pc; salt 0.75 tsp; black_pepper 0.25 tsp; toast 8 pc",
  ["حمّر {onion} و{garlic} و{mushroom} في {butter} 8 دقائق.",
   "أضف {flour} وقلّب دقيقة، ثم 5 أكواب ماء مع {stock_cube}.",
   "اتركها 12 دقيقة، ثم اخلطها بالخلاط.",
   "أضف {cream} و{salt} و{black_pepper}، وقدّمها مع {toast} محمّص."])

R("caesar_salad", "سلطة سيزر بالدجاج", "🥗", "d", "western healthy", 25, "",
  "chicken_breast 500 g; lettuce 1 pc; toast 4 pc; mayo 4 tbsp; lemon 1 pc; garlic 1 pc; cheddar 3 pc; olive_oil 2 tbsp; salt 0.75 tsp; black_pepper 0.25 tsp",
  ["تبّل {chicken_breast} بنصف {salt} و{black_pepper} واشوه في {olive_oil}، ثم قطّعه.",
   "قطّع {toast} مكعبات وحمّصها حتى تقرمش.",
   "للصلصة: اخلط {mayo} مع عصير {lemon} و{garlic} مهروساً وباقي الملح.",
   "اخلط {lettuce} مع الصلصة والدجاج والخبز و{cheddar} مقطعاً."])

R("meat_sambosa", "سمبوسة لحم", "🔺", "d", "saudi", 40, "air_fryer",
  "sambosa_sheets 20 pc; minced_beef 400 g; onion 2 pc; parsley 1 pc; seven_spice 1 tsp; salt 1 tsp; veg_oil 2 tbsp; lemon 1 pc; tomato 2 pc; cucumber 1 pc",
  ["حمّر {onion} مفروماً ثم {minced_beef} مع {seven_spice} و{salt} حتى ينشف، وأضف {parsley}.",
   "احشُ {sambosa_sheets} واطوها مثلثات.",
   "ادهنها بـ {veg_oil} واشوها في القلاية الهوائية على 190 درجة 12 دقيقة.",
   "قدّمها مع {lemon} وسلطة {tomato} و{cucumber}."])

R("chicken_rice_bowl", "بول دجاج وأرز وخضار", "🍱", "l d", "healthy asian", 30, "",
  "chicken_breast 600 g; rice 1.5 cup; broccoli 400 g; carrot 2 pc; avocado 1 pc; soy_sauce 3 tbsp; honey 1 tbsp; sesame 1 tbsp; garlic 2 pc; veg_oil 1 tbsp",
  ["اطبخ {rice}.",
   "قطّع {chicken_breast} وحمّره في {veg_oil} مع {garlic}، ثم أضف {soy_sauce} و{honey}.",
   "اسلق {broccoli} على البخار وابشر {carrot}.",
   "وزّع الرز في أطباق مع الدجاج والخضار و{avocado} شرائح، ورشّ {sesame}."])

R("tuna_potato_salad", "سلطة بطاطس بالتونة", "🥔", "d", "healthy levant", 30, "",
  "potato 5 pc; tuna_can 2 pc; parsley 1 pc; onion 0.5 pc; lemon 2 pc; olive_oil 4 tbsp; cumin 0.5 tsp; salt 1 tsp; olives 60 g",
  ["اسلق {potato} 20 دقيقة وقطّعه مكعبات.",
   "أضف {tuna_can} و{parsley} و{onion} مفرومة و{olives}.",
   "اخفق عصير {lemon} مع {olive_oil} و{cumin} و{salt} واسكبه فوقها."])

R("eggplant_fatteh", "فتة باذنجان", "🍆", "d", "levant", 40, "oven",
  "eggplant 2 pc; arabic_bread 2 pc; yogurt 500 g; tahini 3 tbsp; garlic 2 pc; minced_beef 250 g; almonds 30 g; veg_oil 4 tbsp; seven_spice 1 tsp; salt 1 tsp",
  ["قطّع {eggplant} مكعبات، وادهنه بـ {veg_oil} واشوه في الفرن 25 دقيقة.",
   "حمّص {arabic_bread} مقطعاً.",
   "حمّر {minced_beef} مع {seven_spice} ونصف {salt}، ثم {almonds}.",
   "اخلط {yogurt} مع {tahini} و{garlic} وباقي الملح.",
   "رتّب الخبز ثم الباذنجان ثم اللبن ثم اللحم واللوز."])

# ------------------------------------------------------------- keeps well
# Dishes that are fine (or better) on the second day from the fridge.
# Everything else is "eat fresh": fried, crispy, salads, eggs, sandwiches,
# fish and seafood, creamy pasta.
KEEP = {
    # v1
    "kabsa_chicken", "kabsa_lamb", "mandi_chicken", "maqluba", "jareesh",
    "saudi_macaroni", "madhghout", "saloona_chicken", "bamia_meat",
    "lentil_soup", "oat_soup", "marqooq", "kofta_tahini", "mujaddara",
    "freekeh_chicken", "kousa_mahshi", "peas_stew", "musaqaa", "koshari",
    "molokhia_chicken", "bechamel_pasta", "green_beans_meat", "potato_tagine",
    "bolognese", "tomato_soup", "soy_chicken", "coconut_curry", "biryani",
    "dal", "aloo_gobi", "veg_soup", "lentil_rice_stew",
    # v2
    "bukhari_chicken", "haneeth", "marqa_meat", "red_rice_chicken", "harees",
    "chicken_veg_rice", "kibbeh_tray", "malfouf", "spinach_meat",
    "white_beans_stew", "freekeh_soup", "dawood_basha", "adas_hamod",
    "bulgur_tomato", "shakriyeh", "zucchini_bechamel", "lasagna_beef",
    "minestrone", "butter_chicken", "chana_masala", "keema",
    "chili_con_carne", "mexican_rice", "roast_chicken",
    "coconut_lentil_curry", "chicken_vermicelli_soup",
    # v3 Egyptian & healthy
    "mahshi_mix", "warak_enab", "cabbage_mahshi_eg", "stuffed_peppers_meat",
    "bamia_chicken", "peas_chicken", "chicken_potato_tray", "zucchini_sauce",
    "qolqas", "lobia", "adas_abu_gebba", "roz_khalta", "kofta_tray_eg",
    "kofta_rice", "kebab_halla", "koshari_alex", "lesan_asfour_soup",
    "lentil_vermicelli_soup", "besara", "pasta_oven_veg",
    "macarona_bechamel_chicken", "lasagna_eg_veg", "potato_tagine_veg",
    "okra_veg", "green_beans_veg", "rice_veg_chicken_one_pot",
    "bamia_oven_meat", "moussaka_bechamel_eg", "fasolia_beef_eg",
    "molokhia_beef", "stuffed_eggplant_white", "chicken_meatballs_oven",
    "veg_coconut_curry", "tomato_lentil_soup", "broccoli_soup",
    "quinoa_stuffed_peppers", "lentil_salad", "roz_moammar",
}
