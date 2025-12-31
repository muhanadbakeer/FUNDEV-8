import 'dart:convert';
import 'package:http/http.dart' as http;

class DietPreferenceApi {
  static const String baseUrl =
      "http://10.0.2.2:5172/api/diet-preference";

  static Future<String> getPreference(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      return res.body.replaceAll('"', '');
    } else {
      throw Exception("Failed to load diet preference");
    }
  }

  static Future<void> savePreference(String userId, String preference) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "preference": preference,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save diet preference");
    }
  }
}
