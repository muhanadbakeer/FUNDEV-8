import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/macros_goal_api.dart';
import 'package:div/screens/home/api_home/calorie_goal_api.dart';

class MacrosGoalPage extends StatefulWidget {
  MacrosGoalPage({super.key});

  @override
  State<MacrosGoalPage> createState() => _MacrosGoalPageState();
}

class _MacrosGoalPageState extends State<MacrosGoalPage> {
  bool loading = true;

  // same as screenshot default
  int protein = 25;
  int fat = 55;
  int carbs = 20;

  // calories from API (for the top box)
  int caloriesPerDay = 0;

  final String userId = "1";

  @override
  void initState() {
    super.initState();
    _init();
  }

  int get total => protein + fat + carbs;
  bool get valid => total == 100;

  Future<void> _init() async {
    try {
      final m = await MacrosGoalApi.getMacros(userId);
      protein = m["p"] ?? protein;
      carbs = m["c"] ?? carbs;
      fat = m["f"] ?? fat;
    } catch (_) {}

    try {
      final v = await CalorieGoalApi.getGoal(userId);
      caloriesPerDay = v;
    } catch (_) {
      caloriesPerDay = 0;
    }

    setState(() => loading = false);
  }

  void _inc(String key) {
    setState(() {
      if (key == "p" && protein < 100) protein++;
      if (key == "f" && fat < 100) fat++;
      if (key == "c" && carbs < 100) carbs++;
    });
  }

  void _dec(String key) {
    setState(() {
      if (key == "p" && protein > 0) protein--;
      if (key == "f" && fat > 0) fat--;
      if (key == "c" && carbs > 0) carbs--;
    });
  }

  void _useDefaults() {
    setState(() {
      protein = 25;
      fat = 55;
      carbs = 20;
    });
  }

  Future<void> _save() async {
    if (!valid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("settings.macrosMust100".tr())),
      );
      return;
    }

    await MacrosGoalApi.saveMacros(userId: userId, p: protein, c: carbs, f: fat);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator(color: Colors.green))
            : Column(
          children: [
            // Header (right aligned) like screenshot
            Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Adjust targets".tr(),
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Text(
                "What are your daily nutrition targets?".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 16,
                ),
              ),
            ),

            SizedBox(height: 18),

            // Calories per day box (top green card)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    "Calories per day".tr(),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Center(
                      child: Text(
                        caloriesPerDay == 0 ? "-" : "$caloriesPerDay",
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Macro rows (+ / -)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  _macroRow(
                    title: "Protein".tr(),
                    value: protein,
                    onPlus: () => _inc("p"),
                    onMinus: () => _dec("p"),
                  ),
                  SizedBox(height: 12),
                  _macroRow(
                    title: "Fat".tr(),
                    value: fat,
                    onPlus: () => _inc("f"),
                    onMinus: () => _dec("f"),
                  ),
                  SizedBox(height: 12),
                  _macroRow(
                    title: "Carbohydrates".tr(),
                    value: carbs,
                    onPlus: () => _inc("c"),
                    onMinus: () => _dec("c"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Total targets card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Text(
                    "Total targets".tr(),
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "$total%",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: valid ? Colors.green.shade900 : Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            Text(
              "The total amount must be exactly 100%".tr(),
              style: TextStyle(
                color: valid ? Colors.green.shade700 : Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),

            Spacer(),

            // Save
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _save,
                  child: Text(
                    "common.save".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),

            // Use defaults
            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.green.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: _useDefaults,
                  child: Text(
                    "Use defaults".tr(),
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroRow({
    required String title,
    required int value,
    required VoidCallback onPlus,
    required VoidCallback onMinus,
  }) {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          SizedBox(width: 10),
          IconButton(
            onPressed: onPlus,
            icon: Icon(Icons.add, color: Colors.green),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  "$value%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onMinus,
            icon: Icon(Icons.remove, color: Colors.green),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
