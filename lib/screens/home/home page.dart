import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../ profile/profile.dart';
import '../auth/SplashView.dart';
import 'HistoryPage.dart';
import 'MealPlanPage.dart';
import 'NotificationsPage.dart';
import 'home/SETTINGS/SettingsPage.dart';

class RecipesExplorePage extends StatefulWidget {
  RecipesExplorePage({super.key});

  @override
  State<RecipesExplorePage> createState() => _RecipesExplorePageState();
}

class _RecipesExplorePageState extends State<RecipesExplorePage> {
  final TextEditingController search = TextEditingController();

  int filterCount = 3;

  late List<_RecipeItem> explore = _RecipeData.buildExplore();

  List<_RecipeItem> favorites = [];
  List<_RecipeItem> ratings = [];

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color green = Colors.green;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        appBar: AppBar(
          backgroundColor: green,
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          title: Text(
            "DIV Nutrition".tr(),
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              tooltip: "notifications.title".tr(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationsPage()),
                );
              },
              icon: Icon(Icons.notifications_none),
            ),
            IconButton(
              tooltip: "Profile".tr(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => items_mode()),
                );
              },
              icon: Icon(Icons.person_outline),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: "Explore".tr()),
              Tab(text: "Favorites".tr()),
              Tab(text: "Ratings".tr()),
            ],
          ),
        ),

        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(color: green),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.restaurant, color: green, size: 28),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "DIV Nutrition".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Quick navigation".tr(),
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _drawerItem(
                        icon: Icons.settings,
                        title: "settings.title".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SettingsPage()),
                          );
                        },
                      ),
                      _drawerItem(
                        icon: Icons.list_alt,
                        title: "history.title".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => HistoryPage()),
                          );
                        },
                      ),
                      _drawerItem(
                        icon: Icons.grid_view_rounded,
                        title: "navigation.mealPlan".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => MealPlanIntroPage()),
                          );
                        },
                      ),
                      Divider(height: 24),
                      _drawerItem(
                        icon: Icons.logout,
                        title: "settings.logout".tr(),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => SplashView()),
                                (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: search,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "Search recipes".tr(),
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  InkWell(
                    onTap: () => _openFilters(context, green),
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 52,
                          height: 48,
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(Icons.tune, color: Colors.white),
                        ),
                        if (filterCount > 0)
                          Positioned(
                            top: -8,
                            left: -8,
                            child: Container(
                              width: 22,
                              height: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.lightGreenAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$filterCount",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _RecipesGrid(
                    items: _applySearch(explore),
                    showImportCard: true,
                    onImportTap: () {
                      // TODO: import recipe flow (API later)
                    },
                    onRecipeTap: (item) => onOpenRecipeDetails(item),
                  ),
                  _RecipesGrid(
                    items: _applySearch(favorites),
                    showImportCard: false,
                    emptyText: "No favorites yet".tr(),
                    onImportTap: () {},
                    onRecipeTap: (item) => onOpenRecipeDetails(item),
                  ),
                  _RecipesGrid(
                    items: _applySearch(ratings),
                    showImportCard: false,
                    emptyText: "No ratings yet".tr(),
                    onImportTap: () {},
                    onRecipeTap: (item) => onOpenRecipeDetails(item),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_RecipeItem> _applySearch(List<_RecipeItem> list) {
    final String q = search.text.trim().toLowerCase();
    if (q.isEmpty) return list;
    return list.where((e) => e.title.toLowerCase().contains(q)).toList();
  }

  void _openFilters(BuildContext context, Color green) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Filters".tr(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => filterCount = 0);
                      Navigator.pop(context);
                    },
                    child: Text("Clear".tr(), style: TextStyle(color: green)),
                  )
                ],
              ),
              SizedBox(height: 8),

              _filterTile(title: "Today".tr()),
              _filterTile(title: "This week".tr()),
              _filterTile(title: "This month".tr()),
              _filterTile(title: "High protein".tr()),
              _filterTile(title: "Low calories".tr()),

              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    setState(() => filterCount = 3);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "common.apply".tr(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterTile({required String title}) {
    return ListTile(
      leading: Icon(Icons.check_box_outline_blank, color: Colors.green),
      title: Text(title),
      onTap: () {},
      contentPadding: EdgeInsets.zero,
    );
  }

  void onOpenRecipeDetails(_RecipeItem item) {
    // Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailsPage(item: item)));
  }
}

Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.green),
    title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
    onTap: onTap,
  );
}

