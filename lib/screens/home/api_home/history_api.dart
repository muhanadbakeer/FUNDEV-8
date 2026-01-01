import 'dart:convert';
import 'package:http/http.dart' as http;

class HistoryApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/history";

  static Future<Map<String, dynamic>> getDay({
    required String userId,
    required String date,
  }) async {
    final uri = Uri.parse("$baseUrl/$userId?date=$date");
    final res = await http.get(uri);

    if (res.statusCode == 200) {
      return Map<String, dynamic>.from(jsonDecode(res.body));
    }
    throw Exception("Failed to load history");
  }
}
