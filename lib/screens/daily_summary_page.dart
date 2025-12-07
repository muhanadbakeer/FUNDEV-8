import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/WeightPage.dart';

class DailySummaryPage extends StatelessWidget {
  DailySummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Today's summary".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale(Locale("ar"));
              } else {
                context.setLocale(Locale("en"));
              }
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Overview".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12),

            // كرت الوزن مع تنقّل لصفحة الوزن
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeightPage(),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.monitor_weight,
                    color: Colors.green,
                  ),
                  title: Text("Weight".tr()),
                  subtitle: Text("Weight: 78 kg • Goal: 70 kg".tr()),
                ),
              ),
            ),

            // باقي الكروت عاديين بدون تنقّل (تقدر نضيف لهم onTap بعدين إذا حاب)
            Card(
              child: ListTile(
                leading: Icon(Icons.local_fire_department),
                title: Text("Calories".tr()),
                subtitle: Text("Calories: 1200 / 1800 kcal".tr()),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.restaurant_menu),
                title: Text("Meal plan".tr()),
                subtitle: Text("Today's meals".tr()),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.directions_run),
                title: Text("Workout".tr()),
                subtitle: Text("Today's workout".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
