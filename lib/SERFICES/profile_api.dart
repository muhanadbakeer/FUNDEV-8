import '../core/api_client.dart';

class ProfileApi {
  final _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>?> getProfile(int userId) async {
    final res = await _dio.get("/api/profile/$userId");
    if (res.data == null) return null;
    return Map<String, dynamic>.from(res.data);
  }

  Future<Map<String, dynamic>> upsertProfile(int userId, Map<String, dynamic> profile) async {
    final res = await _dio.put("/api/profile/$userId", data: profile);
    return Map<String, dynamic>.from(res.data);
  }
}
