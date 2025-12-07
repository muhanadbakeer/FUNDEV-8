import 'package:div/screens/AppointmentsPage.dart';
import 'package:div/screens/MealPlanPage.dart';
import 'package:div/screens/ProgressPage.dart';
import 'package:div/screens/SettingsPage.dart';
import 'package:div/screens/WeightPage.dart';
import 'package:div/screens/WorkoutPage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'screens/daily_summary_page.dart';

class ListViow extends StatefulWidget {
  ListViow({super.key});

  @override
  State<ListViow> createState() => _ListViowState();
}

class _ListViowState extends State<ListViow> {
  // أقسام الصفحة الرئيسية (نخزن الـ keys فقط ونترجم داخل الـ build)
  final List<Map<String, dynamic>> features = [
    {
      "title": "Weight",
      "subtitle": "Track your weight",
      "icon": Icons.monitor_weight,
    },
    {
      "title": "Meal plan",
      "subtitle": "View your meals",
      "icon": Icons.restaurant_menu,
    },
    {
      "title": "Appointments",
      "subtitle": "Your sessions",
      "icon": Icons.calendar_today,
    },
    {
      "title": "Workout",
      "subtitle": "Daily exercises",
      "icon": Icons.fitness_center,
    },
    {
      "title": "Progress",
      "subtitle": "See your progress",
      "icon": Icons.show_chart,
    },
    {
      "title": "Settings",
      "subtitle": "App settings",
      "icon": Icons.settings,
    },
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "DIV Nutrition".tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 3,
        actions: [
          IconButton(
            onPressed: () {
              String lang = context.locale.languageCode;
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // نص ترحيبي
            Text(
              "Welcome back!".tr(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Here is your daily overview".tr(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),

            SizedBox(height: height * 0.02),

            // كرت ملخص بسيط
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DailySummaryPage(), // صفحة ملخص اليوم
                  ),
                );
              },
              child: Card(
                elevation: 9,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // أيقونة
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.monitor_heart,
                          color: Colors.green,
                          size: 32,
                        ),
                      ),
                      SizedBox(width: 16),
                      // نصوص الملخص
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's summary".tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Weight: 78 kg • Goal: 70 kg".tr(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            Text(
                              "Calories: 1200 / 1800 kcal".tr(),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),


            SizedBox(height: height * 0.03),

            Text(
              "Sections".tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),

            // شبكة الأقسام (Grid)
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: features.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // عمودين
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = features[index];

                return InkWell(
                  onTap: () {
                    // هنا نربط كل عنصر بصفحة معينة
                    String title = item["title"] as String;

                    if (title == "Weight") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WeightPage(),
                        ),
                      );
                    } else if (title == "Meal plan") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealPlanPage(),
                        ),
                      );
                    } else if (title == "Appointments") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppointmentsPage(),
                        ),
                      );
                    } else if (title == "Workout") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutPage(),
                        ),
                      );
                    } else if (title == "Progress") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProgressPage(),
                        ),
                      );
                    } else if (title == "Settings") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.green.withOpacity(0.1),
                            child: Icon(
                              item["icon"] as IconData,
                              color: Colors.green,
                              size: 26,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            (item["title"] as String).tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            (item["subtitle"] as String).tr(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
