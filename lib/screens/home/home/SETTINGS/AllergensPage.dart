import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/allergens_api.dart';

class AllergensPage extends StatefulWidget {
  AllergensPage({super.key});

  @override
  State<AllergensPage> createState() => _AllergensPageState();
}

class _AllergensPageState extends State<AllergensPage> {
  bool loading = true;

  final String userId = "1";

  String query = "";
  String category = "all";

  Set<String> selected = {};

  late List<FoodItem> allItems;

  @override
  void initState() {
    super.initState();

    allItems = [
      FoodItem(keyName: "egg", label: "Egg", emoji: "🥚", category: "common"),
      FoodItem(keyName: "beef", label: "Beef", emoji: "🥩", category: "common"),
      FoodItem(keyName: "kale", label: "Kale", emoji: "🥬", category: "common"),
      FoodItem(keyName: "avocado", label: "Avocado", emoji: "🥑", category: "common"),
      FoodItem(keyName: "tuna", label: "Tuna", emoji: "🐟", category: "common"),
      FoodItem(keyName: "ginger", label: "Ginger", emoji: "🫚", category: "common"),
      FoodItem(keyName: "bell_pepper", label: "Bell pepper", emoji: "🫑", category: "common"),
      FoodItem(keyName: "lamb", label: "Lamb", emoji: "🍖", category: "common"),
      FoodItem(keyName: "honey", label: "Honey", emoji: "🍯", category: "common"),
      FoodItem(keyName: "red_beet", label: "Red beet", emoji: "🫜", category: "common"),
      FoodItem(keyName: "shrimp", label: "Shrimp", emoji: "🦐", category: "common"),
      FoodItem(keyName: "mustard", label: "Mustard", emoji: "🟡", category: "common"),
      FoodItem(keyName: "brussel_sprout", label: "Brussel sprout", emoji: "🥦", category: "common"),
      FoodItem(keyName: "olives", label: "Olives", emoji: "🫒", category: "common"),
      FoodItem(keyName: "salmon", label: "Salmon", emoji: "🍣", category: "common"),
      FoodItem(keyName: "pork", label: "Pork", emoji: "🥓", category: "common"),
      FoodItem(keyName: "chicken", label: "Chicken", emoji: "🍗", category: "common"),
      FoodItem(keyName: "sesame", label: "Sesame", emoji: "🌰", category: "common"),
      FoodItem(keyName: "peanuts", label: "Peanuts", emoji: "🥜", category: "common"),
      FoodItem(keyName: "turnips", label: "Turnips", emoji: "🍠", category: "common"),
      FoodItem(keyName: "milk", label: "Milk", emoji: "🥛", category: "common"),

      // extra (for All products)
      FoodItem(keyName: "wheat", label: "Wheat", emoji: "🌾", category: "all"),
      FoodItem(keyName: "soy", label: "Soy", emoji: "🫘", category: "all"),
      FoodItem(keyName: "tree_nuts", label: "Tree nuts", emoji: "🌰", category: "all"),
      FoodItem(keyName: "fish", label: "Fish", emoji: "🐠", category: "all"),
      FoodItem(keyName: "shellfish", label: "Shellfish", emoji: "🦀", category: "all"),
    ];

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

  bool _match(FoodItem item) {
    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      if (!item.label.toLowerCase().contains(q)) return false;
    }
    if (category == "common") return item.category == "common";
    return true; // all
  }

  @override
  Widget build(BuildContext context) {
    final bg = Colors.blueGrey.shade50;
    final green = Colors.green;

    final visible = allItems.where(_match).toList();
    final common = allItems.where((x) => x.category == "common").toList();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator(color: green))
            : Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Dislikes".tr(),
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
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
              padding: EdgeInsets.fromLTRB(24, 0, 24, 14),
              child: Text(
                "Let us know what foods you dislike or don’t eat".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
            ),

            // Search + dropdown
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.black12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.black38),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => query = v),
                        decoration: InputDecoration(
                          hintText: "Search".tr(),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    DropdownButton<String>(
                      value: category,
                      underline: SizedBox(),
                      items: [
                        DropdownMenuItem(
                          value: "all",
                          child: Text("All products".tr()),
                        ),
                        DropdownMenuItem(
                          value: "common",
                          child: Text("Common products".tr()),
                        ),
                      ],
                      onChanged: (v) => setState(() => category = v ?? "all"),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 18),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  (category == "common" ? "Common products" : "All products").tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
            ),

            SizedBox(height: 14),

            // Chips area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: (category == "common" && query.trim().isEmpty ? common : visible)
                      .map((item) {
                    final on = selected.contains(item.keyName);

                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (on) {
                            selected.remove(item.keyName);
                          } else {
                            selected.add(item.keyName);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: on ? green.withOpacity(0.14) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: on ? green : Colors.green,
                            width: on ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              offset: Offset(0, 5),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.label.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(item.emoji, style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Bottom Save
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade900,
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
}

class FoodItem {
  FoodItem({
    required this.keyName,
    required this.label,
    required this.emoji,
    required this.category,
  });

  final String keyName;
  final String label;
  final String emoji;
  final String category;
}
