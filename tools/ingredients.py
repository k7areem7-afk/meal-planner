# -*- coding: utf-8 -*-
"""Ingredient catalogue for سفرة.

Prices are rough Riyadh estimates in SAR (Nov 2026) for a typical pack at a
mid-priced supermarket. The user edits them inside the app.
Nutrition is per 100 g (or 100 ml) and is approximate.
"""

AISLES = [
    ("produce", "خضار وفواكه"),
    ("meat", "لحوم ودواجن"),
    ("seafood", "أسماك وبحريات"),
    ("dairy", "ألبان وأجبان وبيض"),
    ("bakery", "مخبوزات"),
    ("dry", "أرز وحبوب ومعكرونة"),
    ("canned", "معلبات"),
    ("frozen", "مجمدات"),
    ("condiments", "زيوت وصلصات"),
    ("spices", "بهارات وتوابل"),
    ("other", "أخرى"),
]

STORES = [
    ("panda", "بنده", 1.00),
    ("othaim", "العثيم", 0.96),
    ("lulu", "لولو", 0.97),
    ("carrefour", "كارفور", 1.00),
    ("danube", "الدانوب", 1.10),
    ("tamimi", "التميمي", 1.12),
    ("nesto", "نستو", 0.95),
]

ING = []


def I(id, name, aisle, unit, pack, price, nutr, pcw=None, pcn=None,
      dens=1.0, allergens="", tags="", pantry=False):
    ING.append(dict(
        id=id, name=name, aisle=aisle, unit=unit, pack=pack, price=price,
        nutr=nutr, pcw=pcw, pcn=pcn, dens=dens,
        allergens=[a for a in allergens.split() if a],
        tags=[t for t in tags.split() if t], pantry=pantry,
    ))


SP = (300, 12, 50, 10)  # generic dried spice nutrition

# ---------------------------------------------------------------- produce
I("onion", "بصل", "produce", "g", 1000, 4, (40, 1.1, 9, 0.1), 150, "بصلة")
I("garlic", "ثوم", "produce", "g", 250, 4, (149, 6.4, 33, 0.5), 5, "فص")
I("tomato", "طماطم", "produce", "g", 1000, 6, (18, 0.9, 3.9, 0.2), 120, "حبة")
I("potato", "بطاطس", "produce", "g", 1000, 5, (77, 2, 17, 0.1), 200, "حبة")
I("carrot", "جزر", "produce", "g", 1000, 5, (41, 0.9, 10, 0.2), 80, "حبة")
I("cucumber", "خيار", "produce", "g", 1000, 7, (15, 0.7, 3.6, 0.1), 120, "حبة")
I("lettuce", "خس", "produce", "pc", 1, 5, (15, 1.4, 2.9, 0.2), 400, "رأس")
I("bell_pepper", "فلفل رومي", "produce", "g", 1000, 12, (26, 1, 6, 0.3), 150, "حبة")
I("zucchini", "كوسا", "produce", "g", 1000, 8, (17, 1.2, 3.1, 0.3), 150, "حبة")
I("eggplant", "باذنجان", "produce", "g", 1000, 7, (25, 1, 6, 0.2), 300, "حبة", tags="eggplant")
I("parsley", "بقدونس", "produce", "pc", 1, 1.5, (36, 3, 6, 0.8), 60, "ربطة")
I("coriander", "كزبرة خضراء", "produce", "pc", 1, 1.5, (23, 2, 4, 0.5), 50, "ربطة", tags="coriander")
I("mint", "نعناع", "produce", "pc", 1, 1.5, (70, 3.8, 15, 0.9), 40, "ربطة")
I("lemon", "ليمون", "produce", "g", 1000, 8, (29, 1.1, 9, 0.3), 100, "حبة")
I("green_chili", "فلفل حار أخضر", "produce", "g", 250, 3, (40, 2, 9, 0.2), 15, "حبة", tags="spicy")
I("mushroom", "فطر", "produce", "g", 250, 6, (22, 3.1, 3.3, 0.3), tags="mushroom")
I("banana", "موز", "produce", "g", 1000, 6, (89, 1.1, 23, 0.3), 120, "حبة")
I("dates", "تمر", "produce", "g", 1000, 25, (282, 2.5, 75, 0.4), 10, "حبة")
I("avocado", "أفوكادو", "produce", "pc", 1, 4, (160, 2, 9, 15), 200, "حبة")
I("cauliflower", "قرنبيط", "produce", "pc", 1, 6, (25, 1.9, 5, 0.3), 600, "رأس")

