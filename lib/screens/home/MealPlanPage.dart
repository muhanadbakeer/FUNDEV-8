import 'package:flutter/material.dart';
import 'package:div/screens/home/api_home/meal_plan_api.dart';

class MealPlanIntroPage extends StatefulWidget {
  const MealPlanIntroPage({super.key});

  @override
  State<MealPlanIntroPage> createState() => _MealPlanIntroPageState();
}

class _MealPlanIntroPageState extends State<MealPlanIntroPage> {
  final Color green = Colors.green;

  final String userId = "1";

  bool creating = false;
  MealPlanDto? currentPlan;

  @override
  void initState() {
    super.initState();
    _loadCurrent();
  }

  Future<void> _loadCurrent() async {
    try {
      final plan = await MealPlanApi.getCurrent(userId);
      if (!mounted) return;
      setState(() => currentPlan = plan);
    } catch (_) {

    }
  }

  Future<void> _createMealPlan() async {
    setState(() => creating = true);

    try {
      final plan = await MealPlanApi.create(userId);
      if (!mounted) return;

      setState(() {
        currentPlan = plan;
        creating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Meal plan created ✅")),
      );

      // Navigator.push(context, MaterialPageRoute(builder: (_) => MealPlanDetailsPage(plan: plan)));

    } catch (e) {
      if (!mounted) return;
      setState(() => creating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.greenAccent,

      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title:  Text(
          "DIV Nutrition",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: "Notifications",
            onPressed: () {},
            icon:  Icon(Icons.notifications_none),
          ),
          IconButton(
            tooltip: "Profile",
            onPressed: () {},
            icon:  Icon(Icons.person_outline),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:  EdgeInsets.all(16),
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
                      "DIV Nutrition",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                     SizedBox(height: 2),
                     Text("Quick navigation", style: TextStyle(color: Colors.greenAccent)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _drawerItem(icon: Icons.settings, title: "Settings", onTap: () {
                      Navigator.pop(context);
                      onOpenSettings();
                    }),
                    _drawerItem(icon: Icons.shopping_cart_outlined, title: "Purchases", onTap: () {
                      Navigator.pop(context);
                      onOpenPurchases();
                    }),
                    _drawerItem(icon: Icons.list_alt, title: "History", onTap: () {
                      Navigator.pop(context);
                      onOpenHistory();
                    }),
                    _drawerItem(icon: Icons.grid_view_rounded, title: "Meal Plan", onTap: () {
                      Navigator.pop(context);
                    }),
                    _drawerItem(icon: Icons.restaurant, title: "Recipes", onTap: () {
                      Navigator.pop(context);
                      onOpenRecipes();
                    }),
                     Divider(height: 24),
                    _drawerItem(icon: Icons.logout, title: "Logout", onTap: () {
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding:  EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                       Text(
                        "Meal Plan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                       SizedBox(height: 6),
                       Text(
                        "Get a balanced meal schedule that matches your goals and taste.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),

                       SizedBox(height: 18),

                      if (currentPlan != null) ...[
                        Container(
                          width: double.infinity,
                          padding:  EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentPlan!.title,
                                style:  TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                               SizedBox(height: 6),
                              Text(
                                currentPlan!.description.isEmpty
                                    ? "You already have a plan."
                                    : currentPlan!.description,
                                style:  TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                         SizedBox(height: 18),
                      ],

                      _ClipboardIllustration(green: green),

                       SizedBox(height: 22),

                      _featureRow(
                        text: "Breakfast, lunch, and dinner meals",
                        icon: Icons.assignment_outlined,
                      ),
                       SizedBox(height: 14),
                      _featureRow(
                        text: "Designed for your goals and preferences",
                        icon: Icons.star_border,
                      ),
                       SizedBox(height: 14),
                      _featureRow(
                        text: "Balanced protein, fats, carbs, and fiber",
                        icon: Icons.pie_chart_outline,
                      ),
                       Spacer(),
                       SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: creating ? null : _createMealPlan,
                          icon: creating
                              ?  SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                              :  Icon(Icons.add, size: 22),
                          label: Text(
                            creating ? "Creating..." : "Create Meal Plan",
                            style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _featureRow({required String text, required IconData icon}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style:  TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
         SizedBox(width: 12),
        Icon(icon, color: green, size: 28),
      ],
    );
  }
  void onOpenSettings() {}
  void onOpenPurchases() {}
  void onOpenHistory() {}
  void onOpenRecipes() {}
}

Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.green),
    title: Text(title, style:  TextStyle(fontWeight: FontWeight.w600)),
    onTap: onTap,
  );
}

class _ClipboardIllustration extends StatelessWidget {
  const _ClipboardIllustration({required this.green});

  final Color green;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 160,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black12),
              boxShadow:  [
                BoxShadow(
                  blurRadius: 18,
                  offset: Offset(0, 10),
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            child: Container(
              width: 70,
              height: 24,
              decoration: BoxDecoration(
                color:  Colors.amber,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            top: 50,
            child: Text(
              "MEAL PLAN",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: green,
                fontSize: 16,
                letterSpacing: 1,
              ),
            ),
          ),
          Positioned(
            top: 86,
            left: 48,
            child: Column(
              children: [
                Icon(Icons.local_cafe, color: green, size: 18),
                 SizedBox(height: 16),
                Icon(Icons.ramen_dining, color: green, size: 18),
                 SizedBox(height: 16),
                Icon(Icons.restaurant, color: green, size: 18),
              ],
            ),
          ),
          Positioned(
            top: 90,
            left: 78,
            child: Column(
              children: [
                _line(),
                 SizedBox(height: 18),
                _line(),
                 SizedBox(height: 18),
                _line(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
      width: 60,
      height: 6,
      decoration: BoxDecoration(
        color:  Colors.lime,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
