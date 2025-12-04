import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "CHAT WITH AI".tr(),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.cyan.shade300,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              var lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale(Locale("ar"));
              } else {
                context.setLocale(Locale("en"));
              }
            },
            icon: Icon((Icons.language)),
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
          IconButton(icon: Icon(Icons.access_alarm_outlined), onPressed: () {}),
        ],
      ),
    );
  }
}