# ---------------------------------------------------------------- frozen
I("okra", "بامية مجمدة", "frozen", "g", 400, 6, (33, 1.9, 7, 0.2), tags="okra")
I("peas_carrots", "بازلاء وجزر مجمد", "frozen", "g", 900, 9, (60, 3.5, 10, 0.4))
I("molokhia", "ملوخية مجمدة", "frozen", "g", 400, 6, (34, 4.6, 6, 0.3))
I("green_beans", "فاصوليا خضراء مجمدة", "frozen", "g", 400, 6, (31, 1.8, 7, 0.2))
I("broccoli", "بروكلي مجمد", "frozen", "g", 400, 7, (34, 2.8, 7, 0.4))

# ---------------------------------------------------------------- meat
I("chicken_whole", "دجاج كامل", "meat", "g", 1000, 17, (215, 18, 0, 15), 1000, "دجاجة", tags="chicken")
I("chicken_breast", "صدور دجاج", "meat", "g", 1000, 30, (120, 22.5, 0, 2.6), tags="chicken")
I("chicken_thigh", "أفخاذ دجاج بدون عظم", "meat", "g", 1000, 26, (177, 19, 0, 11), tags="chicken")
I("chicken_liver", "كبدة دجاج", "meat", "g", 500, 9, (119, 17, 0.7, 4.8), tags="chicken liver")
I("minced_beef", "لحم بقري مفروم", "meat", "g", 500, 22, (250, 17, 0, 20), tags="beef")
I("beef_cubes", "لحم بقري مكعبات", "meat", "g", 1000, 48, (200, 26, 0, 10), tags="beef")
I("lamb", "لحم غنم بالعظم", "meat", "g", 1000, 65, (282, 17, 0, 23), tags="lamb")

# ---------------------------------------------------------------- seafood
I("fish_fillet", "فيليه سمك", "seafood", "g", 1000, 25, (96, 20, 0, 1.7), allergens="fish", tags="fish")
I("shrimp", "روبيان", "seafood", "g", 1000, 45, (85, 20, 0, 0.5), allergens="shellfish", tags="seafood")

# ---------------------------------------------------------------- dairy
I("eggs", "بيض", "dairy", "pc", 30, 22, (143, 12.6, 0.7, 9.5), 55, "بيضة", allergens="eggs")
I("milk", "حليب", "dairy", "ml", 1000, 6.5, (61, 3.2, 4.8, 3.3), dens=1.03, allergens="dairy")
I("yogurt", "زبادي", "dairy", "g", 1000, 9, (61, 3.5, 4.7, 3.3), dens=1.03, allergens="dairy")
I("labneh", "لبنة", "dairy", "g", 400, 9, (160, 6, 4, 13), dens=1.0, allergens="dairy")
I("feta", "جبن أبيض", "dairy", "g", 400, 14, (264, 14, 4, 21), allergens="dairy")
I("halloumi", "جبن حلوم", "dairy", "g", 250, 12, (320, 22, 2, 25), allergens="dairy")
I("mozzarella", "جبن موزاريلا", "dairy", "g", 400, 16, (280, 22, 2.2, 21), dens=0.45, allergens="dairy")
I("cheddar", "جبن شيدر", "dairy", "g", 200, 9, (400, 25, 1.3, 33), 20, "شريحة", dens=0.45, allergens="dairy")
I("cream", "كريمة طبخ", "dairy", "ml", 200, 5, (200, 2.5, 4, 20), allergens="dairy")
I("butter", "زبدة", "dairy", "g", 200, 11, (717, 0.9, 0.1, 81), dens=0.95, allergens="dairy")

