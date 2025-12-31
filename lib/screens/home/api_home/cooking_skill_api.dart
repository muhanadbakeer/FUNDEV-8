import 'dart:convert';
import 'package:http/http.dart' as http;

class CookingSkillApi {
  static const String baseUrl =
      "http://10.0.2.2:5172/api/cooking-skill";

  static Future<String> getSkill(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      return res.body.replaceAll('"', ''); // لو رجع سترنغ مع quotes
    } else {
      throw Exception("Failed to load cooking skill");
    }
  }

  static Future<void> saveSkill(String userId, String skill) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "skill": skill,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save cooking skill");
    }
  }
}
