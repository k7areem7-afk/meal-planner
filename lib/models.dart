// Data models for سفرة.

List<String> _strList(dynamic v) =>
    v == null ? <String>[] : (v as List).map((e) => e.toString()).toList();

double _d(dynamic v) => v == null ? 0 : (v as num).toDouble();

class Named {
  final String id;
  final String name;
  const Named(this.id, this.name);
  factory Named.fromJson(Map<String, dynamic> j) =>
      Named(j['id'] as String, j['name'] as String);
}

class Store {
  final String id;
  final String name;
  final double factor;
  const Store(this.id, this.name, this.factor);
  factory Store.fromJson(Map<String, dynamic> j) =>
      Store(j['id'] as String, j['name'] as String, _d(j['factor']));
}

class Ingredient {
  final String id;
  final String name;
  final String aisle;
  final String unit; // g | ml | pc
  final double pack;
  final double price;
  final String? pcName;
  final double? pcWeight;
  final double density;
  final List<String> allergens;
  final List<String> tags;
  final bool pantry;
  final String emoji;
  final List<double> nutr; // kcal, protein, carbs, fat per 100 g/ml

  const Ingredient({
    required this.id,
    required this.name,
    required this.aisle,
    required this.unit,
    required this.pack,
    required this.price,
    this.pcName,
    this.pcWeight,
    required this.density,
    required this.allergens,
    required this.tags,
    required this.pantry,
    required this.emoji,
    required this.nutr,
  });

  bool get isSpice => aisle == 'spices' || id == 'salt';

  factory Ingredient.fromJson(Map<String, dynamic> j) => Ingredient(
        id: j['id'] as String,
        name: j['name'] as String,
        aisle: j['aisle'] as String,
        unit: j['unit'] as String,
        pack: _d(j['pack']),
        price: _d(j['price']),
        pcName: j['pcName'] as String?,
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
  final String title;
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
  final bool user; // made by the user or by AI

  const Recipe({
    required this.id,
    required this.title,
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
    this.user = false,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) {
    final n = (j['nutrition'] as Map).cast<String, dynamic>();
    return Recipe(
      id: j['id'] as String,
      title: j['title'] as String,
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
      user: j['user'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
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
        fridge = fridge ?? <String>{};

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

  PlannedMeal({
    required this.day,
    required this.slot,
    required this.recipeId,
    required this.servings,
    this.locked = false,
    this.leftover = false,
  });

  PlannedMeal copy() => PlannedMeal(
      day: day,
      slot: slot,
      recipeId: recipeId,
      servings: servings,
      locked: locked,
      leftover: leftover);

  Map<String, dynamic> toJson() => {
        'day': day,
        'slot': slot,
        'recipeId': recipeId,
        'servings': servings,
        'locked': locked,
        'leftover': leftover,
      };

  factory PlannedMeal.fromJson(Map<String, dynamic> j) => PlannedMeal(
        day: (j['day'] as num).toInt(),
        slot: j['slot'] as String,
        recipeId: j['recipeId'] as String,
        servings: (j['servings'] as num).toInt(),
        locked: j['locked'] == true,
        leftover: j['leftover'] == true,
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

const slotNames = {'b': 'الفطور', 'l': 'الغداء', 'd': 'العشاء'};
const slotOrder = ['b', 'l', 'd'];

const dietOptions = [
  Option('vegetarian', '🥦', 'نباتي', 'بدون لحوم ولا سمك'),
  Option('vegan', '🌱', 'نباتي صرف', 'بدون أي منتج حيواني'),
  Option('pescatarian', '🐟', 'سمك بدون لحوم', 'سمك وبحريات، بدون لحوم'),
  Option('keto', '🔥', 'كيتو', 'كارب قليل جداً'),
  Option('high_protein', '💪', 'بروتين عالي', 'وجبات غنية بالبروتين'),
  Option('glp1', '🎯', 'حصص خفيفة', 'سعرات أقل وبروتين كويس'),
  Option('anti_inflammatory', '💧', 'مضاد للالتهاب', 'أكل طبيعي بدون مقلي ولا مصنّع'),
  Option('mediterranean', '🫒', 'متوسطي', 'خضار وسمك وزيت زيتون'),
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
const styleSub = {
  'saudi': 'كبسة، مندي، جريش',
  'egyptian': 'محاشي، كشري، مكرونات',
  'levant': 'مقلوبة، فتة، شاورما',
  'italian': 'باستا، طماطم، أعشاب',
  'asian': 'كاري، نودلز، صويا',
  'indian': 'برياني، كاري، عدس',
  'mexican': 'تاكو، فاهيتا، فاصوليا',
  'healthy': 'خفيف ومتوازن',
  'western': 'برجر، مشويات، شوربات',
};

const vibeOptions = [
  Option('quick', '⚡', 'سريع وسهل', 'جاهز في حوالي 20 دقيقة'),
  Option('one_pan', '🍳', 'طاسة واحدة', 'مواعين أقل'),
  Option('batch', '🍲', 'اطبخ مرة وكُل مرتين', 'طبخة تكفي يومين'),
  Option('family', '👨‍👩‍👧', 'مفضلة العيلة', 'أكلات يحبها الكل'),
  Option('comfort', '🥘', 'أكل البيت', 'الأكلات الدسمة المعروفة'),
  Option('fresh', '🥬', 'طازج وخفيف', 'خضار أكثر وأخف'),
  Option('fiber', '🌾', 'ألياف عالية', 'بقوليات وحبوب وخضار'),
  Option('takeout', '🍔', 'أكل مطاعم بالبيت', 'زي المطاعم بأقل تكلفة'),
];

const allergyOptions = [
  Option('gluten', '🌾', 'القمح والجلوتين'),
  Option('dairy', '🥛', 'الحليب ومشتقاته'),
  Option('eggs', '🥚', 'البيض'),
  Option('nuts', '🥜', 'المكسرات'),
  Option('fish', '🐟', 'السمك'),
  Option('shellfish', '🦐', 'الجمبري والقشريات'),
  Option('sesame', '⚪', 'السمسم'),
  Option('soy', '🫘', 'الصويا'),
];

const dislikeOptions = [
  Option('fish', '🐟', 'السمك'),
  Option('seafood', '🦐', 'المأكولات البحرية'),
  Option('lamb', '🐑', 'لحم الغنم'),
  Option('beef', '🐄', 'اللحم البقري'),
  Option('liver', '🫀', 'الكبدة'),
  Option('mushroom', '🍄', 'المشروم'),
  Option('eggplant', '🍆', 'الباذنجان'),
  Option('okra', '🌱', 'البامية'),
  Option('coriander', '🌿', 'الكزبرة'),
  Option('spicy', '🌶️', 'الأكل الحار'),
];

const applianceOptions = [
  Option('oven', '🔥', 'الفرن'),
  Option('air_fryer', '🍟', 'القلاية الهوائية'),
  Option('microwave', '📡', 'المايكرويف'),
  Option('blender', '🌀', 'الخلاط'),
  Option('pressure_cooker', '♨️', 'حلة الضغط'),
];

String optionTitle(List<Option> list, String id) =>
    list.firstWhere((o) => o.id == id, orElse: () => Option(id, '', id)).title;

const meatTags = {'chicken', 'beef', 'lamb', 'fish', 'seafood', 'liver'};