# ---------------------------------------------------------------- bakery
I("arabic_bread", "خبز عربي", "bakery", "pc", 6, 3, (275, 9, 55, 1.2), 85, "رغيف", allergens="gluten")
I("toast", "خبز توست", "bakery", "pc", 20, 6, (265, 9, 49, 3.2), 30, "شريحة", allergens="gluten")
I("tortilla", "خبز تورتيلا", "bakery", "pc", 8, 9, (310, 8, 52, 7), 45, "رغيف", allergens="gluten")

# ---------------------------------------------------------------- dry goods
I("rice", "أرز بسمتي", "dry", "g", 2000, 22, (360, 7, 79, 0.6), dens=0.79)
I("pasta", "معكرونة", "dry", "g", 500, 4.5, (371, 13, 75, 1.5), dens=0.45, allergens="gluten")
I("spaghetti", "سباغيتي", "dry", "g", 500, 4.5, (371, 13, 75, 1.5), allergens="gluten")
I("bulgur", "برغل", "dry", "g", 1000, 9, (342, 12, 76, 1.3), dens=0.6, allergens="gluten")
I("freekeh", "فريكة", "dry", "g", 1000, 16, (325, 13, 72, 2.5), dens=0.7, allergens="gluten")
I("jareesh", "جريش", "dry", "g", 1000, 12, (340, 11, 75, 1.5), dens=0.7, allergens="gluten")
I("oats", "شوفان", "dry", "g", 500, 9, (389, 17, 66, 7), dens=0.38, allergens="gluten")
I("flour", "دقيق", "dry", "g", 1000, 4, (364, 10, 76, 1), dens=0.53, allergens="gluten")
I("red_lentils", "عدس أحمر", "dry", "g", 1000, 9, (352, 24, 63, 1.1), dens=0.8)
I("brown_lentils", "عدس بني (أبو جبة)", "dry", "g", 1000, 10, (352, 24, 63, 1.1), dens=0.8)
I("vermicelli", "شعيرية", "dry", "g", 400, 3, (371, 13, 75, 1.5), dens=0.4, allergens="gluten")
I("noodles", "نودلز بالبيض", "dry", "g", 400, 6, (380, 13, 72, 3), allergens="gluten eggs")
I("sugar", "سكر", "dry", "g", 2000, 10, (387, 0, 100, 0), dens=0.85, pantry=True)
I("baking_powder", "بيكنج باودر", "dry", "g", 100, 4, (53, 0, 28, 0), dens=0.9, pantry=True)
I("almonds", "لوز", "dry", "g", 200, 15, (579, 21, 22, 50), dens=0.6, allergens="nuts")
I("raisins", "زبيب", "dry", "g", 250, 8, (299, 3, 79, 0.5), dens=0.65)
I("sesame", "سمسم", "dry", "g", 200, 7, (573, 18, 23, 50), dens=0.6, allergens="sesame")
I("honey", "عسل", "dry", "g", 500, 25, (304, 0.3, 82, 0), dens=1.4)

# ---------------------------------------------------------------- canned
I("fava_can", "فول مدمس معلب", "canned", "g", 400, 3, (110, 7.6, 19.6, 0.4), 400, "علبة")
I("chickpeas_can", "حمص حب معلب", "canned", "g", 400, 3.5, (139, 7, 22, 2.6), 400, "علبة")
I("kidney_beans", "فاصوليا حمراء معلبة", "canned", "g", 400, 4, (127, 8.7, 22.8, 0.5), 400, "علبة")
I("corn_can", "ذرة معلبة", "canned", "g", 340, 4, (86, 3.3, 19, 1.4), 340, "علبة")
I("tuna_can", "تونة معلبة", "canned", "g", 160, 6, (190, 26, 0, 9), 160, "علبة", allergens="fish", tags="fish")
I("crushed_tomatoes", "طماطم مهروسة معلبة", "canned", "g", 400, 4.5, (32, 1.6, 7, 0.3), 400, "علبة")
I("tomato_paste", "معجون طماطم", "canned", "g", 400, 4, (82, 4.3, 19, 0.5), dens=1.1)
I("coconut_milk", "حليب جوز الهند", "canned", "ml", 400, 7, (230, 2.3, 6, 24), 400, "علبة")
I("tahini", "طحينة", "canned", "g", 450, 12, (595, 17, 21, 54), dens=0.95, allergens="sesame")

