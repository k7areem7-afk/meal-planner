# -*- coding: utf-8 -*-
"""Healthy recipes: high protein, low carb, high fiber, vegan options."""
from recipes import R
from recipes_eg import V

R("lentil_salad", "سلطة عدس بالخضار", "🥗", "l d", "healthy egyptian", 30, "",
  "brown_lentils 250 g; cucumber 2 pc; tomato 2 pc; onion 0.5 pc; parsley 1 pc; lemon 2 pc; olive_oil 4 tbsp; cumin 1 tsp; salt 1 tsp",
  ["اسلق {brown_lentils} في ماء 20 دقيقة لحد ما يستوي ويفضل متماسك، وصفّيه وسيبه يبرد.",
   "قطّع {cucumber} و{tomato} و{onion} صغير، وافرم {parsley}.",
   "اخفق عصير {lemon} مع {olive_oil} و{cumin} و{salt}.",
   "اخلط الكل."])

R("zaatar_chicken_quinoa", "صدور فراخ بالزعتر مع كينوا", "🍗", "l d", "healthy levant", 30, "",
  "chicken_breast 700 g; quinoa 200 g; zaatar 2 tbsp; lemon 1 pc; garlic 2 pc; olive_oil 3 tbsp; cucumber 1 pc; tomato 2 pc; salt 1.5 tsp",
  ["اغسل {quinoa} واطبخها في كوبايتين ماء بنص {salt} 15 دقيقة.",
   "تبّل {chicken_breast} بـ {zaatar} و{garlic} وعصير {lemon} و{olive_oil} وباقي الملح.",
   "اشويها في طاسة جريل 6 دقائق كل جهة.",
   "قدّمها مع الكينوا و{cucumber} و{tomato}."])

R("grilled_fish_veg", "سمك مشوي بالليمون مع خضار سوتيه", "🐟", "l d", "healthy", 25, "",
  "fish_fillet 700 g; lemon 2 pc; garlic 3 pc; zucchini 2 pc; bell_pepper 1 pc; broccoli 300 g; olive_oil 3 tbsp; paprika 1 tsp; salt 1.5 tsp",
  ["تبّل {fish_fillet} بـ {paprika} و{garlic} وعصير نص {lemon} ونص {salt}.",
   "اشويه في طاسة بملعقة {olive_oil} 4 دقائق كل جهة.",
   "شوّح {zucchini} و{bell_pepper} و{broccoli} في باقي الزيت 6 دقائق مع باقي الملح.",
   "قدّمه مع الليمونة التانية."])
V("grilled_fish_veg", "fresh")

R("tuna_quinoa_bowl", "بول تونة بالكينوا والأفوكادو", "🥑", "l d", "healthy", 25, "",
  "quinoa 200 g; tuna_can 2 pc; avocado 1 pc; cucumber 1 pc; corn_can 0.5 pc; lemon 1 pc; olive_oil 2 tbsp; salt 0.75 tsp",
  ["اطبخ {quinoa} في كوبايتين ماء 15 دقيقة.",
   "قطّع {avocado} و{cucumber}.",
   "وزّع الكينوا في أطباق وفوقها {tuna_can} و{corn_can} والخضار.",
   "صبّ عصير {lemon} مع {olive_oil} و{salt}."])

R("yogurt_chicken_salad", "سلطة فراخ بالزبادي", "🥗", "d", "healthy", 25, "",
  "chicken_breast 500 g; yogurt 250 g; cucumber 1 pc; apple 1 pc; lettuce 1 pc; lemon 1 pc; mint 0.5 pc; salt 1 tsp; black_pepper 0.25 tsp",
  ["اسلق {chicken_breast} في ماء بملح 15 دقيقة وقطّعه مكعبات.",
   "اخلط {yogurt} مع عصير {lemon} و{mint} و{salt} و{black_pepper}.",
   "قطّع {cucumber} و{apple} مكعبات صغيرة.",
   "اخلط الكل وقدّمه على {lettuce}."])

