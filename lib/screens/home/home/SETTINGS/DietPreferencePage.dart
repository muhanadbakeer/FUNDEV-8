import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/diet_preference_api.dart';
import 'package:div/screens/home/api_home/calorie_goal_api.dart';
import 'DietDetailsPage.dart';

class DietPreferencePage extends StatefulWidget {
  DietPreferencePage({super.key});

  @override
  State<DietPreferencePage> createState() => _DietPreferencePageState();
}

class _DietPreferencePageState extends State<DietPreferencePage> {
  bool loading = true;
  String selectedKey = "mediterranean";
  int caloriesPerDay = 0;

  final String userId = "1";

  late List<DietOption> diets;

  @override
  void initState() {
    super.initState();

    diets = [
      DietOption(
        keyName: "mediterranean",
        title: "Mediterranean",
        subtitle: "Plant-based,\nheart-healthy",
        imageUrl:
        "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=1200&q=80",
        protein: 30,
        fat: 35,
        carb: 35,
        description:
        "A balanced, heart-healthy diet emphasizing vegetables, fruits, whole grains, olive oil, fish, and legumes.",
      ),
      DietOption(
        keyName: "paleo",
        title: "Paleo",
        subtitle: "Primal, whole foods",
        imageUrl:
        "https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?auto=format&fit=crop&w=1200&q=80",
        protein: 30,
        fat: 40,
        carb: 30,
        description:
        "Focuses on whole foods like meat, fish, eggs, vegetables, fruits, and nuts while avoiding processed foods and grains.",
      ),
      DietOption(
        keyName: "carnivore",
        title: "Carnivore",
        subtitle: "Animal-based eating",
        imageUrl:
        "https://images.unsplash.com/photo-1553163147-622ab57be1c7?auto=format&fit=crop&w=1200&q=80",
        protein: 60,
        fat: 40,
        carb: 0,
        description:
        "A strict animal-based diet emphasizing meat, fish, and animal products while excluding plant-based foods entirely.",
      ),
      DietOption(
        keyName: "whole30",
        title: "Whole30",
        subtitle: "No sugar, grains or\ndairy",
        imageUrl:
        "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=1200&q=80",
        protein: 30,
        fat: 40,
        carb: 30,
        description:
        "A 30-day reset focusing on whole foods while eliminating added sugar, grains, dairy, and processed foods.",
      ),
    ];

    _init();
  }

  Future<void> _init() async {
    try {
      selectedKey = await DietPreferenceApi.getPreference(userId);
    } catch (_) {}

    try {
      caloriesPerDay = await CalorieGoalApi.getGoal(userId);
    } catch (_) {
      caloriesPerDay = 0;
    }

    setState(() => loading = false);
  }

  Future<void> _selectDiet(String key) async {
    setState(() => selectedKey = key);
    await DietPreferenceApi.savePreference(userId, key);
  }

  void _openDiet(DietOption diet) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DietDetailsPage(
          userId: userId,
          caloriesPerDay: caloriesPerDay,
          diet: diet,
          selectedKey: selectedKey,
          onSelect: (k) async {
            await _selectDiet(k);
          },
        ),
      ),
    );

    setState(() {});
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
              padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Diet".tr(),
                    style: TextStyle(
                      fontSize: 30,
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
              padding: EdgeInsets.fromLTRB(24, 0, 24, 10),
              child: Text(
                "Which diet best fits your preferences?".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 16),
                itemCount: diets.length,
                separatorBuilder: (_, __) => SizedBox(height: 14),
                itemBuilder: (_, i) {
                  final diet = diets[i];
                  final isSelected = diet.keyName == selectedKey;

                  return InkWell(
                    onTap: () => _openDiet(diet),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected
                              ? Colors.green
                              : Colors.green.shade100,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 12,
                            offset: Offset(0, 6),
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(18),
                            ),
                            child: SizedBox(
                              width: 150,
                              height: 140,
                              child: Image.network(
                                diet.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 14, 14, 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        diet.title,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        diet.subtitle,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "View diet".tr(),
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Icon(
                                        Icons.chevron_left,
                                        color: Colors.black38,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

class DietOption {
  DietOption({
    required this.keyName,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.protein,
    required this.fat,
    required this.carb,
    required this.description,
  });

  final String keyName;
  final String title;
  final String subtitle;
  final String imageUrl;

  final int protein;
  final int fat;
  final int carb;

  final String description;
}
