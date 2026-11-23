# -*- coding: utf-8 -*-
"""Desserts, drinks and side salads (original recipes).

COURSE: what a recipe can be served as next to a meal.
Recipes with no meal slot ("") only appear as sides.
"""
from recipes import R
from recipes_eg import V

COURSE = {}


def C(ids, course):
    for i in ids.split():
        COURSE.setdefault(i, set()).update(course.split())


# ======================================================== desserts
R("tiramisu", "تيراميسو", "☕", "", "italian", 30, "",
  "ladyfingers 200 g; instant_coffee 2 tbsp; cream_cheese 200 g; whipping_cream 250 ml; sugar 5 tbsp; cocoa 2 tbsp; vanilla 1 pc",
  ["ذوّب {instant_coffee} في كوب ماء سخن واتركه يبرد.",
   "اخفق {whipping_cream} بارد جداً بالمضرب لحد ما يتماسك، ثم أضف {cream_cheese} و{sugar} و{vanilla} واخفق دقيقة.",
   "اغمس {ladyfingers} في القهوة ثانية واحدة بس لكل جهة (لا تخليه يتشرب كثير) ورصّه في صحن.",
   "افرد نص الكريمة، ثم طبقة بسكويت ثانية، ثم باقي الكريمة.",
   "غطّه وحطه في الثلاجة 4 ساعات على الأقل، ورشّ {cocoa} قبل التقديم."])
C("tiramisu", "dessert")

R("creme_caramel", "كريم كراميل", "🍮", "", "egyptian western", 60, "oven",
  "milk 500 ml; eggs 4 pc; sugar 10 tbsp; vanilla 1 pc",
  ["الكراميل: سخّن نص {sugar} في حلة على نار متوسطة بدون تقليب لحد ما يذوب ويصير لونه عسلي، وصبّه بسرعة في قالب أو أكواب.",
   "اخفق {eggs} مع باقي السكر و{vanilla}، ثم أضف {milk} دافي وقلّب.",
   "صفّ الخليط فوق الكراميل.",
   "حط القالب في صينية فيها ماء سخن (حمام مائي) واخبزه على 160 درجة 40 دقيقة لحد ما يتماسك.",
   "برّده في الثلاجة 4 ساعات، ثم مرّر سكينة حول الأطراف واقلبه في صحن."])
C("creme_caramel", "dessert")

R("mahalabia", "مهلبية", "🥛", "", "egyptian levant", 20, "",
  "milk 1000 ml; cornstarch 6 tbsp; sugar 6 tbsp; vanilla 1 pc; pistachio 30 g",
  ["ذوّب {cornstarch} في كوب من {milk} البارد.",
   "سخّن باقي الحليب مع {sugar}، وقبل ما يغلي أضف النشا وأنت تقلّب باستمرار.",
   "استمر في التقليب على نار متوسطة 5 دقائق لحد ما يتقل، ثم أضف {vanilla}.",
   "صبّها في أكواب وبرّدها ساعتين، وزيّنها بـ {pistachio} مجروش."])
C("mahalabia", "dessert")
C("roz_bel_laban bread_pudding_om_ali", "dessert")

R("basbousa", "بسبوسة", "🟨", "", "egyptian", 50, "oven",
  "semolina 300 g; yogurt 200 g; sugar 12 tbsp; butter 100 g; coconut 50 g; baking_powder 1 tsp; lemon 0.5 pc; almonds 30 g",
  ["الشربات: اغلي 8 ملاعق من {sugar} مع كوب ماء 10 دقائق، وأضف عصير {lemon} واتركه يبرد.",
   "اخلط {semolina} مع {coconut} وباقي السكر و{baking_powder}، ثم {butter} مذابة و{yogurt}.",
   "افرد الخليط في صينية مدهونة، وقطّعها مربعات، وحط {almonds} على كل قطعة.",
   "اخبزها على 180 درجة 30 دقيقة لحد ما يحمر الوش.",
   "صبّ الشربات البارد على البسبوسة السخنة واتركها تتشرب."])
C("basbousa", "dessert")

