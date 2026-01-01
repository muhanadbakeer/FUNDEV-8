import 'dart:convert';
import 'package:http/http.dart' as http;

class MealPlanDto {
  final int id;
  final String userId;
  final String createdAt;
  final String title;
  final String description;

  MealPlanDto({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.title,
    required this.description,
  });

  factory MealPlanDto.fromJson(Map<String, dynamic> json) {
    return MealPlanDto(
      id: (json['id'] ?? 0) as int,
      userId: (json['userId'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      title: (json['title'] ?? 'Meal Plan') as String,
      description: (json['description'] ?? '') as String,
    );
  }
}

class MealPlanApi {
  static const String _baseUrl = "http://10.0.2.2:5172/api";

  static Future<MealPlanDto?> getCurrent(String userId) async {
    final res = await http.get(Uri.parse("$_baseUrl/mealplan/current/$userId"));

    if (res.statusCode == 404) return null;

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Get current meal plan failed: ${res.statusCode}");
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return MealPlanDto.fromJson(data);
  }

  static Future<MealPlanDto> create(String userId) async {
    final res = await http.post(
      Uri.parse("$_baseUrl/mealplan/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId}),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Create meal plan failed: ${res.statusCode}");
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return MealPlanDto.fromJson(data);
  }
}
