import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/WeightPage.dart';
import 'package:div/screens/home/CaloriesPage.dart';

import 'MealPlanPage.dart';
import 'WorkoutPage.dart';

import 'package:div/screens/home/api_home/daily_summary_api.dart';

class DailySummaryPage extends StatefulWidget {
  const DailySummaryPage({super.key});

  @override
  State<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends State<DailySummaryPage> {
  final String userId = "1"; // مؤقت – من Auth لاحقاً

  bool loading = true;

  double currentWeight = 78;
  double goalWeight = 70;

  int caloriesConsumed = 1200;
  int caloriesGoal = 1800;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await DailySummaryApi.getToday(userId);

      final w = Map<String, dynamic>.from(data["weight"]);
      final c = Map<String, dynamic>.from(data["calories"]);

      currentWeight = (w["current"] as num).toDouble();
      goalWeight = (w["goal"] as num).toDouble();

      caloriesConsumed = (c["consumed"] as num).toInt();
      caloriesGoal = (c["goal"] as num).toInt();
    } catch (_) {
      // خلي default values
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

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
                context.setLocale(const Locale("ar"));
              } else {
                context.setLocale(const Locale("en"));
              }
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              "Overview".tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

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
                  leading: const Icon(Icons.monitor_weight, color: Colors.green),
                  title: Text("Weight".tr()),
                  subtitle: Text("Weight: $currentWeight kg • Goal: $goalWeight kg".tr()),
                ),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesPage(),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.local_fire_department, color: Colors.green),
                  title: Text("Calories".tr()),
                  subtitle: Text("Calories: $caloriesConsumed / $caloriesGoal kcal".tr()),
                ),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MealPlanIntroPage(),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.restaurant_menu, color: Colors.green),
                  title: Text("Meal plan".tr()),
                  subtitle: Text("Today's meals".tr()),
                ),
              ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkoutPage(),
                  ),
                );
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_run, color: Colors.green),
                  title: Text("Workout".tr()),
                  subtitle: Text("Today's workout".tr()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
