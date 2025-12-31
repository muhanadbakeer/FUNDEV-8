import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/calorie_goal_api.dart';

class CalorieGoalPage extends StatefulWidget {
  const CalorieGoalPage({super.key});

  @override
  State<CalorieGoalPage> createState() => _CalorieGoalPageState();
}

class _CalorieGoalPageState extends State<CalorieGoalPage> {
  final TextEditingController c = TextEditingController();
  bool loading = true;

  final String userId = "1"; // مؤقت – من Auth لاحقًا

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final v = await CalorieGoalApi.getGoal(userId);
      c.text = v.toString();
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    final v = int.tryParse(c.text.trim());
    if (v == null || v < 500 || v > 8000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("settings.invalidNumber".tr())),
      );
      return;
    }

    await CalorieGoalApi.saveGoal(userId, v);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.calorieGoal".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "settings.calorieGoal".tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
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