# ---------------------------------------------------------------- condiments
I("olive_oil", "زيت زيتون", "condiments", "ml", 1000, 35, (884, 0, 0, 100), dens=0.92, pantry=True)
I("veg_oil", "زيت نباتي", "condiments", "ml", 1500, 18, (884, 0, 0, 100), dens=0.92, pantry=True)
I("vinegar", "خل", "condiments", "ml", 500, 4, (18, 0, 0.04, 0), pantry=True)
I("soy_sauce", "صويا صوص", "condiments", "ml", 250, 8, (53, 8, 5, 0), allergens="soy gluten")
I("mayo", "مايونيز", "condiments", "g", 400, 10, (680, 1, 0.6, 75), dens=0.95, allergens="eggs")
I("hot_sauce", "صلصة حارة", "condiments", "ml", 150, 5, (11, 0.5, 2, 0.4), tags="spicy")
I("stock_cube", "مكعب مرق", "condiments", "pc", 24, 8, (250, 10, 20, 15), 10, "مكعب")

# ---------------------------------------------------------------- spices (pantry)
I("salt", "ملح", "spices", "g", 700, 2, (0, 0, 0, 0), dens=1.2, pantry=True)
I("black_pepper", "فلفل أسود", "spices", "g", 100, 6, SP, dens=0.5, pantry=True)
I("cumin", "كمون", "spices", "g", 100, 6, SP, dens=0.5, pantry=True)
I("turmeric", "كركم", "spices", "g", 100, 5, SP, dens=0.5, pantry=True)
I("paprika", "بابريكا", "spices", "g", 100, 6, SP, dens=0.5, pantry=True)
I("kabsa_spice", "بهارات كبسة", "spices", "g", 100, 7, SP, dens=0.5, pantry=True)
I("seven_spice", "بهارات مشكلة", "spices", "g", 100, 6, SP, dens=0.5, pantry=True)
I("cinnamon", "قرفة", "spices", "g", 100, 6, SP, 3, "عود", dens=0.5, pantry=True)
I("cardamom", "هيل", "spices", "g", 100, 18, SP, 0.2, "حبة", dens=0.5, pantry=True)
I("curry", "كاري", "spices", "g", 100, 6, SP, dens=0.5, pantry=True)
I("chili_flakes", "شطة مجروشة", "spices", "g", 100, 6, SP, dens=0.5, tags="spicy", pantry=True)
I("oregano", "أوريغانو مجفف", "spices", "g", 50, 6, SP, dens=0.3, pantry=True)
I("bay_leaf", "ورق غار", "spices", "g", 50, 6, SP, 0.2, "ورقة", pantry=True)
I("black_lime", "لومي", "spices", "g", 100, 8, SP, 5, "حبة", pantry=True)
I("ginger", "زنجبيل مطحون", "spices", "g", 100, 6, SP, dens=0.5, pantry=True)
I("nutmeg", "جوزة الطيب", "spices", "g", 50, 6, SP, dens=0.5, pantry=True)
I("zaatar", "زعتر", "spices", "g", 200, 8, (270, 9, 40, 10), dens=0.45, allergens="sesame")

