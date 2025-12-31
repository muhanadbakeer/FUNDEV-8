import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi({Dio? dio})
      : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: "http://10.0.2.2:5172",
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {"Content-Type": "application/json"},
        ),
      );

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      "/api/auth/register",
      data: {
        "username": name,
        "email": email,
        "password": password,
      },
    );

    return Map<String, dynamic>.from(res.data);
  }
}
