import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "REGISTER",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
              style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 32),

            // Full Name
            TextField(
              decoration: InputDecoration(
                labelText: "Full name".tr(),
                hintText: "Enter your full name".tr(),
                prefixIcon:  Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
             SizedBox(height: 16),

            // Email
            TextField(
              decoration: InputDecoration(
                labelText: "Email".tr(),
                hintText: "Enter your email".tr(),
                prefixIcon:  Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
             SizedBox(height: 16),

            // Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password".tr(),
                hintText: "Enter your password".tr(),
                prefixIcon:  Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
             SizedBox(height: 16),

            // Confirm Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm password".tr(),
                hintText: "Re-enter your password".tr(),
                prefixIcon:  Icon(Icons.lock_reset_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
             SizedBox(height: 24),

            // Register Button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Account created successfully!".tr()),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
                padding:  EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text("Sign up".tr()),
            ),
             SizedBox(height: 16),

            // Login link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?".tr()),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:  Text(
                    "Login",
                    style: TextStyle(color: Colors.greenAccent),
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