R("chicken_meatballs_oven", "كرات فراخ بالفرن مع صلصة طماطم", "🍅", "l d", "healthy italian", 35, "oven",
  "minced_chicken 600 g; onion 1 pc; parsley 1 pc; oats 40 g; eggs 1 pc; crushed_tomatoes 2 pc; garlic 2 pc; oregano 1 tsp; olive_oil 1 tbsp; salt 1.5 tsp; zucchini 2 pc",
  ["اخلط {minced_chicken} مع {onion} مبشور و{parsley} و{oats} و{eggs} ونص {salt}، واعمل كور.",
   "رصّها في صينية واخبزها على 200 درجة 15 دقيقة.",
   "سخّن {crushed_tomatoes} مع {garlic} و{oregano} و{olive_oil} وباقي الملح 10 دقائق.",
   "صبّ الصلصة على الكور، وقدّمها مع {zucchini} مشوية."])

R("oat_omelette", "أومليت شوفان بالخضار", "🥣", "b", "healthy", 12, "",
  "eggs 6 pc; oats 60 g; milk 100 ml; spinach 150 g; tomato 1 pc; olive_oil 1 tbsp; salt 0.5 tsp",
  ["اخلط {oats} مع {milk} وسيبه 5 دقائق.",
   "اخفق {eggs} مع الشوفان و{salt}.",
   "شوّح {spinach} و{tomato} في {olive_oil} دقيقتين وصبّ البيض فوقهم.",
   "غطّي الطاسة على نار هادية 5 دقائق."])
V("oat_omelette", "one_pan")

R("egg_white_omelette", "أومليت بياض البيض بالخضار", "🍳", "b", "healthy", 10, "",
  "eggs 8 pc; bell_pepper 1 pc; mushroom 100 g; spinach 100 g; olive_oil 1 tbsp; salt 0.5 tsp; black_pepper 0.25 tsp; toast 4 pc",
  ["افصل بياض {eggs} عن الصفار (الصفار استخدمه في وصفة تانية).",
   "شوّح {bell_pepper} و{mushroom} و{spinach} في {olive_oil} 3 دقائق.",
   "اخفق البياض مع {salt} و{black_pepper} وصبّه، وغطّيه دقيقتين.",
   "قدّمه مع {toast} أسمر لو متاح."])
V("egg_white_omelette", "one_pan fresh")

R("chickpea_salad", "سلطة حمص بالخضار", "🥗", "d", "healthy levant", 10, "",
  "chickpeas_can 2 pc; cucumber 2 pc; tomato 2 pc; bell_pepper 1 pc; parsley 1 pc; lemon 2 pc; olive_oil 3 tbsp; cumin 0.5 tsp; salt 0.75 tsp",
  ["صفّي {chickpeas_can} واشطفه.",
   "قطّع {cucumber} و{tomato} و{bell_pepper} مكعبات وافرم {parsley}.",
   "صبّ عصير {lemon} مع {olive_oil} و{cumin} و{salt} واخلط."])

R("broccoli_soup", "شوربة بروكلي خفيفة", "🥦", "d", "healthy", 25, "blender",
  "broccoli 600 g; potato 1 pc; onion 1 pc; garlic 2 pc; olive_oil 1 tbsp; stock_cube 1 pc; milk 200 ml; salt 0.75 tsp; black_pepper 0.25 tsp",
  ["شوّح {onion} و{garlic} في {olive_oil} 3 دقائق.",
   "أضف {broccoli} و{potato} مكعبات و5 كوبايات ماء مع {stock_cube}، وسيبها 15 دقيقة.",
   "اضربها في الخلاط وأضف {milk} و{salt} و{black_pepper}."])

R("garlic_chicken_broccoli", "صدور فراخ بالبروكلي والثوم في طاسة", "🥦", "l d", "healthy asian", 20, "",
  "chicken_breast 600 g; broccoli 400 g; garlic 4 pc; soy_sauce 2 tbsp; lemon 1 pc; olive_oil 2 tbsp; ginger 0.5 tsp; sesame 1 tbsp",
  ["قطّع {chicken_breast} مكعبات وحمّرها في {olive_oil} 6 دقائق.",
   "أضف {broccoli} ونص كوباية ماء وغطّيها 4 دقائق.",
   "أضف {garlic} و{ginger} و{soy_sauce} وعصير {lemon} دقيقة.",
   "رشّ {sesame}."])
