import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/meal_schedule_api.dart';

class MealSchedulePage extends StatefulWidget {
  const MealSchedulePage({super.key});

  @override
  State<MealSchedulePage> createState() => _MealSchedulePageState();
}

class _MealSchedulePageState extends State<MealSchedulePage> {
  bool loading = true;
  String selected = "Default";

  final String userId = "1";
  final options = ["Default", "Early", "Late", "Flexible"];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      selected = await MealScheduleApi.getSchedule(userId);
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await MealScheduleApi.saveSchedule(userId, selected);
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
          ?  Center(child: CircularProgressIndicator())
          : Column(
        children: [
          ...options.map(
                (x) => RadioListTile<String>(
              value: x,
              groupValue: selected,
              onChanged: (v) => setState(() => selected = v ?? selected),
              title: Text(x),
            ),
          ),
           Spacer(),
          Padding(
            padding:  EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green),
                onPressed: _save,
                child: Text(
                  "common.save".tr(),
                  style:  TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
