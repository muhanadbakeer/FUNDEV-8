import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/allergens_api.dart';

class AllergensPage extends StatefulWidget {
  const AllergensPage({super.key});

  @override
  State<AllergensPage> createState() => _AllergensPageState();
}

class _AllergensPageState extends State<AllergensPage> {
  bool loading = true;

  final String userId = "1";

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
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await AllergensApi.getAllergens(userId);
      selected = data.toSet();
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await AllergensApi.saveAllergens(userId, selected.toList());
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
          ?  Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding:  EdgeInsets.all(16),
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
                      v ? selected.add(x) : selected.remove(x);
                    });
                  },
                );
              }).toList(),
            ),
          ),
           Spacer(),
          Padding(
            padding:  EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
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
