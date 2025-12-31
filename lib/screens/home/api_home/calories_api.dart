import 'dart:convert';
import 'package:http/http.dart' as http;

class CaloriesApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/calories";

  static Future<List<Map<String, dynamic>>> getWeekly(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/weekly/$userId"));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    throw Exception("Failed to load weekly calories");
  }
}
