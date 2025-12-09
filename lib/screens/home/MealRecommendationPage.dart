import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../core/uite/db_helper.dart';


class MealRecommendationPage extends StatefulWidget {
  const MealRecommendationPage({super.key});

  @override
  State<MealRecommendationPage> createState() => _MealRecommendationPageState();
}

class _MealRecommendationPageState extends State<MealRecommendationPage> {
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> meals = [];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final profile = await NotesDatabase().getProfile();
    setState(() {
      userData = profile;
      meals = _getMealSuggestions(profile);
    });
  }

  List<Map<String, dynamic>> _getMealSuggestions(Map<String, dynamic>? profile) {
    if (profile == null) return [];

    double weight = double.tryParse(profile["weight"] ?? "0") ?? 0;
    double goal = double.tryParse(profile["height"] ?? "0") ?? 0;
    if (profile.containsKey("goal")) {
      goal = double.tryParse(profile["goal"]) ?? goal;
    }

    if (weight > goal) {

      return [
        {
          "title": "Oatmeal with fruit",
          "calories": "300 kcal",
          "time": "Breakfast",
        },
        {
          "title": "Grilled chicken salad",
          "calories": "420 kcal",
          "time": "Lunch",
        },
        {
          "title": "Vegetable soup + toast",
          "calories": "350 kcal",
          "time": "Dinner",
        },
        {
          "title": "Green smoothie",
          "calories": "150 kcal",
          "time": "Snack",
        },
      ];
    } else {

      return [
        {
          "title": "Peanut butter sandwich",
          "calories": "450 kcal",
          "time": "Breakfast",
        },
        {
          "title": "Rice with chicken & avocado",
          "calories": "650 kcal",
          "time": "Lunch",
        },
        {
          "title": "Pasta with cheese & olive oil",
          "calories": "600 kcal",
          "time": "Dinner",
        },
        {
          "title": "Protein shake",
          "calories": "300 kcal",
          "time": "Snack",
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Meal Recommendations".tr()),
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
          ),
        ],
      ),
      body: userData == null
          ?  Center(child: CircularProgressIndicator())
          : Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended meals for you".tr(),
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 18),
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return Card(
                    elevation: 2,
                    margin:  EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading:  Icon(Icons.restaurant_menu, color: Colors.green),
                      title: Text(meal["title"].toString().tr()),
                      subtitle: Text(
                        "${meal["time"]} • ${meal["calories"]}".tr(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
