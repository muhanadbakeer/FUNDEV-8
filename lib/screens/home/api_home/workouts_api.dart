import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkoutItemDto {
  final String title;
  final String subtitle;
  final String icon;

  WorkoutItemDto({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  factory WorkoutItemDto.fromJson(Map<String, dynamic> j) => WorkoutItemDto(
    title: (j["title"] ?? "").toString(),
    subtitle: (j["subtitle"] ?? "").toString(),
    icon: (j["icon"] ?? "walk").toString(),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "subtitle": subtitle,
    "icon": icon,
  };
}

class WorkoutDayDto {
  final String userId;
  final DateTime workoutDate;
  final List<WorkoutItemDto> items;
  final String? notes;

  WorkoutDayDto({
    required this.userId,
    required this.workoutDate,
    required this.items,
    required this.notes,
  });

  factory WorkoutDayDto.fromJson(Map<String, dynamic> j) {
    final List items = (j["items"] as List? ?? []);
    return WorkoutDayDto(
      userId: (j["userId"] ?? "1").toString(),
      workoutDate: DateTime.parse(j["workoutDate"]),
      items: items.map((e) => WorkoutItemDto.fromJson(e)).toList(),
      notes: j["notes"]?.toString(),
    );
  }
}

class WorkoutsApi {
  static const String _baseUrl = "http://10.0.2.2:5000/api";

  static Future<WorkoutDayDto> getDay({
    required String userId,
    required DateTime date,
  }) async {
    final d = "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";

    final uri = Uri.parse("$_baseUrl/Workouts/day?userId=$userId&date=$d");
    final res = await http.get(uri);

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Get workout day failed: ${res.statusCode}");
    }

    return WorkoutDayDto.fromJson(jsonDecode(res.body));
  }

  static Future<void> saveDay({
    required String userId,
    required DateTime date,
    required List<WorkoutItemDto> items,
    required String notes,
  }) async {
    final body = {
      "userId": userId,
      "workoutDate": date.toIso8601String(),
      "items": items.map((e) => e.toJson()).toList(),
      "notes": notes,
    };

    final res = await http.post(
      Uri.parse("$_baseUrl/Workouts/save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Save workout failed: ${res.statusCode}");
    }
  }
}
