import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/diet_preference_api.dart';

class DietPreferencePage extends StatefulWidget {
  const DietPreferencePage({super.key});

  @override
  State<DietPreferencePage> createState() => _DietPreferencePageState();
}

class _DietPreferencePageState extends State<DietPreferencePage> {
  bool loading = true;
  String selected = "Low Carb";

  final String userId = "1"; // مؤقت – من Auth لاحقًا

  final List<String> options = [
    "Balanced",
    "Low Carb",
    "High Protein",
    "Keto",
    "Vegetarian",
    "Vegan",
    "Mediterranean"
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      selected = await DietPreferenceApi.getPreference(userId);
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await DietPreferenceApi.savePreference(userId, selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.dietPreference".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (_, i) {
                final v = options[i];
                return RadioListTile<String>(
                  value: v,
                  groupValue: selected,
                  onChanged: (x) =>
                      setState(() => selected = x ?? selected),
                  title: Text(v),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }
}
