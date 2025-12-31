import 'dart:convert';
import 'package:http/http.dart' as http;

class FavoriteCuisinesApi {
  static const String baseUrl =
      "http://10.0.2.2:5172/api/favorite-cuisines";

  static Future<List<String>> getCuisines(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => e.toString()).toList();
    } else {
      throw Exception("Failed to load cuisines");
    }
  }

  static Future<void> saveCuisines(String userId, List<String> cuisines) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "cuisines": cuisines,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save cuisines");
    }
  }
}
