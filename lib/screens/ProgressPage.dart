import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ProgressPage extends StatelessWidget {
   ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
            tooltip: "Change language",
          ),
        ],

      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Overview".tr(),
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 12),
            Card(
              child: ListTile(
                leading:  Icon(Icons.monitor_weight),
                title: Text("Weight change".tr()),
                subtitle: Text("-2.0 kg in 2 weeks".tr()),
              ),
            ),
            Card(
              child: ListTile(
                leading:  Icon(Icons.local_fire_department),
                title: Text("Average calories".tr()),
                subtitle: Text("1500 kcal / day".tr()),
              ),
            ),
             SizedBox(height: 16),
            Text(
              "Notes".tr(),
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
             SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  "Charts and detailed progress can be shown here".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
