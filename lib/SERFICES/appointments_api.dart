import '../core/api_client.dart';

class AppointmentsApi {
  final _dio = ApiClient.instance.dio;

  Future<List<Map<String, dynamic>>> getAll(int userId) async {
    final res = await _dio.get("/api/appointments/$userId");
    return List<Map<String, dynamic>>.from(res.data);
  }

  Future<Map<String, dynamic>> add(int userId, Map<String, dynamic> body) async {
    final res = await _dio.post("/api/appointments/$userId", data: body);
    return Map<String, dynamic>.from(res.data);
  }

  Future<void> delete(int id) async {
    await _dio.delete("/api/appointments/$id");
  }
}