R("kunafa_cream", "كنافة بالقشطة", "🧶", "", "egyptian levant", 60, "oven",
  "kunafa 500 g; butter 150 g; milk 500 ml; cream 200 ml; cornstarch 4 tbsp; sugar 12 tbsp; lemon 0.5 pc; pistachio 30 g",
  ["الشربات: اغلي 8 ملاعق من {sugar} مع كوب ماء 10 دقائق وأضف عصير {lemon}، واتركه يبرد.",
   "القشطة: سخّن {milk} مع {cream} وباقي السكر، وأضف {cornstarch} مذوب في شوية حليب بارد، وقلّب لحد ما يتقل.",
   "فكّك {kunafa} بإيدك واخلطها مع {butter} مذابة كويس.",
   "نص الكنافة في صينية واضغطها، ثم القشطة، ثم باقي الكنافة.",
   "اخبزها على 200 درجة 35 دقيقة لحد ما تحمر، وصبّ الشربات البارد عليها، وزيّنها بـ {pistachio}."])
C("kunafa_cream", "dessert")

R("kunafa_cheese", "كنافة بالجبنة سريعة", "🧀", "", "levant", 40, "oven",
  "kunafa 400 g; butter 120 g; mozzarella 300 g; sugar 8 tbsp; lemon 0.5 pc; pistachio 20 g",
  ["الشربات: اغلي {sugar} مع نص كوب ماء 8 دقائق، وأضف عصير {lemon}.",
   "اخلط {kunafa} المفككة مع {butter} مذابة.",
   "نص الكنافة في صينية، ثم {mozzarella}، ثم الباقي واضغطها.",
   "اخبزها على 200 درجة 25 دقيقة، وصبّ الشربات وزيّنها بـ {pistachio}. تتاكل سخنة."])
C("kunafa_cheese", "dessert")

R("biscuit_cream_cups", "كاسات بسكويت بالكريمة", "🍪", "", "western", 15, "",
  "tea_biscuits 200 g; whipping_cream 250 ml; condensed_milk 0.5 pc; cocoa 1 tbsp; milk 100 ml",
  ["اخفق {whipping_cream} بارد مع {condensed_milk} لحد ما يتماسك.",
   "اكسر {tea_biscuits} قطع، وبلّلها بـ {milk}.",
   "في كاسات: طبقة بسكويت ثم كريمة، وكرر.",
   "رشّ {cocoa} وحطها في الثلاجة ساعة."])
C("biscuit_cream_cups", "dessert")

R("cheesecake_cups", "تشيز كيك بارد بالكاسات", "🍰", "", "western", 20, "",
  "tea_biscuits 150 g; butter 60 g; cream_cheese 200 g; whipping_cream 250 ml; sugar 4 tbsp; strawberry 250 g; vanilla 1 pc",
  ["اطحن {tea_biscuits} واخلطها مع {butter} مذابة، ووزعها في قاع الكاسات واضغطها.",
   "اخفق {whipping_cream} لحد ما يتماسك، وأضف {cream_cheese} و{sugar} و{vanilla}.",
   "وزّع الكريمة فوق البسكويت.",
   "قطّع {strawberry} وحطها فوق، وبرّدها ساعتين."])
C("cheesecake_cups", "dessert")

R("chocolate_biscuit_cake", "كيكة البسكويت بالشوكولاتة (بدون فرن)", "🍫", "", "western egyptian", 20, "",
  "tea_biscuits 300 g; cocoa 4 tbsp; sugar 6 tbsp; butter 100 g; milk 200 ml; dark_chocolate 100 g",
  ["سخّن {milk} مع {cocoa} و{sugar} و{butter} وقلّب لحد ما يذوب ويغلي دقيقة.",
   "اكسر {tea_biscuits} وأضفها للصوص وقلّب.",
   "اكبس الخليط في قالب مبطّن بورق زبدة.",
   "ذوّب {dark_chocolate} وصبّها على الوش، وبرّدها في الثلاجة 3 ساعات."])
C("chocolate_biscuit_cake", "dessert")

R("chocolate_mousse", "موس الشوكولاتة", "🍫", "", "western", 15, "",
  "dark_chocolate 200 g; whipping_cream 250 ml; sugar 2 tbsp; milk 50 ml",
  ["ذوّب {dark_chocolate} مع {milk} في المايكرويف (30 ثانية وقلّب) أو على حمام مائي، واتركها تبرد شوي.",
   "اخفق {whipping_cream} مع {sugar} لحد ما يتماسك.",
   "اخلط الشوكولاتة مع الكريمة بالراحة بالملعقة (حركة من تحت لفوق).",
   "وزّعها في أكواب وبرّدها ساعتين."])