V("garlic_chicken_broccoli", "one_pan fresh")

R("lettuce_tacos", "تاكو خس بالفراخ (كيتو)", "🥬", "d", "healthy mexican", 20, "",
  "minced_chicken 500 g; lettuce 1 pc; tomato 2 pc; avocado 1 pc; onion 0.5 pc; paprika 1 tsp; cumin 1 tsp; lemon 1 pc; olive_oil 1 tbsp; salt 1 tsp",
  ["شوّح {minced_chicken} في {olive_oil} مع {onion} و{paprika} و{cumin} و{salt} 8 دقائق.",
   "افصل أوراق {lettuce} الكبيرة واستخدمها بدل العيش.",
   "قطّع {tomato} و{avocado}.",
   "احشي الخس بالفراخ والخضار واعصر {lemon}."])
V("lettuce_tacos", "one_pan fresh")

R("spinach_mushroom_eggs", "بيض بالسبانخ والمشروم (كيتو)", "🍄", "b d", "healthy", 12, "",
  "eggs 6 pc; spinach 200 g; mushroom 200 g; butter 1 tbsp; feta 80 g; garlic 1 pc; black_pepper 0.25 tsp",
  ["شوّح {mushroom} و{garlic} في {butter} 4 دقائق.",
   "أضف {spinach} دقيقتين.",
   "اكسر {eggs} فوقهم وفتّت {feta}، وغطّيه 3 دقائق.",
   "رشّ {black_pepper}."])
V("spinach_mushroom_eggs", "one_pan")

R("greek_salad", "سلطة يوناني", "🥗", "d", "healthy", 10, "",
  "cucumber 2 pc; tomato 3 pc; bell_pepper 1 pc; onion 0.5 pc; feta 150 g; olives 80 g; olive_oil 3 tbsp; oregano 1 tsp; lemon 1 pc",
  ["قطّع {cucumber} و{tomato} و{bell_pepper} و{onion} قطع كبيرة.",
   "أضف {olives} و{feta} مكعبات.",
   "صبّ {olive_oil} وعصير {lemon} ورشّ {oregano}."])

R("turmeric_cauliflower", "قرنبيط مشوي بالكركم مع حمص", "🥦", "l d", "healthy indian", 35, "oven",
  "cauliflower 1 pc; chickpeas_can 1 pc; turmeric 1 tsp; cumin 1 tsp; paprika 1 tsp; olive_oil 3 tbsp; lemon 1 pc; tahini 3 tbsp; salt 1 tsp",
  ["قطّع {cauliflower} زهرات واخلطها مع {chickpeas_can} المصفى و{turmeric} و{cumin} و{paprika} و{olive_oil} و{salt}.",
   "افردهم في صينية واشويهم على 220 درجة 25 دقيقة.",
   "اخفق {tahini} مع عصير {lemon} وماء وصبّها عليهم."])

R("veg_coconut_curry", "كاري خضار بحليب جوز الهند (نباتي)", "🥥", "l d", "healthy asian indian", 30, "",
  "coconut_milk 1 pc; potato 2 pc; carrot 2 pc; broccoli 300 g; chickpeas_can 1 pc; onion 1 pc; garlic 3 pc; curry 1.5 tbsp; ginger 1 tsp; veg_oil 1 tbsp; salt 1 tsp; rice 1.5 cup",
  ["اطبخ {rice}.",
   "شوّح {onion} و{garlic} و{ginger} و{curry} في {veg_oil} دقيقتين.",
   "أضف {potato} و{carrot} مكعبات و{coconut_milk} ونص كوباية ماء و{salt}، وسيبها 15 دقيقة.",
   "أضف {broccoli} و{chickpeas_can} 5 دقائق، وقدّمه مع الرز."])

