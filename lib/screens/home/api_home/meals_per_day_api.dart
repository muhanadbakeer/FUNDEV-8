import 'dart:convert';
import 'package:http/http.dart' as http;

class MealsPerDayApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/meals-per-day";

  static Future<int> getMeals(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));
    if (res.statusCode == 200) {
      return int.tryParse(res.body.toString().replaceAll('"', '')) ?? 3;
    }
    throw Exception("Failed to load meals per day");
  }

  static Future<void> saveMeals(String userId, int meals) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "meals": meals,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save meals per day");
    }
  }
}
