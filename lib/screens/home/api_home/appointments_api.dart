import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentsApi {
  static const String baseUrl = "http://10.0.2.2:5172/api/appointments";

  static Future<List<Map<String, dynamic>>> getAll(String userId) async {
    final res = await http.get(Uri.parse("$baseUrl/$userId"));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    throw Exception("Failed to load appointments");
  }

  static Future<void> create({
    required String userId,
    required String title,
    required String date,
    required String time,
    String? note,
  }) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "title": title,
        "date": date,
        "time": time,
        "note": note ?? "",
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to create appointment");
    }
  }

  static Future<void> delete(int id) async {
    final res = await http.delete(Uri.parse("$baseUrl/$id"));
    if (res.statusCode != 200) {
      throw Exception("Failed to delete appointment");
    }
  }
}