R("tomato_lentil_soup", "شوربة طماطم بالعدس", "🍅", "d", "healthy", 30, "blender",
  "red_lentils 150 g; tomato 4 pc; crushed_tomatoes 1 pc; onion 1 pc; garlic 2 pc; carrot 1 pc; olive_oil 1 tbsp; cumin 1 tsp; stock_cube 1 pc; salt 1 tsp",
  ["شوّح {onion} و{garlic} و{carrot} في {olive_oil}.",
   "أضف {red_lentils} و{tomato} و{crushed_tomatoes} و{cumin} و6 كوبايات ماء مع {stock_cube}، وسيبها 20 دقيقة.",
   "اضربها في الخلاط وأضف {salt}."])

R("quinoa_stuffed_peppers", "فلفل محشي كينوا وفاصوليا (نباتي)", "🫑", "l d", "healthy mexican", 45, "oven",
  "bell_pepper 4 pc; quinoa 150 g; kidney_beans 1 pc; corn_can 0.5 pc; tomato 2 pc; onion 0.5 pc; cumin 1 tsp; paprika 1 tsp; olive_oil 1 tbsp; salt 1 tsp",
  ["اطبخ {quinoa} 15 دقيقة.",
   "اخلطها مع {kidney_beans} و{corn_can} و{tomato} و{onion} مفرومين و{cumin} و{paprika} و{salt} و{olive_oil}.",
   "افتح {bell_pepper} واحشيه.",
   "اخبزه على 200 درجة 25 دقيقة."])

R("turmeric_yogurt_chicken", "فراخ بالزبادي والكركم مشوية", "🍗", "l d", "healthy indian", 35, "oven",
  "chicken_thigh 800 g; yogurt 200 g; turmeric 1 tsp; garlic 3 pc; ginger 1 tsp; lemon 1 pc; cumin 1 tsp; salt 1.5 tsp; cucumber 2 pc; tomato 2 pc",
  ["اخلط {yogurt} مع {turmeric} و{garlic} و{ginger} وعصير {lemon} و{cumin} و{salt}.",
   "تبّل {chicken_thigh} بالخلطة 30 دقيقة على الأقل.",
   "اشويها في الفرن على 210 درجة 25 دقيقة.",
   "قدّمها مع سلطة {cucumber} و{tomato}."])

R("quinoa_tabbouleh", "تبولة كينوا", "🌿", "d", "healthy levant", 20, "",
  "quinoa 150 g; parsley 3 pc; mint 1 pc; tomato 3 pc; onion 0.5 pc; lemon 3 pc; olive_oil 5 tbsp; salt 1 tsp",
  ["اطبخ {quinoa} 15 دقيقة وسيبها تبرد.",
   "افرم {parsley} و{mint} ناعم، وقطّع {tomato} و{onion} صغير.",
   "اخلط الكل مع عصير {lemon} و{olive_oil} و{salt}."])

R("sweet_potato_chicken", "بطاطا حلوة بالقلاية مع صدور فراخ", "🍠", "l d", "healthy", 30, "air_fryer",
  "sweet_potato 3 pc; chicken_breast 600 g; paprika 2 tsp; garlic 2 pc; olive_oil 2 tbsp; salt 1.5 tsp; black_pepper 0.5 tsp; lettuce 0.5 pc",
  ["قطّع {sweet_potato} أصابع واخلطها بنص {olive_oil} ونص {salt}.",
   "تبّل {chicken_breast} بـ {paprika} و{garlic} و{black_pepper} وباقي الزيت والملح.",
   "اشوي البطاطا 15 دقيقة ثم الفراخ 14 دقيقة في القلاية على 200 درجة.",
   "قدّمها مع {lettuce}."])

R("chicken_kofta_yogurt", "كفتة فراخ مشوية بالزبادي", "🍢", "l d", "healthy levant", 25, "air_fryer",
  "minced_chicken 600 g; onion 1 pc; parsley 1 pc; seven_spice 1.5 tsp; salt 1 tsp; yogurt 300 g; cucumber 2 pc; mint 0.5 pc; garlic 1 pc",
  ["اخلط {minced_chicken} مع {onion} مبشور ومعصور و{parsley} و{seven_spice} و{salt}، وشكّلها أصابع.",
   "اشويها في القلاية على 200 درجة 12 دقيقة.",
   "اعمل زبادي بالخيار: {yogurt} مع {cucumber} مبشور و{mint} و{garlic}.",
   "قدّمهم سوا."])