# ---------------------------------------------------------------- v2 additions
I("spinach", "سبانخ مجمدة", "frozen", "g", 400, 6, (23, 2.9, 3.6, 0.4))
I("cabbage", "ملفوف", "produce", "pc", 1, 5, (25, 1.3, 6, 0.1), 1200, "رأس")
I("apple", "تفاح", "produce", "g", 1000, 9, (52, 0.3, 14, 0.2), 180, "حبة")
I("white_beans", "فاصوليا بيضاء معلبة", "canned", "g", 400, 4, (110, 7, 20, 0.5), 400, "علبة")
I("olives", "زيتون", "canned", "g", 450, 10, (145, 1, 4, 15))
I("cheese_triangles", "جبنة مثلثات", "dairy", "pc", 8, 7, (260, 10, 6, 22), 17, "قطعة", allergens="dairy")
I("cream_cheese", "جبنة كريمية", "dairy", "g", 200, 9, (340, 6, 4, 34), dens=1.0, allergens="dairy")
I("peanut_butter", "زبدة فول سوداني", "dry", "g", 340, 12, (588, 25, 20, 50), dens=1.0, allergens="nuts")
I("halawa", "حلاوة طحينية", "dry", "g", 450, 12, (520, 12, 50, 30), allergens="sesame")
I("sambosa_sheets", "رقائق سمبوسة", "frozen", "pc", 40, 10, (290, 8, 60, 2), 12, "ورقة", allergens="gluten")
I("breadcrumbs", "بقسماط مطحون", "dry", "g", 500, 6, (395, 13, 72, 5), dens=0.45, allergens="gluten")
I("lasagna", "رقائق لازانيا", "dry", "g", 500, 9, (371, 13, 75, 1.5), allergens="gluten")
I("burger_buns", "خبز برجر", "bakery", "pc", 6, 7, (280, 9, 50, 4.5), 70, "حبة", allergens="gluten sesame")
I("chicken_wings", "أجنحة دجاج", "meat", "g", 1000, 22, (203, 18, 0, 14), tags="chicken")
I("quinoa", "كينوا", "dry", "g", 500, 16, (368, 14, 64, 6), dens=0.75)
I("chickpeas_dry", "حمص حب جاف", "dry", "g", 1000, 9, (364, 19, 61, 6), dens=0.8)
I("sumac", "سماق", "spices", "g", 100, 7, SP, dens=0.5, pantry=True)
I("pom_molasses", "دبس رمان", "condiments", "ml", 300, 9, (250, 0, 62, 0), dens=1.3)
I("ketchup", "كاتشب", "condiments", "g", 500, 8, (112, 1.7, 26, 0.1), dens=1.1)

# ---------------------------------------------------------------- v3 additions (Egyptian & healthy)
I("broad_beans_dry", "فول مدشوش", "dry", "g", 1000, 10, (341, 26, 58, 1.5), dens=0.8)
I("pastrami", "بسطرمة", "meat", "g", 200, 18, (250, 25, 2, 16), tags="beef")
I("roumi", "جبنة رومي", "dairy", "g", 250, 15, (390, 26, 2, 31), dens=0.45, allergens="dairy")
I("cottage", "جبنة قريش", "dairy", "g", 500, 10, (98, 11, 3.4, 4.3), allergens="dairy")
I("beef_liver", "كبدة بقري", "meat", "g", 500, 15, (135, 20, 3.9, 3.6), tags="beef liver")
I("grape_leaves", "ورق عنب", "canned", "g", 500, 14, (93, 5.6, 17, 2.1))
I("dill", "شبت", "produce", "pc", 1, 1.5, (43, 3.5, 7, 1.1), 40, "ربطة")
I("taro", "قلقاس", "produce", "g", 1000, 9, (112, 1.5, 26, 0.2))
I("black_eyed_peas", "لوبيا معلبة", "canned", "g", 400, 4, (116, 7.7, 21, 0.5), 400, "علبة")
I("orzo", "لسان عصفور", "dry", "g", 400, 4, (371, 13, 75, 1.5), dens=0.8, allergens="gluten")
I("minced_chicken", "دجاج مفروم", "meat", "g", 500, 15, (143, 17, 0, 8), tags="chicken")
I("sweet_potato", "بطاطا حلوة", "produce", "g", 1000, 9, (86, 1.6, 20, 0.1), 250, "حبة")
I("wheat", "قمح بليلة", "dry", "g", 1000, 10, (340, 13, 72, 2.5), dens=0.75, allergens="gluten")