C("chocolate_mousse", "dessert")

R("chocolate_pudding", "بودينغ شوكولاتة", "🍫", "", "western", 15, "",
  "milk 750 ml; cocoa 4 tbsp; cornstarch 5 tbsp; sugar 6 tbsp; vanilla 1 pc; butter 1 tbsp",
  ["اخلط {cocoa} و{cornstarch} و{sugar} في حلة، وأضف {milk} بارد شوية شوية مع الخفق عشان ما يتكتل.",
   "سخّنه على نار متوسطة مع التقليب المستمر لحد ما يتقل (7 دقائق).",
   "أضف {butter} و{vanilla}.",
   "صبّه في أكواب وبرّده."])
C("chocolate_pudding", "dessert")

R("mug_cake", "كيكة المج بالمايكرويف", "☕", "", "western", 5, "microwave",
  "flour 4 tbsp; cocoa 2 tbsp; sugar 3 tbsp; milk 3 tbsp; veg_oil 2 tbsp; eggs 1 pc; baking_powder 0.25 tsp",
  ["في مج كبير، اخلط {flour} و{cocoa} و{sugar} و{baking_powder}.",
   "أضف {eggs} و{milk} و{veg_oil} واخلط بالشوكة لحد ما ينعم.",
   "حطه في المايكرويف 90 ثانية على أعلى درجة. لا تملا المج أكثر من النص.",
   "اتركه دقيقة يبرد وكُله بالملعقة."],
  servings=1)
C("mug_cake", "dessert")

R("fruit_salad_cream", "سلطة فواكه بالقشطة", "🍓", "", "healthy egyptian", 10, "",
  "banana 2 pc; apple 2 pc; orange 2 pc; strawberry 200 g; whipping_cream 150 ml; condensed_milk 0.25 pc",
  ["قطّع {banana} و{apple} و{orange} و{strawberry} مكعبات.",
   "اخفق {whipping_cream} مع {condensed_milk}.",
   "وزّع الفواكه في أكواب وحط الكريمة فوقها."])
C("fruit_salad_cream", "dessert")

R("luqaimat", "لقيمات", "🟤", "", "saudi", 60, "",
  "flour 300 g; cornstarch 2 tbsp; yeast 1 pc; sugar 1 tbsp; veg_oil 700 ml; date_syrup 6 tbsp; sesame 1 tbsp; salt 0.25 tsp",
  ["اخلط {flour} و{cornstarch} و{yeast} و{sugar} و{salt}، وأضف ماء دافي تدريجياً لحد ما تصير عجينة سائلة لزجة.",
   "غطّها واتركها في مكان دافي ساعة لحد ما تتضاعف وتطلع فقاعات.",
   "سخّن {veg_oil} على نار متوسطة. خذ العجين بيدك واعصره من بين الإبهام والسبابة، واقطعه بملعقة مبلولة في الزيت.",
   "قلّبها لحد ما تحمر من كل الجهات (4 دقائق)، وطلّعها على مناديل.",
   "صبّ {date_syrup} ورشّ {sesame}."])
C("luqaimat", "dessert")
V("luqaimat", "family")

R("mango_cream_cups", "كاسات مانجو بالكريمة", "🥭", "", "western", 15, "",
  "mango 2 pc; whipping_cream 250 ml; condensed_milk 0.5 pc; tea_biscuits 100 g",
  ["قشّر {mango} وقطّع نصها مكعبات واهرس النص الثاني.",
   "اخفق {whipping_cream} مع {condensed_milk}.",
   "في كاسات: {tea_biscuits} مكسّر، ثم كريمة، ثم مانجو مهروسة، ثم مكعبات المانجو.",
   "برّدها ساعة."])
C("mango_cream_cups", "dessert")

R("aish_saraya", "عيش السرايا", "🍞", "", "egyptian levant", 35, "",
  "toast 10 pc; sugar 10 tbsp; milk 500 ml; cornstarch 4 tbsp; cream 200 ml; lemon 0.5 pc; pistachio 30 g",
  ["قشّر أطراف {toast} وحمّصه في الفرن ورصّه في صينية.",
   "الكراميل: سخّن 6 ملاعق من {sugar} لحد ما تصير عسلية، وأضف نص كوب ماء وعصير {lemon} بحذر (هيفور) وقلّب.",
   "صبّ الكراميل على العيش.",
   "القشطة: {milk} مع {cream} وباقي السكر و{cornstarch} على النار مع التقليب لحد ما تتقل، وافردها فوق.",
   "زيّنها بـ {pistachio} وبرّدها 3 ساعات."])
