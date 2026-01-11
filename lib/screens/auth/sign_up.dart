import 'dart:convert';

import 'package:div/screens/auth/sigin_in.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../SERFICES/auth_api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _api = AuthApi();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    final fullName = _name.text.trim();
    final email = _email.text.trim();
    final password = _pass.text.trim();
    final confirm = _confirm.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields".tr())));
      return;
    }

    if (password != confirm) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match".tr())));
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await _api.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      print(data);

      final ok = data["success"] == true;

      if (!ok) {
        final msg = (data["message"] ?? data["error"] ?? "Register failed")
            .toString();
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!".tr())),
      );

      Navigator.pop(context);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data["message"] ??
                    e.response?.data["error"] ??
                    "Request failed")
                .toString()
          : (e.message ?? "Request failed");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Operation failed".tr())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "REGISTER".tr(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 24),
            Icon(Icons.account_circle, size: 80, color: Colors.greenAccent),
            SizedBox(height: 16),
            Text(
              "Create your account".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),

            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Full name".tr(),
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email".tr(),
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _pass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password".tr(),
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),

            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm password".tr(),
                prefixIcon: Icon(Icons.lock_reset_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 24),

            ElevatedButton(
              onPressed: () {
                register(
                  fullName: _name.text,
                  email: _email.text,
                  password: _pass.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ? SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text("Sign up".tr()),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse(
      'http://10.0.2.2:5172/api/auth/registehhhhh@gmail.comr',
    );
    print(uri);

    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "password": password,
      }),
    );
    print("response status code = ${res.statusCode}");
    print("response body = ${res.body}");
    // Try decode JSON (if backend returns json)
    Map<String, dynamic>? data;
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) data = decoded;
    } catch (_) {
      // ignore decode errors
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => First(),));
      // success response
      return data ?? {"success": true};
    }

    // error response: return a normalized map
    return {
      "success": false,
      "statusCode": res.statusCode,
      "message":
          (data?["message"] ??
                  data?["error"] ??
                  data?["title"] ?? // sometimes ASP.NET returns title
                  "Register failed")
              .toString(),
      "raw": res.body,
    };
  }
}
