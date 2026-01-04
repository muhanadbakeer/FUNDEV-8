import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/calorie_goal_api.dart';

class CalorieGoalPage extends StatefulWidget {
  CalorieGoalPage({super.key});

  @override
  State<CalorieGoalPage> createState() => _CalorieGoalPageState();
}

class _CalorieGoalPageState extends State<CalorieGoalPage> {
  final TextEditingController caloriesCtrl = TextEditingController();

  bool loading = true;
  final String userId = "1";

  // Manual / Automatic
  bool isAutomatic = true;

  // Inputs (editable)
  String gender = "male"; // male / female
  int age = 22; // years

  int heightFeet = 5;
  int heightInch = 10;

  int weightLbs = 152;
  int goalWeightLbs = 152;

  String activity = "low"; // low / medium / high

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    caloriesCtrl.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    try {
      final v = await CalorieGoalApi.getGoal(userId);
      caloriesCtrl.text = v.toString();
    } catch (_) {
      caloriesCtrl.text = "2000";
    }

    // default calculate if automatic
    if (isAutomatic) {
      caloriesCtrl.text = _autoCalories().round().toString();
    }

    setState(() => loading = false);
  }

  double _lbsToKg(int lbs) => lbs * 0.45359237;
  double _feetInchToCm(int ft, int inch) => (ft * 30.48) + (inch * 2.54);

  double _activityFactor() {
    if (activity == "low") return 1.2;
    if (activity == "medium") return 1.55;
    return 1.725;
  }

  // Mifflin-St Jeor
  double _bmr() {
    final w = _lbsToKg(weightLbs);
    final h = _feetInchToCm(heightFeet, heightInch);
    final a = age.toDouble();

    if (gender == "male") {
      return 10 * w + 6.25 * h - 5 * a + 5;
    } else {
      return 10 * w + 6.25 * h - 5 * a - 161;
    }
  }

  double _autoCalories() {
    // base maintenance
    double tdee = _bmr() * _activityFactor();

    // adjust based on goal weight vs current weight
    // simple: if goal < current => deficit, if goal > current => surplus
    if (goalWeightLbs < weightLbs) {
      tdee -= 400; // light deficit
    } else if (goalWeightLbs > weightLbs) {
      tdee += 300; // light surplus
    }

    // safety bounds
    if (tdee < 1200) tdee = 1200;
    if (tdee > 4500) tdee = 4500;

    return tdee;
  }

  void _recalcIfAuto() {
    if (!isAutomatic) return;
    caloriesCtrl.text = _autoCalories().round().toString();
    setState(() {});
  }

  Future<void> _save() async {
    final v = int.tryParse(caloriesCtrl.text.trim());
    if (v == null || v < 500 || v > 8000) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("settings.invalidNumber".tr())),
      );
      return;
    }

    await CalorieGoalApi.saveGoal(userId, v);
    Navigator.pop(context);
  }

  Future<void> _editChoice({
    required String title,
    required List<String> options,
    required String current,
    required void Function(String) onSelect,
  }) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 12),
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                SizedBox(height: 10),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => Divider(height: 1),
                    itemBuilder: (_, i) {
                      final o = options[i];
                      final selected = o == current;
                      return ListTile(
                        title: Text(o, style: TextStyle(fontWeight: FontWeight.w800)),
                        trailing: selected ? Icon(Icons.check, color: Colors.green) : null,
                        onTap: () => Navigator.pop(context, o),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null) {
      onSelect(picked);
      _recalcIfAuto();
    }
  }

  Future<void> _editNumber({
    required String title,
    required int current,
    required int min,
    required int max,
    required void Function(int) onSelect,
  }) async {
    final ctrl = TextEditingController(text: current.toString());

    final picked = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 12),
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                SizedBox(height: 12),
                TextField(
                  controller: ctrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      final v = int.tryParse(ctrl.text.trim());
                      if (v == null || v < min || v > max) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("settings.invalidNumber".tr())),
                        );
                        return;
                      }
                      Navigator.pop(context, v);
                    },
                    child: Text(
                      "common.save".tr(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null) {
      onSelect(picked);
      _recalcIfAuto();
    }
  }

  Future<void> _editHeight() async {
    int ft = heightFeet;
    int inch = heightInch;

    final result = await showModalBottomSheet<Map<String, int>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).viewInsets.bottom + 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 12),
                Text("Height".tr(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: ft,
                        decoration: InputDecoration(
                          labelText: "ft".tr(),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        items: List.generate(4, (i) => 4 + i)
                            .map((v) => DropdownMenuItem(value: v, child: Text("$v")))
                            .toList(),
                        onChanged: (v) => ft = v ?? ft,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: inch,
                        decoration: InputDecoration(
                          labelText: "inch".tr(),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        items: List.generate(12, (i) => i)
                            .map((v) => DropdownMenuItem(value: v, child: Text("$v")))
                            .toList(),
                        onChanged: (v) => inch = v ?? inch,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () => Navigator.pop(context, {"ft": ft, "inch": inch}),
                    child: Text(
                      "common.save".tr(),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      heightFeet = result["ft"] ?? heightFeet;
      heightInch = result["inch"] ?? heightInch;
      _recalcIfAuto();
      setState(() {});
    }
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
            // Top title like screenshot (right aligned + arrow)
            Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Calorie target".tr(),
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
                "Based on your information, we’ll create meal plans targeting:"
                    .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 16,
                ),
              ),
            ),

            SizedBox(height: 18),

            // Calories per day box
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
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: isAutomatic
                        ? Center(
                      child: Text(
                        caloriesCtrl.text,
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          color: Colors.green.shade300,
                        ),
                      ),
                    )
                        : TextField(
                      controller: caloriesCtrl,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 34, fontWeight: FontWeight.w900),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Manual / Automatic segmented buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _segBtn(
                      label: "Manual".tr(),
                      selected: !isAutomatic,
                      onTap: () {
                        setState(() {
                          isAutomatic = false;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _segBtn(
                      label: "Automatic".tr(),
                      selected: isAutomatic,
                      onTap: () {
                        setState(() {
                          isAutomatic = true;
                          caloriesCtrl.text = _autoCalories().round().toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            Expanded(
              child: ListView(
                children: [
                  _settingRow(
                    leftValue: gender == "male" ? "Male".tr() : "Female".tr(),
                    rightLabel: "Gender".tr(),
                    onTap: () => _editChoice(
                      title: "Gender".tr(),
                      options: ["Male".tr(), "Female".tr()],
                      current: gender == "male" ? "Male".tr() : "Female".tr(),
                      onSelect: (v) {
                        gender = (v.toLowerCase().contains("female")) ? "female" : "male";
                        _recalcIfAuto();
                        setState(() {});
                      },
                    ),
                  ),
                  _settingRow(
                    leftValue: "$age",
                    rightLabel: "Age".tr(),
                    onTap: () => _editNumber(
                      title: "Age".tr(),
                      current: age,
                      min: 10,
                      max: 90,
                      onSelect: (v) {
                        age = v;
                        _recalcIfAuto();
                        setState(() {});
                      },
                    ),
                  ),
                  _settingRow(
                    leftValue: "$heightFeet ft, $heightInch inch",
                    rightLabel: "Height".tr(),
                    onTap: _editHeight,
                  ),
                  _settingRow(
                    leftValue: "$weightLbs lbs",
                    rightLabel: "Weight".tr(),
                    onTap: () => _editNumber(
                      title: "Weight (lbs)".tr(),
                      current: weightLbs,
                      min: 60,
                      max: 600,
                      onSelect: (v) {
                        weightLbs = v;
                        _recalcIfAuto();
                        setState(() {});
                      },
                    ),
                  ),
                  _settingRow(
                    leftValue: "$goalWeightLbs lbs",
                    rightLabel: "Goal weight".tr(),
                    onTap: () => _editNumber(
                      title: "Goal weight (lbs)".tr(),
                      current: goalWeightLbs,
                      min: 60,
                      max: 600,
                      onSelect: (v) {
                        goalWeightLbs = v;
                        _recalcIfAuto();
                        setState(() {});
                      },
                    ),
                  ),
                  _settingRow(
                    leftValue: activity == "low"
                        ? "Low activity".tr()
                        : activity == "medium"
                        ? "Medium activity".tr()
                        : "High activity".tr(),
                    rightLabel: "Activity level".tr(),
                    onTap: () => _editChoice(
                      title: "Activity level".tr(),
                      options: [
                        "Low activity".tr(),
                        "Medium activity".tr(),
                        "High activity".tr(),
                      ],
                      current: activity == "low"
                          ? "Low activity".tr()
                          : activity == "medium"
                          ? "Medium activity".tr()
                          : "High activity".tr(),
                      onSelect: (v) {
                        final s = v.toLowerCase();
                        if (s.contains("medium")) activity = "medium";
                        else if (s.contains("high")) activity = "high";
                        else activity = "low";
                        _recalcIfAuto();
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(18, 0, 18, 18),
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
          ],
        ),
      ),
    );
  }

  Widget _segBtn({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: selected ? Colors.white : Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _settingRow({
    required String leftValue,
    required String rightLabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.green.shade100),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.chevron_left, color: Colors.green),
            SizedBox(width: 10),
            Text(
              leftValue,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Spacer(),
            Text(
              rightLabel,
              style: TextStyle(fontSize: 16, color: Colors.green.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
