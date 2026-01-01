import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi({Dio? dio})
      : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: "http://10.0.2.2:5172",
          connectTimeout: Duration(seconds: 15),
          receiveTimeout: Duration(seconds: 15),
          headers: {
            "Content-Type": "application/json",
          },
          // مهم عشان ما يرمي Exception مباشرة
          validateStatus: (status) => status != null && status < 500,
        ),
      );

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      "/api/auth/register",
      data: {
        "fullName": fullName,
        "email": email,
        "password": password,
      },
    );

    return Map<String, dynamic>.from(res.data);
  }

}
