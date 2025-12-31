import 'dart:convert';
import 'package:http/http.dart' as http;

class MealPrioritiesApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/meal-priorities";

  static Future<List<String>> getPriorities(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load meal priorities");
    }
  }

  static Future<void> savePriorities(String userId, List<String> priorities) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "priorities": priorities,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save meal priorities");
    }
  }
}
