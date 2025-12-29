import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/settings_store.dart';

class AllergensPage extends StatefulWidget {
  AllergensPage({super.key});

  @override
  State<AllergensPage> createState() => _AllergensPageState();
}

class _AllergensPageState extends State<AllergensPage> {
  bool loading = true;
  final List<String> options = [
    "Peanuts",
    "Milk",
    "Eggs",
    "Wheat",
    "Fish",
    "Shellfish",
    "Soy",
    "Tree Nuts",
    "Sesame"
  ];

  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final v = await SettingsStore.getAllergens();
    selected = v.toSet();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await SettingsStore.setAllergens(selected.toList());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.allergens".tr()),
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
