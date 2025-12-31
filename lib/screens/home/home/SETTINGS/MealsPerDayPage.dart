import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/meals_per_day_api.dart';

class MealsPerDayPage extends StatefulWidget {
  const MealsPerDayPage({super.key});

  @override
  State<MealsPerDayPage> createState() => _MealsPerDayPageState();
}

class _MealsPerDayPageState extends State<MealsPerDayPage> {
  bool loading = true;
  int meals = 3;

  final String userId = "1"; // مؤقت – من Auth لاحقاً

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      meals = await MealsPerDayApi.getMeals(userId);
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await MealsPerDayApi.saveMeals(userId, meals);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.mealsPerDay".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Meals per day",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                  meals > 1 ? () => setState(() => meals--) : null,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text(
                  "$meals",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                IconButton(
                  onPressed:
                  meals < 8 ? () => setState(() => meals++) : null,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                onPressed: _save,
                child: Text(
                  "common.save".tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
