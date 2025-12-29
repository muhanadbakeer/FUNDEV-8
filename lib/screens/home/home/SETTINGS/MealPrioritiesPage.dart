import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/settings_store.dart';

class MealPrioritiesPage extends StatefulWidget {
  MealPrioritiesPage({super.key});

  @override
  State<MealPrioritiesPage> createState() => _MealPrioritiesPageState();
}

class _MealPrioritiesPageState extends State<MealPrioritiesPage> {
  bool loading = true;

  final options = ["Balanced", "High Protein", "Low Carb", "Quick Meals", "Budget"];
  Set<String> selected = {"Balanced"};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final v = await SettingsStore.getMealPriorities();
    selected = v.toSet();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    if (selected.isEmpty) selected.add("Balanced");
    await SettingsStore.setMealPriorities(selected.toList());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.mealPlanPriorities".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((x) {
                final on = selected.contains(x);
                return FilterChip(
                  label: Text(x),
                  selected: on,
                  onSelected: (v) {
                    setState(() {
                      if (v) {
                        selected.add(x);
                      } else {
                        selected.remove(x);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
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
