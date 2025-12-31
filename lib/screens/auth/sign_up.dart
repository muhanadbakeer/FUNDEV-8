import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
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
    final name = _name.text.trim();
    final email = _email.text.trim();
    final pass = _pass.text.trim();
    final confirm = _confirm.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields".tr())),
      );
      return;
    }

    if (pass != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match".tr())),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final data = await _api.register(name: name, email: email, password: pass);

      final ok = (data["result"] == true) || (data["success"] == true);

      if (!ok) {
        final msg = (data["message"] ?? data["error"] ?? "Register failed").toString();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
        return;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!".tr())),
      );

      Navigator.pop(context);
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response?.data["message"] ?? e.response?.data["error"] ?? "Request failed").toString()
          : (e.message ?? "Request failed");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Operation failed".tr())),
      );
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
          style:  TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale( Locale("ar"));
              } else {
                context.setLocale( Locale("en"));
              }
            },
            icon:  Icon(Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             SizedBox(height: 24),
             Icon(Icons.account_circle, size: 80, color: Colors.greenAccent),
             SizedBox(height: 16),
            Text(
              "Create your account".tr(),
              textAlign: TextAlign.center,
              style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 32),

            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Full name".tr(),
                hintText: "Enter your full name".tr(),
                prefixIcon:  Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
             SizedBox(height: 16),

            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email".tr(),
                hintText: "Enter your email".tr(),
                prefixIcon:  Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
             SizedBox(height: 16),

            TextField(
              controller: _pass,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password".tr(),
                hintText: "Enter your password".tr(),
                prefixIcon:  Icon(Icons.lock_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
             SizedBox(height: 16),

            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm password".tr(),
                hintText: "Re-enter your password".tr(),
                prefixIcon:  Icon(Icons.lock_reset_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
             SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading ? null : _doRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding:  EdgeInsets.symmetric(vertical: 14),
              ),
              child: isLoading
                  ?  SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Text("Sign up".tr()),
            ),
             SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?".tr()),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Login".tr(),
                    style:  TextStyle(color: Colors.greenAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
