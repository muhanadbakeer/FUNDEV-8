import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/meal_priorities_api.dart';

class MealPrioritiesPage extends StatefulWidget {
  const MealPrioritiesPage({super.key});

  @override
  State<MealPrioritiesPage> createState() => _MealPrioritiesPageState();
}

class _MealPrioritiesPageState extends State<MealPrioritiesPage> {
  bool loading = true;

  final String userId = "1"; // مؤقت – من Auth لاحقاً

  final options = ["Balanced", "High Protein", "Low Carb", "Quick Meals", "Budget"];
  Set<String> selected = {"Balanced"};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final v = await MealPrioritiesApi.getPriorities(userId);
      selected = v.toSet();
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    if (selected.isEmpty) selected.add("Balanced");

    await MealPrioritiesApi.savePriorities(userId, selected.toList());
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: _save,
                child: Text(
                  "common.save".tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