C("aish_saraya", "dessert")

R("date_balls", "كرات التمر بالشوفان", "🌴", "", "healthy saudi", 15, "blender",
  "dates 20 pc; oats 80 g; almonds 40 g; coconut 30 g; cocoa 1 tbsp",
  ["انزع نوى {dates}.",
   "اطحن {oats} و{almonds} في الخلاط، وأضف التمر و{cocoa} واطحن لحد ما يتماسك.",
   "شكّلها كرات صغيرة، ودحرجها في {coconut}.",
   "برّدها نص ساعة."])
C("date_balls", "dessert")

R("fruit_jelly", "جيلي بالفواكه", "🟥", "", "western", 15, "",
  "jelly_powder 2 pc; strawberry 150 g; banana 1 pc",
  ["ذوّب {jelly_powder} في كوبين ماء مغلي وقلّب دقيقتين، ثم أضف كوبين ماء بارد.",
   "قطّع {strawberry} و{banana} ووزعها في أكواب.",
   "صبّ الجيلي فوقها، وبرّدها في الثلاجة 3 ساعات لحد ما يتماسك."])
C("fruit_jelly", "dessert")

R("custard_fruit", "كاسترد بالفواكه", "🍮", "", "western egyptian", 15, "",
  "custard_powder 4 tbsp; milk 750 ml; sugar 4 tbsp; banana 2 pc; strawberry 100 g",
  ["ذوّب {custard_powder} و{sugar} في كوب من {milk} البارد.",
   "سخّن باقي الحليب وأضف الخليط مع التقليب لحد ما يتقل.",
   "قطّع {banana} و{strawberry} في أكواب وصبّ الكاسترد فوقها.",
   "يتاكل دافي أو بارد."])
C("custard_fruit", "dessert")

R("trifle", "ترايفل", "🍰", "", "western", 30, "",
  "custard_powder 3 tbsp; milk 500 ml; sugar 3 tbsp; jelly_powder 1 pc; tea_biscuits 150 g; whipping_cream 200 ml; banana 1 pc; strawberry 100 g",
  ["حضّر {jelly_powder} بكوب ماء مغلي وكوب بارد، وبرّده لحد ما يتماسك شوي.",
   "حضّر الكاسترد: {custard_powder} و{sugar} مع {milk} على النار حتى يتقل.",
   "في وعاء: {tea_biscuits} ثم {banana} و{strawberry} ثم الجيلي ثم الكاسترد.",
   "اخفق {whipping_cream} وحطها على الوش، وبرّده 3 ساعات."])
C("trifle", "dessert")

R("banana_icecream", "آيس كريم موز بالخلاط", "🍌", "", "healthy", 10, "blender",
  "banana 4 pc; peanut_butter 2 tbsp; cocoa 1 tbsp; milk 50 ml",
  ["قطّع {banana} حلقات وجمّدها في الفريزر من الليلة اللي قبلها.",
   "اخلط الموز المجمد مع {peanut_butter} و{cocoa} و{milk} في الخلاط لحد ما يصير كريمي.",
   "قدّمه على طول، أو جمّده ساعة لو تبيه أقسى."])
C("banana_icecream", "dessert")

R("nutella_crepe", "كريب بالنوتيلا والموز", "🥞", "", "western", 25, "",
  "flour 150 g; milk 350 ml; eggs 2 pc; butter 2 tbsp; sugar 1 tbsp; nutella 6 tbsp; banana 2 pc",
  ["اخفق {flour} و{milk} و{eggs} و{sugar} وملعقة {butter} مذابة لحد ما يصير سائل ناعم.",
   "سخّن طاسة غير لاصقة بشوية زبدة، وصبّ نص مغرفة ولفّ الطاسة عشان ينفرد رقيق.",
   "اقلبه بعد دقيقة لما الأطراف تتحرك.",
   "افرد {nutella} وشرائح {banana} واطويه."])
C("nutella_crepe", "dessert")

