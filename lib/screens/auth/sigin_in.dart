import 'package:div/screens/home/Home_div.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../core/uite/sherd.dart';
import 'sign_up.dart';

class First extends StatefulWidget {
  const First({super.key});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        foregroundColor: Colors.green,
        title: Text(
          "WELCOME TO DIV".tr(),
          style:  TextStyle(fontWeight: FontWeight.w700),
        ),
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
      body: Center(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Card(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding:  EdgeInsets.all(20.0),
              child: SizedBox(
                width: width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.9),
                            Colors.greenAccent.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child:  Icon(
                        Icons.spa,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Text(
                      "DIV Nutrition".tr(),
                      style:  TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      "Track your health & nutrition".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(height: height * 0.04),


                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email".tr(),
                        hintText: "Enter your email".tr(),
                        prefixIcon:  Icon(Icons.email_outlined),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding:  EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.02),


                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password".tr(),
                        hintText: "Enter your password".tr(),
                        prefixIcon:  Icon(Icons.lock_outline),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        contentPadding:  EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.015),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: Colors.green,
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value ?? false;
                            });
                          },
                        ),
                        Text("remember me".tr()),
                      ],
                    ),

                    SizedBox(height: height * 0.015),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await sherd.saveBoolian("isRemember", isChecked);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeDiv(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:  EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: Text(
                          "Login".tr(),
                          style:  TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.03),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?".tr(),
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                         SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child:  Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),


                    SizedBox(height: height * 0.01),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
