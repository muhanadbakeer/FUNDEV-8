import 'dart:convert';
import 'package:http/http.dart' as http;

class CalorieGoalApi {
  static const String baseUrl =
      "http://10.0.2.2:5172/api/calorie-goal";

  static Future<int> getGoal(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      return int.tryParse(res.body.toString()) ?? 0;
    } else {
      throw Exception("Failed to load calorie goal");
    }
  }

  static Future<void> saveGoal(String userId, int calories) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "calories": calories,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save calorie goal");
    }
  }
}
