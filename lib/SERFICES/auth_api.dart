import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio;

  AuthApi({Dio? dio})
      : _dio = dio ??
      Dio(
        BaseOptions(
          baseUrl: "http://192.168.0.51:5172",
          connectTimeout: Duration(seconds: 50),
          receiveTimeout: Duration(seconds: 50),
          headers: {
            "Content-Type": "application/json",
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      "api/auth/register",///http://localhost:5172/api/auth/register
      data: {
        "fullName": fullName,
        "email": email,
        "password": password,
      },
    );
    print(res.data);
    print(res.statusCode);
    return Map<String, dynamic>.from(res.data);
  }

}
