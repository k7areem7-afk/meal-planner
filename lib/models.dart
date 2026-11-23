import 'i18n.dart';
// Data models for سفرة.

List<String> _strList(dynamic v) =>
    v == null ? <String>[] : (v as List).map((e) => e.toString()).toList();

double _d(dynamic v) => v == null ? 0 : (v as num).toDouble();

class Named {
  final String id;
  final String nameAr;
  final String nameEn;
  const Named(this.id, this.nameAr, [this.nameEn = '']);
  String get name => L.en && nameEn.isNotEmpty ? nameEn : nameAr;
  factory Named.fromJson(Map<String, dynamic> j) => Named(j['id'] as String,
      j['name'] as String, (j['nameEn'] as String?) ?? '');
}

class Store {
  final String id;
  final String nameAr;
  final String nameEn;
  final double factor;
  const Store(this.id, this.nameAr, this.nameEn, this.factor);
  String get name => L.en && nameEn.isNotEmpty ? nameEn : nameAr;
  factory Store.fromJson(Map<String, dynamic> j) => Store(j['id'] as String,
      j['name'] as String, (j['nameEn'] as String?) ?? '', _d(j['factor']));
}

class Ingredient {
  final String id;
  final String nameAr;
  final String nameEn;
  final String aisle;
  final String unit; // g | ml | pc
  final double pack;
  final double price;
  final String? pcNameAr;
  final String? pcNameEn;
  final double? pcWeight;
  final double density;
  final List<String> allergens;
  final List<String> tags;
  final bool pantry;
  final String emoji;
  final List<double> nutr; // kcal, protein, carbs, fat per 100 g/ml

  const Ingredient({
    required this.id,
    required this.nameAr,
    this.nameEn = '',
    required this.aisle,
    required this.unit,
    required this.pack,
    required this.price,
    this.pcNameAr,
    this.pcNameEn,
    this.pcWeight,
    required this.density,
    required this.allergens,
    required this.tags,
    required this.pantry,
    required this.emoji,
    required this.nutr,
  });

  bool get isSpice => aisle == 'spices' || id == 'salt';
  String get name => L.en && nameEn.isNotEmpty ? nameEn : nameAr;
  String? get pcName => L.en ? (pcNameEn ?? pcNameAr) : pcNameAr;

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
        id: j['id'] as String,
        nameAr: j['name'] as String,
        nameEn: (j['nameEn'] as String?) ?? '',
        aisle: j['aisle'] as String,
        unit: j['unit'] as String,
        pack: _d(j['pack']),
        price: _d(j['price']),
        pcNameAr: j['pcName'] as String?,
        pcNameEn: j['pcNameEn'] as String?,
        pcWeight: j['pcWeight'] == null ? null : _d(j['pcWeight']),
        density: _d(j['density']),
        allergens: _strList(j['allergens']),
        tags: _strList(j['tags']),
        pantry: j['pantry'] == true,
        emoji: (j['emoji'] as String?) ?? '🥫',
        nutr: ((j['nutr'] as List?) ?? const [0, 0, 0, 0])
            .map((e) => (e as num).toDouble())
            .toList(),
      );
}

class RecipeLine {
  final String ingId;
  final double q; // display quantity for the recipe's base servings
  final String u; // g ml pc tsp tbsp cup
  final double b; // amount in the ingredient's base unit
  const RecipeLine(this.ingId, this.q, this.u, this.b);
  factory RecipeLine.fromJson(Map<String, dynamic> j) =>
      RecipeLine(j['i'] as String, _d(j['q']), j['u'] as String, _d(j['b']));
  Map<String, dynamic> toJson() => {'i': ingId, 'q': q, 'u': u, 'b': b};
}

class Recipe {
  final String id;
  final String titleAr;
  final String titleEn;
  final String emoji;
  final List<String> meals;
  final List<String> styles;
  final int minutes;
  final List<String> appliances;
  final int servings;
  final List<RecipeLine> lines;
  final List<String> steps;
  final int kcal;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> allergens;
  final List<String> tags;
  final bool keeps; // fine to eat on the second day
  final bool fried;
  final List<String> diets;
  final List<String> vibes;
  final List<String> course; // soup salad drink dessert (as a side)
  final bool user; // made by the user or by AI