# Emoji shown on ingredient cards (instead of photos).
EMOJI = {
    "onion": "🧅", "garlic": "🧄", "tomato": "🍅", "potato": "🥔", "carrot": "🥕",
    "cucumber": "🥒", "lettuce": "🥬", "bell_pepper": "🫑", "zucchini": "🥒",
    "eggplant": "🍆", "parsley": "🌿", "coriander": "🌿", "mint": "🌱", "lemon": "🍋",
    "green_chili": "🌶️", "mushroom": "🍄", "banana": "🍌", "dates": "🌴",
    "avocado": "🥑", "cauliflower": "🥦", "okra": "🌱", "peas_carrots": "🫛",
    "molokhia": "🥬", "green_beans": "🫛", "broccoli": "🥦", "chicken_whole": "🐔",
    "chicken_breast": "🍗", "chicken_thigh": "🍗", "chicken_liver": "🫀",
    "minced_beef": "🥩", "beef_cubes": "🥩", "lamb": "🍖", "fish_fillet": "🐟",
    "shrimp": "🦐", "eggs": "🥚", "milk": "🥛", "yogurt": "🥣", "labneh": "🥣",
    "feta": "🧀", "halloumi": "🧀", "mozzarella": "🧀", "cheddar": "🧀",
    "cream": "🥛", "butter": "🧈", "arabic_bread": "🫓", "toast": "🍞",
    "tortilla": "🫓", "rice": "🍚", "pasta": "🍝", "spaghetti": "🍝", "bulgur": "🌾",
    "freekeh": "🌾", "jareesh": "🌾", "oats": "🥣", "flour": "🌾", "red_lentils": "🫘",
    "brown_lentils": "🫘", "vermicelli": "🍜", "noodles": "🍜", "sugar": "🍬",
    "baking_powder": "🧂", "almonds": "🌰", "raisins": "🍇", "sesame": "🌰",
    "honey": "🍯", "fava_can": "🥫", "chickpeas_can": "🥫", "kidney_beans": "🥫",
    "corn_can": "🌽", "tuna_can": "🐟", "crushed_tomatoes": "🥫",
    "tomato_paste": "🥫", "coconut_milk": "🥥", "tahini": "🫙", "olive_oil": "🫒",
    "veg_oil": "🛢️", "vinegar": "🍶", "soy_sauce": "🍶", "mayo": "🫙",
    "hot_sauce": "🌶️", "stock_cube": "🧊", "salt": "🧂", "black_pepper": "🧂",
    "cumin": "🧂", "turmeric": "🧂", "paprika": "🌶️", "kabsa_spice": "🧂",
    "seven_spice": "🧂", "cinnamon": "🪵", "cardamom": "🟢", "curry": "🧂",
    "chili_flakes": "🌶️", "oregano": "🌿", "bay_leaf": "🍃", "black_lime": "🍋",
    "ginger": "🫚", "nutmeg": "🌰", "zaatar": "🌿", "spinach": "🥬", "cabbage": "🥬",
    "apple": "🍎", "white_beans": "🥫", "olives": "🫒", "cheese_triangles": "🧀",
    "cream_cheese": "🧀", "peanut_butter": "🥜", "halawa": "🍬",
    "sambosa_sheets": "🔺", "breadcrumbs": "🍞", "lasagna": "🍝",
    "burger_buns": "🍔", "chicken_wings": "🍗", "quinoa": "🌾",
    "chickpeas_dry": "🫘", "sumac": "🧂", "pom_molasses": "🍶", "ketchup": "🍅",
    "broad_beans_dry": "🫘", "pastrami": "🥓", "roumi": "🧀", "cottage": "🧀",
    "beef_liver": "🫀", "grape_leaves": "🍃", "dill": "🌿", "taro": "🥔",
    "black_eyed_peas": "🥫", "orzo": "🍚", "minced_chicken": "🍗",
    "sweet_potato": "🍠", "wheat": "🌾",
}
