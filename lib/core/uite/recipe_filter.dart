import 'dart:convert';

class RecipeFiltersSelection {
  final Set<String> mealTimes;
  final Set<String> includeIngredients;
  final Set<String> cuisines;
  final Set<String> diets;
  final Set<String> excludeIngredients;
  final int? maxCookMinutes;
  final Set<String> foodExclusions;
  final Set<String> medicalDiets;

  RecipeFiltersSelection({
    Set<String>? mealTimes,
    Set<String>? includeIngredients,
    Set<String>? cuisines,
    Set<String>? diets,
    Set<String>? excludeIngredients,
    this.maxCookMinutes,
    Set<String>? foodExclusions,
    Set<String>? medicalDiets,
  })  : mealTimes = mealTimes ?? <String>{},
        includeIngredients = includeIngredients ?? <String>{},
        cuisines = cuisines ?? <String>{},
        diets = diets ?? <String>{},
        excludeIngredients = excludeIngredients ?? <String>{},
        foodExclusions = foodExclusions ?? <String>{},
        medicalDiets = medicalDiets ?? <String>{};

  RecipeFiltersSelection copyWith({
    Set<String>? mealTimes,
    Set<String>? includeIngredients,
    Set<String>? cuisines,
    Set<String>? diets,
    Set<String>? excludeIngredients,
    int? maxCookMinutes,
    Set<String>? foodExclusions,
    Set<String>? medicalDiets,
    bool clearCookTime = false,
  }) {
    return RecipeFiltersSelection(
      mealTimes: mealTimes ?? this.mealTimes,
      includeIngredients: includeIngredients ?? this.includeIngredients,
      cuisines: cuisines ?? this.cuisines,
      diets: diets ?? this.diets,
      excludeIngredients: excludeIngredients ?? this.excludeIngredients,
      maxCookMinutes: clearCookTime ? null : (maxCookMinutes ?? this.maxCookMinutes),
      foodExclusions: foodExclusions ?? this.foodExclusions,
      medicalDiets: medicalDiets ?? this.medicalDiets,
    );
  }

  int get selectedCount =>
      mealTimes.length +
          includeIngredients.length +
          cuisines.length +
          diets.length +
          excludeIngredients.length +
          (maxCookMinutes == null ? 0 : 1) +
          foodExclusions.length +
          medicalDiets.length;

  RecipeFiltersSelection cleared() => RecipeFiltersSelection();

  Map<String, dynamic> toMap() {
    return {
      "mealTimes": mealTimes.toList(),
      "includeIngredients": includeIngredients.toList(),
      "cuisines": cuisines.toList(),
      "diets": diets.toList(),
      "excludeIngredients": excludeIngredients.toList(),
      "maxCookMinutes": maxCookMinutes,
      "foodExclusions": foodExclusions.toList(),
      "medicalDiets": medicalDiets.toList(),
    };
  }

  String toJson() => jsonEncode(toMap());

  static RecipeFiltersSelection fromMap(Map<String, dynamic> map) {
    return RecipeFiltersSelection(
      mealTimes: Set<String>.from((map["mealTimes"] ?? []) as List),
      includeIngredients: Set<String>.from((map["includeIngredients"] ?? []) as List),
      cuisines: Set<String>.from((map["cuisines"] ?? []) as List),
      diets: Set<String>.from((map["diets"] ?? []) as List),
      excludeIngredients: Set<String>.from((map["excludeIngredients"] ?? []) as List),
      maxCookMinutes: map["maxCookMinutes"] == null ? null : (map["maxCookMinutes"] as num).toInt(),
      foodExclusions: Set<String>.from((map["foodExclusions"] ?? []) as List),
      medicalDiets: Set<String>.from((map["medicalDiets"] ?? []) as List),
    );
  }

  static RecipeFiltersSelection fromJson(String? json) {
    if (json == null || json.trim().isEmpty) return RecipeFiltersSelection();
    final map = jsonDecode(json) as Map<String, dynamic>;
    return fromMap(map);
  }
}
