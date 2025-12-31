import 'dart:convert';
import 'package:http/http.dart' as http;

class InfoApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/info";

  static Future<Map<String, String>> getInfo(String key) async {
    final res = await http.get(Uri.parse("$baseUrl/$key"));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        "title": data["title"],
        "description": data["description"],
      };
    } else {
      throw Exception("Failed to load info");
    }
  }
}
