import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';


class UnitsPage extends StatefulWidget {
  UnitsPage({super.key});

  @override
  State<UnitsPage> createState() => _UnitsPageState();
}

class _UnitsPageState extends State<UnitsPage> {
  bool loading = true;
  String selected = "Metric";
  final options = ["Metric", "Imperial"];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    selected = await SettingsStore.getUnits();
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await SettingsStore.setUnits(selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.units".tr()),
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
