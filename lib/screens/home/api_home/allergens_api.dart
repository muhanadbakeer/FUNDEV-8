import 'dart:convert';
import 'package:http/http.dart' as http;

class AllergensApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/allergens";

  static Future<List<String>> getAllergens(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load allergens");
    }
  }

  static Future<void> saveAllergens(String userId, List<String> allergens) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "allergens": allergens,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save allergens");
    }
  }
}
