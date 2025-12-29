import 'package:shared_preferences/shared_preferences.dart';

class SettingsStore {
  static const _kCalories = "calories_goal";
  static const _kMacroP = "macro_p";
  static const _kMacroC = "macro_c";
  static const _kMacroF = "macro_f";
  static const _kDiet = "diet_pref";
  static const _kAllergens = "allergens";
  static const _kCuisines = "cuisines";
  static const _kSkill = "cooking_skill";
  static const _kMealsPerDay = "meals_per_day";
  static const _kUnits = "units";
  static const _kMealSchedule = "meal_schedule";
  static const _kMealPriorities = "meal_priorities";

  static const int defaultCalories = 2525;
  static const int defaultP = 25;
  static const int defaultC = 55;
  static const int defaultF = 20;
  static const String defaultDiet = "Low Carb";
  static const String defaultSkill = "Beginner";
  static const int defaultMealsPerDay = 3;
  static const String defaultUnits = "Metric"; // Metric / Imperial

  static Future<int> getCaloriesGoal() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kCalories) ?? defaultCalories;
  }

  static Future<void> setCaloriesGoal(int v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kCalories, v);
  }

  static Future<Map<String, int>> getMacros() async {
    final sp = await SharedPreferences.getInstance();
    return {
      "p": sp.getInt(_kMacroP) ?? defaultP,
      "c": sp.getInt(_kMacroC) ?? defaultC,
      "f": sp.getInt(_kMacroF) ?? defaultF,
    };
  }

  static Future<void> setMacros({required int p, required int c, required int f}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kMacroP, p);
    await sp.setInt(_kMacroC, c);
    await sp.setInt(_kMacroF, f);
  }

  static Future<String> getDietPreference() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kDiet) ?? defaultDiet;
  }

  static Future<void> setDietPreference(String v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kDiet, v);
  }

  static Future<List<String>> getAllergens() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_kAllergens) ?? <String>[];
  }

  static Future<void> setAllergens(List<String> v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kAllergens, v);
  }

  static Future<List<String>> getCuisines() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_kCuisines) ?? <String>[];
  }

  static Future<void> setCuisines(List<String> v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kCuisines, v);
  }

  static Future<String> getCookingSkill() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kSkill) ?? defaultSkill;
  }

  static Future<void> setCookingSkill(String v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kSkill, v);
  }

  static Future<int> getMealsPerDay() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(_kMealsPerDay) ?? defaultMealsPerDay;
  }

  static Future<void> setMealsPerDay(int v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setInt(_kMealsPerDay, v);
  }

  static Future<String> getUnits() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kUnits) ?? defaultUnits;
  }

  static Future<void> setUnits(String v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kUnits, v);
  }

  static Future<String> getMealSchedule() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kMealSchedule) ?? "Default";
  }

  static Future<void> setMealSchedule(String v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kMealSchedule, v);
  }

  static Future<List<String>> getMealPriorities() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_kMealPriorities) ?? <String>["Balanced"];
  }

  static Future<void> setMealPriorities(List<String> v) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_kMealPriorities, v);
  }
}
