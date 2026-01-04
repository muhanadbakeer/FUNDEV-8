import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/meals_per_day_api.dart';

class MealsPerDayPage extends StatefulWidget {
  MealsPerDayPage({super.key});

  @override
  State<MealsPerDayPage> createState() => _MealsPerDayPageState();
}

class _MealsPerDayPageState extends State<MealsPerDayPage> {
  bool loading = true;

  bool breakfast = true;
  bool lunch = true;
  bool dinner = true;

  int meals = 3;
  final String userId = "1";

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      meals = await MealsPerDayApi.getMeals(userId);
    } catch (_) {
      meals = 3;
    }

    breakfast = meals >= 1;
    lunch = meals >= 2;
    dinner = meals >= 3;

    setState(() => loading = false);
  }

  int _countSelected() {
    int c = 0;
    if (breakfast) c++;
    if (lunch) c++;
    if (dinner) c++;
    return c;
  }

  void _toggle(String key, bool value) {
    setState(() {
      if (key == "breakfast") breakfast = value;
      if (key == "lunch") lunch = value;
      if (key == "dinner") dinner = value;

      if (_countSelected() == 0) {
        breakfast = true;
      }

      meals = _countSelected();
    });
  }

  Future<void> _save() async {
    meals = _countSelected();
    await MealsPerDayApi.saveMeals(userId, meals);
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
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Meals".tr(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
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
                "Select all of the meals that you want to include in your plan"
                    .tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 16,
                ),
              ),
            ),
            Spacer(),
            Container(
              margin: EdgeInsets.fromLTRB(18, 0, 18, 18),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.15),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Su"),
                        Text("Sa"),
                        Text("Fr"),
                        Text("Th"),
                        Text("We"),
                        Text("Tu"),
                        Text("Mo"),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _mealRow(
                    title: "Breakfast".tr(),
                    icon: Icons.wb_sunny_outlined,
                    value: breakfast,
                    onChanged: (v) => _toggle("breakfast", v),
                  ),
                  Divider(),
                  _mealRow(
                    title: "Lunch".tr(),
                    icon: Icons.wb_sunny,
                    value: lunch,
                    onChanged: (v) => _toggle("lunch", v),
                  ),
                  Divider(),
                  _mealRow(
                    title: "Dinner".tr(),
                    icon: Icons.nightlight_outlined,
                    value: dinner,
                    onChanged: (v) => _toggle("dinner", v),
                    showDivider: false,
                  ),
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

  Widget _mealRow({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool showDivider = true,
  }) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          Switch(
            value: value,
            activeColor: Colors.green,
            onChanged: onChanged,
          ),
          Spacer(),
          Icon(icon, color: Colors.green),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
