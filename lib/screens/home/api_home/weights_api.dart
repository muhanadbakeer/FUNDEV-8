import 'dart:convert';
import 'package:http/http.dart' as http;

class WeightSummaryDto {
  final double currentWeightKg;
  final DateTime? lastUpdatedAt;

  WeightSummaryDto({
    required this.currentWeightKg,
    required this.lastUpdatedAt,
  });

  factory WeightSummaryDto.fromJson(Map<String, dynamic> j) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    DateTime? _toDate(dynamic v) {
      if (v == null) return null;
      return DateTime.tryParse(v.toString());
    }

    return WeightSummaryDto(
      currentWeightKg: _toDouble(j["currentWeightKg"]),
      lastUpdatedAt: _toDate(j["lastUpdatedAt"]),
    );
  }
}

class WeightItemDto {
  final int id;
  final double weightKg;
  final DateTime createdAt;

  WeightItemDto({
    required this.id,
    required this.weightKg,
    required this.createdAt,
  });

  factory WeightItemDto.fromJson(Map<String, dynamic> j) {
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

    return WeightItemDto(
      id: _toInt(j["id"]),
      weightKg: _toDouble(j["weightKg"]),
      createdAt: DateTime.parse(j["createdAt"]),
    );
  }
}

class WeightsApi {
  static const String _baseUrl = "http://10.0.2.2:5172/api";

  static Future<WeightSummaryDto> getSummary(String userId) async {
    final res = await http.get(Uri.parse("$_baseUrl/Weights/summary/$userId"));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Get summary failed: ${res.statusCode}");
    }
    return WeightSummaryDto.fromJson(jsonDecode(res.body));
  }

  static Future<List<WeightItemDto>> getList(String userId, {int take = 30}) async {
    final res = await http.get(Uri.parse("$_baseUrl/Weights/list/$userId?take=$take"));
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Get list failed: ${res.statusCode}");
    }
    final List data = jsonDecode(res.body);
    return data.map((e) => WeightItemDto.fromJson(e)).toList();
  }

  static Future<WeightItemDto> addWeight({
    required String userId,
    required double weightKg,
  }) async {
    final res = await http.post(
      Uri.parse("$_baseUrl/Weights/add"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"userId": userId, "weightKg": weightKg}),
    );

    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception("Add weight failed: ${res.statusCode}");
    }

    return WeightItemDto.fromJson(jsonDecode(res.body));
  }
}
