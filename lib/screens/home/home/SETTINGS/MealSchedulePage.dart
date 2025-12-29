import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/settings_store.dart';

class MealSchedulePage extends StatefulWidget {
  MealSchedulePage({super.key});

  @override
  State<MealSchedulePage> createState() => _MealSchedulePageState();
}

class _MealSchedulePageState extends State<MealSchedulePage> {
  bool loading = true;
  String selected = "Default";
  final options = ["Default", "Early", "Late", "Flexible"];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    selected = await SettingsStore.getMealSchedule();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await SettingsStore.setMealSchedule(selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.mealSchedule".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          ...options.map((x) => RadioListTile<String>(
            value: x,
            groupValue: selected,
            onChanged: (v) => setState(() => selected = v ?? selected),
            title: Text(x),
          )),
          Spacer(),
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _save,
                child: Text("common.save".tr(), style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