R("herb_fish_oven", "سمك فيليه بالفرن بالأعشاب", "🐟", "l d", "healthy", 25, "oven",
  "fish_fillet 700 g; parsley 1 pc; dill 1 pc; garlic 3 pc; lemon 2 pc; olive_oil 3 tbsp; salt 1 tsp; potato 3 pc",
  ["قطّع {potato} شرايح رفيعة واشويها 10 دقائق بنص {olive_oil}.",
   "افرم {parsley} و{dill} و{garlic} واخلطهم مع باقي الزيت وعصير نص {lemon} و{salt}.",
   "حط {fish_fillet} فوق البطاطس وادهنه بالخلطة.",
   "اخبزه على 200 درجة 15 دقيقة، وقدّمه بالليمونة التانية."])

R("roasted_veg_feta", "صينية خضار مشوية بزيت الزيتون والفيتا", "🥕", "l d", "healthy", 40, "oven",
  "zucchini 2 pc; eggplant 1 pc; bell_pepper 2 pc; carrot 2 pc; onion 1 pc; chickpeas_can 1 pc; feta 150 g; olive_oil 4 tbsp; oregano 1 tsp; salt 1 tsp",
  ["قطّع {zucchini} و{eggplant} و{bell_pepper} و{carrot} و{onion} قطع كبيرة.",
   "اخلطهم مع {chickpeas_can} و{olive_oil} و{oregano} و{salt}.",
   "اشويهم على 220 درجة 30 دقيقة.",
   "فتّت {feta} فوقهم."])

R("boiled_eggs_salad", "بيض مسلوق مع سلطة خضرا", "🥗", "b d", "healthy", 15, "",
  "eggs 8 pc; lettuce 1 pc; cucumber 2 pc; tomato 2 pc; olive_oil 2 tbsp; lemon 1 pc; salt 0.5 tsp",
  ["اسلق {eggs} 9 دقائق، وحطه في مية ساقعة وقشّره.",
   "قطّع {lettuce} و{cucumber} و{tomato}.",
   "صبّ {olive_oil} وعصير {lemon} و{salt}، وقدّم البيض مع السلطة."])
V("boiled_eggs_salad", "fresh")

R("protein_yogurt_bowl", "بول زبادي بروتين بالشوفان والفول السوداني", "🥣", "b", "healthy", 5, "",
  "yogurt 600 g; oats 80 g; peanut_butter 3 tbsp; banana 2 pc; honey 1 tbsp",
  ["وزّع {yogurt} في 4 أطباق.",
   "أضف {oats} و{banana} شرايح.",
   "صبّ {peanut_butter} و{honey} على الوش."])

R("cottage_veg_bowl", "قريش بالخضار وزيت الزيتون", "🥗", "b d", "healthy egyptian", 5, "",
  "cottage 400 g; cucumber 2 pc; tomato 2 pc; bell_pepper 1 pc; olive_oil 2 tbsp; zaatar 1 tbsp; black_pepper 0.25 tsp",
  ["قطّع {cucumber} و{tomato} و{bell_pepper} مكعبات.",
   "اخلطهم مع {cottage} و{black_pepper}.",
   "صبّ {olive_oil} ورشّ {zaatar}."])

R("shrimp_zucchini_noodles", "جمبري مع شرائط كوسة (لو كارب)", "🦐", "d", "healthy", 15, "",
  "shrimp 500 g; zucchini 4 pc; garlic 4 pc; lemon 1 pc; olive_oil 2 tbsp; chili_flakes 0.25 tsp; parsley 0.5 pc; salt 1 tsp",
  ["قطّع {zucchini} شرائط رفيعة طويلة بالمقشرة.",
   "شوّح {shrimp} مع {garlic} و{chili_flakes} في {olive_oil} 3 دقائق.",
   "أضف الكوسة و{salt} دقيقتين بس.",
   "اعصر {lemon} وزيّنه بـ {parsley}."])
V("shrimp_zucchini_noodles", "one_pan fresh")
