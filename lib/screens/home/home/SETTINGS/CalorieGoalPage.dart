import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class CalorieGoalPage extends StatefulWidget {
  CalorieGoalPage({super.key});

  @override
  State<CalorieGoalPage> createState() => _CalorieGoalPageState();
}

class _CalorieGoalPageState extends State<CalorieGoalPage> {
  final TextEditingController c = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final v = await SettingsStore.getCaloriesGoal();
    c.text = v.toString();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    final v = int.tryParse(c.text.trim());
    if (v == null || v < 500 || v > 8000) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("settings.invalidNumber".tr())));
      return;
    }
    await SettingsStore.setCaloriesGoal(v);
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
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "settings.calorieGoal".tr(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _save,
                child: Text("common.save".tr(), style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