R("tamriya", "تمرية بالسميد", "🌴", "", "saudi", 20, "",
  "dates 20 pc; semolina 150 g; butter 80 g; cardamom 3 pc; sesame 1 tbsp",
  ["حمّص {semolina} في {butter} على نار هادية مع التقليب لحد ما يصير لونه ذهبي (8 دقائق).",
   "أضف {dates} منزوع النوى و{cardamom} مطحون، واهرسه مع السميد لحد ما يتجانس.",
   "افرده في صحن ورشّ {sesame}، وقطّعه."])
C("tamriya", "dessert")

R("chocolate_salami", "سلامي الشوكولاتة", "🍫", "", "western", 15, "",
  "tea_biscuits 250 g; cocoa 4 tbsp; butter 100 g; condensed_milk 0.5 pc; pistachio 50 g",
  ["ذوّب {butter} وأضف {cocoa} و{condensed_milk} وقلّب.",
   "اكسر {tea_biscuits} قطع صغيرة وأضفها مع {pistachio}.",
   "شكّل الخليط أسطوانة على ورق زبدة ولفّه بإحكام.",
   "حطه في الفريزر ساعتين، وقطّعه حلقات."])
C("chocolate_salami", "dessert")

R("orange_cake", "كيكة البرتقال", "🍊", "", "western", 50, "oven",
  "flour 250 g; eggs 3 pc; sugar 10 tbsp; orange 2 pc; veg_oil 120 ml; baking_powder 2 tsp; vanilla 1 pc",
  ["سخّن الفرن على 180 درجة وادهن قالب.",
   "اخفق {eggs} مع {sugar} 5 دقائق لحد ما يفتح لونه.",
   "أضف {veg_oil} وعصير {orange} وبشر قشرها و{vanilla}.",
   "أضف {flour} مع {baking_powder} بالتدريج وقلّب بالراحة.",
   "اخبزها 35 دقيقة لحد ما تدخل عود خشب ويطلع نظيف."])
C("orange_cake", "dessert")
V("orange_cake", "family")

R("icecream_chocolate_sauce", "آيس كريم بصوص الشوكولاتة", "🍨", "", "western", 5, "",
  "ice_cream 500 ml; dark_chocolate 80 g; cream 60 ml; pistachio 20 g",
  ["ذوّب {dark_chocolate} مع {cream} في المايكرويف 30 ثانية وقلّب.",
   "وزّع {ice_cream} في أكواب.",
   "صبّ الصوص وزيّنه بـ {pistachio}."])
C("icecream_chocolate_sauce", "dessert")

R("dates_tahini", "تمر بالطحينة", "🌴", "", "saudi levant", 3, "",
  "dates 16 pc; tahini 4 tbsp; sesame 1 tsp",
  ["افتح {dates} وانزع النوى.",
   "احشي كل تمرة بشوية {tahini}.",
   "رشّ {sesame}."])
C("dates_tahini", "dessert")

R("honey_yogurt_nuts", "زبادي بالعسل والمكسرات", "🍯", "", "healthy", 3, "",
  "yogurt 500 g; honey 4 tbsp; almonds 40 g; pistachio 20 g",
  ["وزّع {yogurt} في أكواب.",
   "صبّ {honey} فوقه.",
   "رشّ {almonds} و{pistachio} مجروشين."])
C("honey_yogurt_nuts", "dessert")

R("sahlab", "سحلب", "🥛", "", "egyptian levant", 15, "",
  "milk 1000 ml; cornstarch 4 tbsp; sugar 5 tbsp; vanilla 1 pc; coconut 20 g; cinnamon 0.5 tsp; pistachio 20 g",
  ["ذوّب {cornstarch} في كوب من {milk} البارد.",
   "سخّن باقي الحليب مع {sugar}، وأضف النشا مع التقليب لحد ما يتقل شوي.",
   "أضف {vanilla} وصبّه في أكواب.",
   "رشّ {coconut} و{cinnamon} و{pistachio}. يتشرب سخن."])
C("sahlab", "dessert drink")

# ======================================================== drinks
R("lemon_mint", "ليمون بالنعناع", "🍋", "", "saudi egyptian", 5, "blender",
  "lemon 3 pc; mint 1 pc; sugar 6 tbsp",
  ["اعصر {lemon}.",
   "اخلط العصير مع أوراق {mint} و{sugar} و4 أكواب ماء بارد وثلج في الخلاط دقيقة.",
   "صفّيه لو تحب، وقدّمه بارد."])
