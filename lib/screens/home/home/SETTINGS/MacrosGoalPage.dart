import 'package:div/screens/home/home/SETTINGS/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/settings_store.dart';

class MacrosGoalPage extends StatefulWidget {
  MacrosGoalPage({super.key});

  @override
  State<MacrosGoalPage> createState() => _MacrosGoalPageState();
}

class _MacrosGoalPageState extends State<MacrosGoalPage> {
  int p = 25, c = 55, f = 20;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final m = await SettingsStore.getMacros();
    setState(() {
      p = m["p"]!;
      c = m["c"]!;
      f = m["f"]!;
      loading = false;
    });
  }

  bool _valid() => (p + c + f) == 100;

  Future<void> _save() async {
    if (!_valid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("settings.macrosMust100".tr())));
      return;
    }
    await SettingsStore.setMacros(p: p, c: c, f: f);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("settings.macrosGoal".tr()),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sliderRow("Protein", p, (v) => setState(() => p = v)),
            _sliderRow("Carbs", c, (v) => setState(() => c = v)),
            _sliderRow("Fat", f, (v) => setState(() => f = v)),
            SizedBox(height: 10),
            Text(
              _valid() ? "Total: 100%" : "Total: ${p + c + f}% (must be 100%)",
              style: TextStyle(fontWeight: FontWeight.w700, color: _valid() ? Colors.green : Colors.red),
            ),
            SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _save,
              child: Text("common.save".tr(), style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sliderRow(String title, int value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w800))),
            Text("$value%", style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: (v) => onChanged(v.round()),
        ),
      ],
    );
  }
}