  String get title => L.en && titleEn.isNotEmpty ? titleEn : titleAr;
  bool get isSideOnly => meals.isEmpty;

  const Recipe({
    required this.id,
    required this.titleAr,
    this.titleEn = '',
    required this.emoji,
    required this.meals,
    required this.styles,
    required this.minutes,
    required this.appliances,
    required this.servings,
    required this.lines,
    required this.steps,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.allergens,
    required this.tags,
    required this.keeps,
    this.fried = false,
    this.diets = const [],
    this.vibes = const [],
    this.course = const [],
    this.user = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) {
    final n = (j['nutrition'] as Map).cast<String, dynamic>();
    return Recipe(
      id: j['id'] as String,
      titleAr: j['title'] as String,
      titleEn: (j['titleEn'] as String?) ?? '',
      emoji: j['emoji'] as String,
      meals: _strList(j['meals']),
      styles: _strList(j['styles']),
      minutes: (j['minutes'] as num).toInt(),
      appliances: _strList(j['appliances']),
      servings: (j['servings'] as num).toInt(),
      lines: (j['ingredients'] as List)
          .map((e) => RecipeLine.fromJson((e as Map).cast<String, dynamic>()))
          .toList(),
      steps: _strList(j['steps']),
      kcal: (n['kcal'] as num).toInt(),
      protein: _d(n['protein']),
      carbs: _d(n['carbs']),
      fat: _d(n['fat']),
      allergens: _strList(j['allergens']),
      tags: _strList(j['tags']),
      keeps: j['keeps'] == true,
      fried: j['fried'] == true,
      diets: _strList(j['diets']),
      vibes: _strList(j['vibes']),
      course: _strList(j['course']),
      user: j['user'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': titleAr,
        'titleEn': titleEn,
        'emoji': emoji,
        'meals': meals,
        'styles': styles,
        'minutes': minutes,
        'appliances': appliances,
        'servings': servings,
        'ingredients': lines.map((l) => l.toJson()).toList(),
        'steps': steps,
        'nutrition': {
          'kcal': kcal,
          'protein': protein,
          'carbs': carbs,
          'fat': fat
        },
        'allergens': allergens,
        'tags': tags,
        'keeps': keeps,
        'fried': fried,
        'diets': diets,
        'vibes': vibes,
        'course': course,
        'user': user,
      };
}

class Catalog {
  final List<Named> aisles;
  final List<Store> stores;
  final List<Named> styles;
  final Map<String, Ingredient> ingredients;
  final List<Recipe> recipes;
  final Map<String, Recipe> recipeById;

  Catalog({
    required this.aisles,
    required this.stores,
    required this.styles,
    required this.ingredients,
    required List<Recipe> recipes,
  })  : recipes = [...recipes],
        recipeById = {for (final r in recipes) r.id: r};

  factory Catalog.fromJson(Map<String, dynamic> cat, List<dynamic> rec) {
    final ings = (cat['ingredients'] as List)
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();
    return Catalog(
      aisles: (cat['aisles'] as List)
          .map((e) => Named.fromJson(e as Map<String, dynamic>))
          .toList(),
      stores: (cat['stores'] as List)
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
      styles: (cat['styles'] as List)
          .map((e) => Named.fromJson(e as Map<String, dynamic>))
          .toList(),
      ingredients: {for (final i in ings) i.id: i},
      recipes: rec
          .map((e) => Recipe.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  void register(Recipe r) {
    recipes.removeWhere((x) => x.id == r.id);
    recipes.add(r);
    recipeById[r.id] = r;
  }

  void unregister(String id) {
    recipes.removeWhere((x) => x.id == id);
    recipeById.remove(id);
  }

  Store store(String id) =>
      stores.firstWhere((s) => s.id == id, orElse: () => stores.first);

  String aisleName(String id) =>
      aisles.firstWhere((a) => a.id == id, orElse: () => aisles.last).name;

  String styleName(String id) =>
      styles.firstWhere((s) => s.id == id, orElse: () => Named(id, id)).name;
}

// ------------------------------------------------------------- user data

class Prefs {
  String storeId;
  double budget; // SAR per week
  int people;
  Set<String> meals; // b l d
  Set<String> diets; // see dietOptions
  Set<String> styles;
  Set<String> vibes;
  Set<String> allergies;
  Set<String> dislikes;
  Set<String> appliances;
  Set<String> fridge; // ingredients already at home
  bool leftovers; // cook once, eat two days
  Map<String, Set<String>> sides; // slot -> soup salad drink dessert
  bool kcalTarget;
  int kcal; // per person per day
  int protein;
  int carbs;
  int fat;

  Prefs({
    this.storeId = 'panda',
    this.budget = 600,
    this.people = 4,
    Set<String>? meals,
    Set<String>? diets,
    Set<String>? styles,
    Set<String>? vibes,
    Set<String>? allergies,
    Set<String>? dislikes,
    Set<String>? appliances,
    Set<String>? fridge,
    this.leftovers = true,
    Map<String, Set<String>>? sides,
    this.kcalTarget = false,
    this.kcal = 2000,
    this.protein = 120,
    this.carbs = 200,
    this.fat = 70,
  })  : meals = meals ?? {'b', 'l', 'd'},
        diets = diets ?? <String>{},
        styles = styles ?? <String>{},
        vibes = vibes ?? <String>{},
        allergies = allergies ?? <String>{},
        dislikes = dislikes ?? <String>{},
        appliances = appliances ?? {'oven'},
        fridge = fridge ?? <String>{},
        sides = sides ?? <String, Set<String>>{};

  Prefs copy() => Prefs.fromJson(toJson());

  Map<String, dynamic> toJson() => {
        'storeId': storeId,
        'budget': budget,
        'people': people,
        'meals': meals.toList(),
        'diets': diets.toList(),
        'styles': styles.toList(),
        'vibes': vibes.toList(),
        'allergies': allergies.toList(),
        'dislikes': dislikes.toList(),
        'appliances': appliances.toList(),
        'fridge': fridge.toList(),
        'leftovers': leftovers,
        'sides': sides.map((k, v) => MapEntry(k, v.toList())),
        'kcalTarget': kcalTarget,
        'kcal': kcal,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  factory Prefs.fromJson(Map<String, dynamic> j) {
    final diets = _strList(j['diets']).toSet();
    final old = j['diet'] as String?; // v1/v2 single diet
    if (old != null && old != 'none') {
      diets.add(old == 'low_carb' ? 'keto' : old);
    }
    int i(String k, int d) => (j[k] as num?)?.toInt() ?? d;
    return Prefs(
      storeId: (j['storeId'] as String?) ?? 'panda',
      budget: j['budget'] == null ? 600 : _d(j['budget']),
      people: i('people', 4),
      meals: _strList(j['meals']).toSet(),
      diets: diets,
      styles: _strList(j['styles']).toSet(),
      vibes: _strList(j['vibes']).toSet(),
      allergies: _strList(j['allergies']).toSet(),
      dislikes: _strList(j['dislikes']).toSet(),
      appliances: _strList(j['appliances']).toSet(),
      fridge: _strList(j['fridge']).toSet(),
      leftovers: j['leftovers'] != false,
      sides: ((j['sides'] as Map?) ?? {}).map((k, v) =>
          MapEntry(k.toString(), _strList(v).toSet())),
      kcalTarget: j['kcalTarget'] == true,
      kcal: i('kcal', 2000),
      protein: i('protein', 120),
      carbs: i('carbs', 200),
      fat: i('fat', 70),
    );
  }
}

class PlannedMeal {
  int day; // 0..6 from plan start
  String slot; // b l d
  String recipeId;
  int servings;
  bool locked;
  bool leftover; // eaten from yesterday's pot, nothing to cook or buy
  List<String> sides; // soup / salad / drink / dessert recipe ids

  PlannedMeal({
    required this.day,
    required this.slot,
    required this.recipeId,
    required this.servings,
    this.locked = false,
    this.leftover = false,
    List<String>? sides,
  }) : sides = sides ?? <String>[];

  PlannedMeal copy() => PlannedMeal(
      day: day,
      slot: slot,
      recipeId: recipeId,
      servings: servings,
      locked: locked,
      leftover: leftover,
      sides: [...sides]);

  Map<String, dynamic> toJson() => {
        'day': day,
        'slot': slot,
        'recipeId': recipeId,
        'servings': servings,
        'locked': locked,
        'leftover': leftover,
        'sides': sides,
      };

  factory PlannedMeal.fromJson(Map<String, dynamic> j) => PlannedMeal(
        day: (j['day'] as num).toInt(),
        slot: j['slot'] as String,
        recipeId: j['recipeId'] as String,
        servings: (j['servings'] as num).toInt(),
        locked: j['locked'] == true,
        leftover: j['leftover'] == true,
        sides: _strList(j['sides']),
      );
}

class PriceOverride {
  double pack;
  double price;
  PriceOverride(this.pack, this.price);
  Map<String, dynamic> toJson() => {'pack': pack, 'price': price};
  factory PriceOverride.fromJson(Map<String, dynamic> j) =>
      PriceOverride(_d(j['pack']), _d(j['price']));
}

class CustomItem {
  final String id;
  String name;
  String note;
  double price;
  CustomItem(
      {required this.id, required this.name, this.note = '', this.price = 0});
  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'note': note, 'price': price};
  factory CustomItem.fromJson(Map<String, dynamic> j) => CustomItem(
        id: j['id'] as String,
        name: j['name'] as String,
        note: (j['note'] as String?) ?? '',
        price: _d(j['price']),
      );
}

// ------------------------------------------------------------- labels

class Option {
  final String id;
  final String emoji;
  final String title;
  final String sub;
  const Option(this.id, this.emoji, this.title, [this.sub = '']);
}

Map<String, String> get slotNames => {'b': tx('الفطور', 'Breakfast'), 'l': tx('الغداء', 'Lunch'), 'd': tx('العشاء', 'Dinner')};
const slotOrder = ['b', 'l', 'd'];

List<Option> get dietOptions => [
  Option('vegetarian', '🥦', tx('نباتي', 'Vegetarian'), tx('بدون لحوم ولا سمك', 'No meat or fish')),
  Option('vegan', '🌱', tx('نباتي صرف', 'Vegan'), tx('بدون أي منتج حيواني', 'Plants only')),
  Option('pescatarian', '🐟', tx('سمك بدون لحوم', 'Pescatarian'), tx('سمك وبحريات، بدون لحوم', 'Fish and seafood, no meat')),
  Option('keto', '🔥', tx('كيتو', 'Keto'), tx('كارب قليل جداً', 'Very low carb')),
  Option('high_protein', '💪', tx('بروتين عالي', 'High protein'), tx('وجبات غنية بالبروتين', 'Protein-forward meals')),
  Option('glp1', '🎯', tx('حصص خفيفة', 'Lighter portions'), tx('سعرات أقل وبروتين كويس', 'Fewer calories, good protein')),
  Option('anti_inflammatory', '💧', tx('مضاد للالتهاب', 'Anti-inflammatory'), tx('أكل طبيعي بدون مقلي ولا مصنّع', 'Whole foods, nothing fried or processed')),
  Option('mediterranean', '🫒', tx('متوسطي', 'Mediterranean'), tx('خضار وسمك وزيت زيتون', 'Veg, fish and olive oil')),
];
const hardDiets = {'vegetarian', 'vegan', 'pescatarian'};

const styleEmoji = {
  'saudi': '🇸🇦',
  'egyptian': '🇪🇬',
  'levant': '🇱🇧',
  'italian': '🇮🇹',
  'asian': '🇹🇭',
  'indian': '🇮🇳',
  'mexican': '🇲🇽',
  'healthy': '🥗',
  'western': '🍔',
};
Map<String, String> get styleSub => {
  'saudi': tx('كبسة، مندي، جريش', 'Kabsa, mandi, jareesh'),
  'egyptian': tx('محاشي، كشري، مكرونات', 'Mahshi, koshari, pasta'),
  'levant': tx('مقلوبة، فتة، شاورما', 'Maqluba, fatteh, shawarma'),
  'italian': tx('باستا، طماطم، أعشاب', 'Pasta, tomato, herbs'),
  'asian': tx('كاري، نودلز، صويا', 'Curry, noodles, soy'),
  'indian': tx('برياني، كاري، عدس', 'Biryani, curry, lentils'),
  'mexican': tx('تاكو، فاهيتا، فاصوليا', 'Tacos, fajitas, beans'),
  'healthy': tx('خفيف ومتوازن', 'Light and balanced'),
  'western': tx('برجر، مشويات، شوربات', 'Burgers, roasts, soups'),
};

List<Option> get vibeOptions => [
  Option('quick', '⚡', tx('سريع وسهل', 'Quick & easy'), tx('جاهز في حوالي 20 دقيقة', 'Ready in about 20 minutes')),
  Option('one_pan', '🍳', tx('طاسة واحدة', 'One pan'), tx('مواعين أقل', 'Fewer dishes')),
  Option('batch', '🍲', tx('اطبخ مرة وكُل مرتين', 'Batch cook'), tx('طبخة تكفي يومين', 'Cook once, eat twice')),
  Option('family', '👨‍👩‍👧', tx('مفضلة العيلة', 'Family favorites'), tx('أكلات يحبها الكل', 'Meals everyone loves')),
  Option('comfort', '🥘', tx('أكل البيت', 'Comfort classics'), tx('الأكلات الدسمة المعروفة', 'The hearty standards')),
  Option('fresh', '🥬', tx('طازج وخفيف', 'Fresh & light'), tx('خضار أكثر وأخف', 'More veg, lighter')),
  Option('fiber', '🌾', tx('ألياف عالية', 'Fiber-forward'), tx('بقوليات وحبوب وخضار', 'Beans, grains, greens')),
  Option('takeout', '🍔', tx('أكل مطاعم بالبيت', 'Takeout at home'), tx('زي المطاعم بأقل تكلفة', 'Like takeout, for less')),
];

List<Option> get allergyOptions => [
  Option('gluten', '🌾', tx('القمح والجلوتين', 'Wheat & gluten')),
  Option('dairy', '🥛', tx('الحليب ومشتقاته', 'Milk & dairy')),
  Option('eggs', '🥚', tx('البيض', 'Eggs')),
  Option('nuts', '🥜', tx('المكسرات', 'Nuts')),
  Option('fish', '🐟', tx('السمك', 'Fish')),
  Option('shellfish', '🦐', tx('الجمبري والقشريات', 'Shrimp & shellfish')),
  Option('sesame', '⚪', tx('السمسم', 'Sesame')),
  Option('soy', '🫘', tx('الصويا', 'Soy')),
];

List<Option> get dislikeOptions => [
  Option('fish', '🐟', tx('السمك', 'Fish')),
  Option('seafood', '🦐', tx('المأكولات البحرية', 'Seafood')),
  Option('lamb', '🐑', tx('لحم الغنم', 'Lamb')),
  Option('beef', '🐄', tx('اللحم البقري', 'Beef')),
  Option('liver', '🫀', tx('الكبدة', 'Liver')),
  Option('mushroom', '🍄', tx('المشروم', 'Mushrooms')),
  Option('eggplant', '🍆', tx('الباذنجان', 'Eggplant')),
  Option('okra', '🌱', tx('البامية', 'Okra')),
  Option('coriander', '🌿', tx('الكزبرة', 'Coriander')),
  Option('spicy', '🌶️', tx('الأكل الحار', 'Spicy food')),
];

List<Option> get applianceOptions => [
  Option('oven', '🔥', tx('الفرن', 'Oven')),
  Option('air_fryer', '🍟', tx('القلاية الهوائية', 'Air fryer')),
  Option('microwave', '📡', tx('المايكرويف', 'Microwave')),
  Option('blender', '🌀', tx('الخلاط', 'Blender')),
  Option('pressure_cooker', '♨️', tx('حلة الضغط', 'Pressure cooker')),
];

List<Option> get sideOptions => [
      Option('soup', '🥣', tx('شوربة', 'Soup')),
      Option('salad', '🥗', tx('سلطة', 'Salad')),
      Option('drink', '🥤', tx('مشروب', 'Drink')),
      Option('dessert', '🍰', tx('تحلية', 'Dessert')),
    ];

String optionTitle(List<Option> list, String id) =>
    list.firstWhere((o) => o.id == id, orElse: () => Option(id, '', id)).title;

const meatTags = {'chicken', 'beef', 'lamb', 'fish', 'seafood', 'liver'};
