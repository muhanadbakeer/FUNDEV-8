import 'dart:convert';
import 'package:http/http.dart' as http;

class LanguageApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/language";

  static Future<String> getLanguage(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));
    if (res.statusCode == 200) {
      return res.body.replaceAll('"', '');
    }
    throw Exception("Failed to load language");
  }

  static Future<void> saveLanguage(String userId, String languageCode) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "languageCode": languageCode,
      }),
    );
    if (res.statusCode != 200) {
      throw Exception("Failed to save language");
    }
  }
}
