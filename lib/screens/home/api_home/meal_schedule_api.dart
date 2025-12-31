import 'dart:convert';
import 'package:http/http.dart' as http;

class MealScheduleApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/meal-schedule";

  static Future<String> getSchedule(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      return res.body.replaceAll('"', '');
    } else {
      throw Exception("Failed to load meal schedule");
    }
  }

  static Future<void> saveSchedule(String userId, String schedule) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "schedule": schedule,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save meal schedule");
    }
  }
}
