import 'dart:convert';
import 'package:http/http.dart' as http;

class MacrosGoalApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/macros-goal";

  static Future<Map<String, int>> getMacros(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        "p": (data["p"] as num).toInt(),
        "c": (data["c"] as num).toInt(),
        "f": (data["f"] as num).toInt(),
      };
    }
    throw Exception("Failed to load macros");
  }

  static Future<void> saveMacros({
    required String userId,
    required int p,
    required int c,
    required int f,
  }) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "protein": p,
        "carbs": c,
        "fat": f,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save macros");
    }
  }
}