C("lemon_mint", "drink")

R("ayran", "لبن عيران بالنعناع", "🥛", "", "levant saudi", 3, "",
  "yogurt 500 g; mint 0.5 pc; salt 0.5 tsp",
  ["اخفق {yogurt} مع كوبين ماء بارد و{salt}.",
   "أضف {mint} مفروم وثلج.",
   "قدّمه بارد."])
C("ayran", "drink")

R("orange_juice", "عصير برتقال طازج", "🍊", "", "healthy", 5, "",
  "orange 8 pc",
  ["اغسل {orange} وقطّعه نصين.",
   "اعصره بالعصارة واشربه على طول عشان الفيتامينات."])
C("orange_juice", "drink")

R("hibiscus", "كركديه بارد", "🌺", "", "egyptian", 10, "",
  "hibiscus 40 g; sugar 6 tbsp; lemon 1 pc",
  ["اغلي 5 أكواب ماء، وطفّي النار وحط {hibiscus}، وغطّيه 10 دقائق.",
   "صفّيه وأضف {sugar} وعصير {lemon}.",
   "برّده في الثلاجة وقدّمه بالثلج."])
C("hibiscus", "drink")

R("banana_date_smoothie", "سموذي موز وتمر", "🍌", "b", "healthy saudi", 5, "blender",
  "banana 2 pc; dates 8 pc; milk 700 ml; oats 30 g",
  ["انزع نوى {dates}.",
   "اخلط {banana} والتمر و{milk} و{oats} في الخلاط مع ثلج.",
   "قدّمه على طول."])
C("banana_date_smoothie", "drink")

R("mango_juice", "عصير مانجو", "🥭", "", "egyptian", 5, "blender",
  "mango 2 pc; sugar 3 tbsp; milk 300 ml",
  ["قشّر {mango} وقطّعها.",
   "اخلطها مع {sugar} و{milk} وكوب ماء بارد وثلج.",
   "قدّمه بارد."])
C("mango_juice", "drink")

R("karak", "شاي كرك", "🫖", "", "saudi indian", 10, "",
  "tea 4 pc; milk 500 ml; sugar 5 tbsp; cardamom 6 pc; ginger 0.25 tsp; condensed_milk 0.25 pc",
  ["اغلي كوبين ماء مع {cardamom} مدقوق و{ginger} و{tea} 3 دقائق.",
   "أضف {milk} و{sugar} و{condensed_milk} واتركه يغلي على نار هادية 3 دقائق (انتبه لا يفور).",
   "صفّيه وقدّمه سخن."])
C("karak", "drink")

R("arabic_coffee", "قهوة عربية", "☕", "", "saudi", 15, "",
  "arabic_coffee 4 tbsp; cardamom 10 pc; dates 12 pc",
  ["اغلي 4 أكواب ماء، وأضف {arabic_coffee} واتركها تغلي على نار هادية 10 دقائق.",
   "أضف {cardamom} مدقوق وغليها دقيقتين.",
   "اتركها ترتاح دقيقتين عشان التفل ينزل، وصبّها في الدلة.",
   "قدّمها مع {dates}."])
C("arabic_coffee", "drink")

R("tamarind_drink", "تمر هندي", "🟤", "", "egyptian", 15, "",
  "tamarind 150 g; sugar 8 tbsp; lemon 0.5 pc",
  ["انقع {tamarind} في 3 أكواب ماء دافي ساعة (أو من الليلة اللي قبلها).",
   "افركه بإيدك وصفّيه كويس.",
   "أضف {sugar} وعصير {lemon} و3 أكواب ماء بارد، وقدّمه بالثلج."])
C("tamarind_drink", "drink")

R("mint_tea", "شاي بالنعناع", "🍵", "", "egyptian saudi", 5, "",
  "tea 4 pc; mint 0.5 pc; sugar 4 tbsp",
  ["اغلي 4 أكواب ماء.",
   "حط {tea} وأوراق {mint} وطفّي النار، وغطّيه 3 دقائق.",
   "أضف {sugar} حسب رغبتك."])
C("mint_tea", "drink")

