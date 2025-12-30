import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class FavoriteCuisinesPage extends StatefulWidget {
  FavoriteCuisinesPage({super.key});

  @override
  State<FavoriteCuisinesPage> createState() => _FavoriteCuisinesPageState();
}

class _FavoriteCuisinesPageState extends State<FavoriteCuisinesPage> {
  bool loading = true;

  final List<String> options = [
    "Middle Eastern",
    "Italian",
    "Indian",
    "Mexican",
    "Japanese",
    "Chinese",
    "Turkish",
    "Greek",
    "American"
  ];

  Set<String> selected = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final v = await SettingsStore.getCuisines();
    selected = v.toSet();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await SettingsStore.setCuisines(selected.toList());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.favoriteCuisines".tr()),
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
