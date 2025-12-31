import 'dart:convert';
import 'package:http/http.dart' as http;

class UnitsApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/units";

  static Future<String> getUnits(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));

    if (res.statusCode == 200) {
      return res.body.replaceAll('"', '');
    } else {
      throw Exception("Failed to load units");
    }
  }

  static Future<void> saveUnits(String userId, String units) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "units": units,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to save units");
    }
  }
}