R("strawberry_milk", "عصير فراولة بالحليب", "🍓", "", "western", 5, "blender",
  "strawberry 250 g; milk 600 ml; sugar 3 tbsp",
  ["اغسل {strawberry} وشيل الأوراق.",
   "اخلطها مع {milk} و{sugar} وثلج في الخلاط.",
   "قدّمه بارد."])
C("strawberry_milk", "drink")

R("iced_coffee", "آيس كوفي", "🧋", "", "western", 5, "blender",
  "instant_coffee 3 tbsp; milk 600 ml; sugar 4 tbsp; ice_cream 200 ml",
  ["ذوّب {instant_coffee} و{sugar} في ربع كوب ماء سخن.",
   "اخلطها مع {milk} البارد و{ice_cream} وثلج.",
   "قدّمه على طول."])
C("iced_coffee", "drink")

# ======================================================== side salads
R("green_salad", "سلطة خضراء", "🥗", "", "healthy", 8, "",
  "lettuce 0.5 pc; cucumber 2 pc; tomato 2 pc; lemon 1 pc; olive_oil 2 tbsp; salt 0.5 tsp",
  ["قطّع {lettuce} و{cucumber} و{tomato}.",
   "صبّ عصير {lemon} و{olive_oil} و{salt} وقلّب قبل التقديم."])
C("green_salad", "salad")

R("yogurt_cucumber", "سلطة زبادي بالخيار", "🥒", "", "levant saudi healthy", 5, "",
  "yogurt 400 g; cucumber 2 pc; mint 0.5 pc; garlic 1 pc; salt 0.5 tsp",
  ["قطّع {cucumber} مكعبات صغيرة أو ابشره.",
   "اخلطه مع {yogurt} و{garlic} مهروس و{salt}.",
   "زيّنها بـ {mint}."])
C("yogurt_cucumber", "salad")

R("tahini_salad", "سلطة طحينة", "🥣", "", "egyptian levant", 5, "",
  "tahini 5 tbsp; lemon 1 pc; garlic 1 pc; parsley 0.5 pc; cumin 0.25 tsp; salt 0.5 tsp",
  ["اخفق {tahini} مع عصير {lemon} و{garlic} و{salt} و{cumin}.",
   "أضف ماء شوية شوية وأنت تخفق لحد ما تصير كريمية.",
   "أضف {parsley} مفرومة."])
C("tahini_salad", "salad")

R("coleslaw", "سلطة كول سلو", "🥬", "", "western", 10, "",
  "cabbage 0.25 pc; carrot 2 pc; mayo 4 tbsp; vinegar 1 tbsp; sugar 1 tsp; salt 0.5 tsp",
  ["قطّع {cabbage} شرائح رفيعة جداً وابشر {carrot}.",
   "اخلط {mayo} مع {vinegar} و{sugar} و{salt}.",
   "اخلط الكل وبرّده ربع ساعة."])
C("coleslaw", "salad")

R("baladi_salad", "سلطة بلدي", "🍅", "", "egyptian healthy", 8, "",
  "tomato 3 pc; cucumber 3 pc; onion 0.5 pc; green_chili 1 pc; parsley 0.5 pc; lemon 1 pc; cumin 0.5 tsp; olive_oil 2 tbsp; salt 0.5 tsp",
  ["قطّع {tomato} و{cucumber} و{onion} و{green_chili} صغير جداً.",
   "أضف {parsley} مفرومة.",
   "صبّ عصير {lemon} و{olive_oil} و{cumin} و{salt}."])
C("baladi_salad", "salad")

R("beet_free_carrot_salad", "سلطة جزر بالليمون", "🥕", "", "healthy levant", 8, "",
  "carrot 4 pc; lemon 1 pc; olive_oil 2 tbsp; parsley 0.5 pc; cumin 0.25 tsp; salt 0.5 tsp",
  ["ابشر {carrot}.",
   "أضف عصير {lemon} و{olive_oil} و{cumin} و{salt} و{parsley}.",
   "قلّب وقدّمها."])
C("beet_free_carrot_salad", "salad")

# existing dishes that also work as sides
C("fattoush greek_salad chickpea_salad tabbouleh quinoa_tabbouleh", "salad")
C("lentil_soup oat_soup tomato_soup veg_soup mushroom_soup broccoli_soup "
  "freekeh_soup lesan_asfour_soup chicken_vermicelli_soup lentil_vermicelli_soup "
  "tomato_lentil_soup minestrone noodle_soup", "soup")