class _RecipesGrid extends StatelessWidget {
  _RecipesGrid({
    required this.items,
    required this.onImportTap,
    required this.onRecipeTap,
    this.showImportCard = true,
    this.emptyText,
  });

  final List<_RecipeItem> items;
  final VoidCallback onImportTap;
  final void Function(_RecipeItem item) onRecipeTap;
  final bool showImportCard;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    if (showImportCard) {
      children.add(_ImportCard(onTap: onImportTap));
    }

    for (final item in items) {
      children.add(_RecipeCard(item: item, onTap: () => onRecipeTap(item)));
    }

    if (children.isEmpty) {
      return Center(
        child: Text(
          emptyText ?? "No items".tr(),
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return GridView.count(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: children,
    );
  }
}

class _ImportCard extends StatelessWidget {
  _ImportCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Import Recipe".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 10),
            Icon(Icons.add, size: 28, color: Colors.green),
            SizedBox(height: 10),
            Text(
              "From link, text, or photos".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  _RecipeCard({required this.item, required this.onTap});
  final _RecipeItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 6),
              color: Colors.black12,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(item.imageUrl, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
              if (item.isPro)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "PRO",
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                    ),
                  ),
                ),
              Positioned(
                bottom: 44,
                right: 10,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${item.minutes} min",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeItem {
  String title;
  int minutes;
  String imageUrl;
  bool isPro;

  _RecipeItem({
    required this.title,
    required this.minutes,
    required this.imageUrl,
    required this.isPro,
  });
}

class _RecipeData {
  static List<_RecipeItem> buildExplore() {

    List<String> titles = [
      "Shirataki Stir-Fry Noodles",
      "Roasted Asparagus",
      "Herb Grilled Atlantic Salmon",
      "Protein Salad",
      "Greek Yogurt Bowl",
      "Chicken & Veggie Plate",
      "Overnight Oats",
      "Healthy Rice Bowl",
      "Avocado Toast",
      "Fresh Green Salad",
      "Tuna Salad Wrap",
      "Egg & Spinach Omelet",
      "Grilled Chicken Breast",
      "Baked Sweet Potato",
      "Beef & Broccoli",
      "Turkey Sandwich",
      "Quinoa Veggie Bowl",
      "Lentil Soup",
      "Oat Pancakes",
      "Chia Pudding",
      "Shrimp Stir-Fry",
      "Salmon Rice Bowl",
      "Cottage Cheese Plate",
      "Roasted Veggies Mix",
      "Chicken Caesar Salad",
      "Brown Rice & Beans",
      "Zucchini Noodles",
      "Tomato Basil Salad",
      "Chicken Wrap",
      "Air-Fryer Potatoes",
      "Veggie Omelet",
      "Grilled Steak Bites",
      "Mediterranean Bowl",
      "Yogurt & Berries",
      "Apple Cinnamon Oats",
      "Light Pasta Bowl",
      "Baked Cod Plate",
      "Chicken Soup",
      "Low-Cal Sandwich",
      "High-Protein Breakfast",
      "Veggie Snack Box",
      "Egg Salad",
      "Tuna Bowl",
      "Beef Salad",
      "Chicken Bowl",
      "Green Smoothie Bowl",
      "Oatmeal Power Bowl",
      "Simple Meal Prep Box",
      "Healthy Snack Plate",
      "Chicken & Rice",
      "Salmon & Greens",
      "Eggs & Avocado",
      "Lean Beef Bowl",
      "Veggie Soup",
      "Protein Lunch Box"
    ];

    List<_RecipeItem> list = [];
    for (int i = 0; i < titles.length; i++) {
      int minutes = 10 + (i % 25);
      bool pro = (i % 7 == 0);

    }
    return list;
  }
}
