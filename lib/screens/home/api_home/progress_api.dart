import 'dart:convert';
import 'package:http/http.dart' as http;

class ProgressSummaryDto {
  final String userId;
  final double startWeightKg;
  final double currentWeightKg;
  final int periodDays;
  final int averageCaloriesPerDay;

  ProgressSummaryDto({
    required this.userId,
    required this.startWeightKg,
    required this.currentWeightKg,
    required this.periodDays,
    required this.averageCaloriesPerDay,
  });

  double get weightChangeKg => currentWeightKg - startWeightKg;

  factory ProgressSummaryDto.fromJson(Map<String, dynamic> j) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    int _toInt(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return ProgressSummaryDto(
      userId: (j['userId'] ?? '1') as String,
      startWeightKg: _toDouble(j['startWeightKg']),
      currentWeightKg: _toDouble(j['currentWeightKg']),
      periodDays: _toInt(j['periodDays']),
      averageCaloriesPerDay: _toInt(j['averageCaloriesPerDay']),
    );
  }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "startWeightKg": startWeightKg,
    "currentWeightKg": currentWeightKg,
    "periodDays": periodDays,
    "averageCaloriesPerDay": averageCaloriesPerDay,
  };
}

class ProgressApi {
  static const String _baseUrl = "http://10.0.2.2:5172/api";

  static Future<ProgressSummaryDto> getSummary(String userId) async {
    final res = await http.get(Uri.parse("$_baseUrl/Progress/$userId"));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Get progress failed: ${res.statusCode}");
    }
    return ProgressSummaryDto.fromJson(jsonDecode(res.body));
  }

  static Future<ProgressSummaryDto> saveSummary(ProgressSummaryDto dto) async {
    final res = await http.post(
      Uri.parse("$_baseUrl/Progress/save"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(dto.toJson()),
    );
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Save progress failed: ${res.statusCode}");
    }
    return ProgressSummaryDto.fromJson(jsonDecode(res.body));
  }
}
