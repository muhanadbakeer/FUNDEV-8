import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MealPlanPage extends StatelessWidget {
   MealPlanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal plan".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale( Locale("ar"));
              } else {
                context.setLocale( Locale("en"));
              }
            },
            icon:  Icon(Icons.language),
            tooltip: "Change language",
          ),
        ],

      ),

      body: ListView(
        padding:  EdgeInsets.all(16),
        children: [
          Text(
            "Today's meals".tr(),
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
           SizedBox(height: 12),
          Card(
            child: ListTile(
              leading:  Icon(Icons.free_breakfast),
              title: Text("Breakfast".tr()),
              subtitle: Text("Oats, milk, banana".tr()),
            ),
          ),
          Card(
            child: ListTile(
              leading:  Icon(Icons.lunch_dining),
              title: Text("Lunch".tr()),
              subtitle: Text("Chicken, rice, salad".tr()),
            ),
          ),
          Card(
            child: ListTile(
              leading:  Icon(Icons.dinner_dining),
              title: Text("Dinner".tr()),
              subtitle: Text("Light meal".tr()),
            ),
          ),
          Card(
            child: ListTile(
              leading:  Icon(Icons.local_drink),
              title: Text("Snacks".tr()),
              subtitle: Text("Fruits, nuts".tr()),
            ),
          ),
        ],
      ),
    );
  }
}
