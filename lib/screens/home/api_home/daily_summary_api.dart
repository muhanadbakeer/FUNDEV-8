import 'dart:convert';
import 'package:http/http.dart' as http;

class DailySummaryApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/summary";

  static Future<Map<String, dynamic>> getToday(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/today/$userId"));

    if (res.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(res.body));
    }
    throw Exception("Failed to load daily summary");
  }
}
