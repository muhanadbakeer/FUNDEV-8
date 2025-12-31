import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationSettingsDto {
  final String userId;
  bool pushEnabled;
  bool mealReminders;
  bool workoutReminders;
  bool waterReminders;
  bool weeklyReport;
  bool sound;
  bool vibration;

  NotificationSettingsDto({
    required this.userId,
    required this.pushEnabled,
    required this.mealReminders,
    required this.workoutReminders,
    required this.waterReminders,
    required this.weeklyReport,
    required this.sound,
    required this.vibration,
  });

  factory NotificationSettingsDto.fromJson(Map<String, dynamic> j) {
    return NotificationSettingsDto(
      userId: (j['userId'] ?? '1') as String,
      pushEnabled: (j['pushEnabled'] ?? true) as bool,
      mealReminders: (j['mealReminders'] ?? true) as bool,
      workoutReminders: (j['workoutReminders'] ?? false) as bool,
      waterReminders: (j['waterReminders'] ?? true) as bool,
      weeklyReport: (j['weeklyReport'] ?? true) as bool,
      sound: (j['sound'] ?? true) as bool,
      vibration: (j['vibration'] ?? true) as bool,
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "pushEnabled": pushEnabled,
    "mealReminders": mealReminders,
    "workoutReminders": workoutReminders,
    "waterReminders": waterReminders,
    "weeklyReport": weeklyReport,
    "sound": sound,
    "vibration": vibration,
  };
}

class NotificationsApi {
  static const String _baseUrl = "http://10.0.2.2:5172/api";

  static Future<NotificationSettingsDto> getSettings(String userId) async {
    final res = await http.get(Uri.parse("$_baseUrl/NotificationSettings/$userId"));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Get settings failed: ${res.statusCode}");
    }
    return NotificationSettingsDto.fromJson(jsonDecode(res.body));
  }

  static Future<NotificationSettingsDto> saveSettings(NotificationSettingsDto dto) async {
    final res = await http.post(
      Uri.parse("$_baseUrl/NotificationSettings/save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Save settings failed: ${res.statusCode}");
    }
    return NotificationSettingsDto.fromJson(jsonDecode(res.body));
  }
}
