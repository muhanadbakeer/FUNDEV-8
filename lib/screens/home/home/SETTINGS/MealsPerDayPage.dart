import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/settings_store.dart';

class MealsPerDayPage extends StatefulWidget {
  MealsPerDayPage({super.key});

  @override
  State<MealsPerDayPage> createState() => _MealsPerDayPageState();
}

class _MealsPerDayPageState extends State<MealsPerDayPage> {
  bool loading = true;
  int meals = 3;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    meals = await SettingsStore.getMealsPerDay();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await SettingsStore.setMealsPerDay(meals);
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
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Meals per day", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
                IconButton(
                  onPressed: meals > 1 ? () => setState(() => meals--) : null,
                  icon: Icon(Icons.remove_circle_outline),
                ),
                Text("$meals", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                IconButton(
                  onPressed: meals < 8 ? () => setState(() => meals++) : null,
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            Spacer(),
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
