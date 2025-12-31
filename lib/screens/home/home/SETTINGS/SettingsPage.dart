import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'InfoPage.dart';
import 'LanguagePage.dart';
import 'MacrosGoalPage.dart';
import 'CalorieGoalPage.dart';
import 'DietPreferencePage.dart';
import 'AllergensPage.dart';
import 'FavoriteCuisinesPage.dart';
import 'CookingSkillPage.dart';
import 'MealsPerDayPage.dart';
import 'UnitsPage.dart';
import 'MealSchedulePage.dart';
import 'MealPrioritiesPage.dart';

// ✅ APIs
import 'package:div/screens/home/api_home/calorie_goal_api.dart';
import 'package:div/screens/home/api_home/macros_goal_api.dart';
import 'package:div/screens/home/api_home/diet_preference_api.dart';
import 'package:div/screens/home/api_home/allergens_api.dart';
import 'package:div/screens/home/api_home/favorite_cuisines_api.dart';
import 'package:div/screens/home/api_home/cooking_skill_api.dart';
import 'package:div/screens/home/api_home/meals_per_day_api.dart';
import 'package:div/screens/home/api_home/meal_schedule_api.dart';
import 'package:div/screens/home/api_home/meal_priorities_api.dart';
import 'package:div/screens/home/api_home/units_api.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, this.embedded = false});
  final bool embedded;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool loading = true;

  final String userId = "1"; // مؤقت – من Auth لاحقاً

  String accountPlan = "Free";

  int caloriesGoal = 0;
  String macrosGoal = "";
  String dietPreference = "";
  String allergensCount = "0";
  String cuisinesCount = "0";
  String cookingSkill = "";
  int mealsPerDay = 0;
  String units = "";
  String mealSchedule = "";
  String mealPriorities = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (mounted) setState(() => loading = true);

    try {
      final cal = await CalorieGoalApi.getGoal(userId);
      final macros = await MacrosGoalApi.getMacros(userId);
      final diet = await DietPreferenceApi.getPreference(userId);
      final all = await AllergensApi.getAllergens(userId);
      final cui = await FavoriteCuisinesApi.getCuisines(userId);
      final skill = await CookingSkillApi.getSkill(userId);
      final mpd = await MealsPerDayApi.getMeals(userId);
      final u = await UnitsApi.getUnits(userId);
      final schedule = await MealScheduleApi.getSchedule(userId);
      final pr = await MealPrioritiesApi.getPriorities(userId);

      if (!mounted) return;

      setState(() {
        caloriesGoal = cal;
        macrosGoal = "${macros["p"]}%, ${macros["c"]}%, ${macros["f"]}%";
        dietPreference = diet;
        allergensCount = "${all.length}";
        cuisinesCount = "${cui.length}";
        cookingSkill = skill;
        mealsPerDay = mpd;
        units = u;
        mealSchedule = schedule;
        mealPriorities = pr.join(", ");
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = loading
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
        children: [
          _headerTitle(),

          _sectionTitle("settings.account".tr()),
          _settingsTile(
            title: "settings.upgradeToPro".tr(),
            leading: Icons.workspace_premium_outlined,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.upgradeToPro".tr(),
              "This is a placeholder page.",
            ),
          ),
          _settingsTile(
            title: "settings.restoreSubscription".tr(),
            leading: Icons.refresh,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.restoreSubscription".tr(),
              "Restore subscription placeholder.",
            ),
          ),
          _settingsTile(
            title: "settings.signIn".tr(),
            leading: Icons.login,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.signIn".tr(),
              "Sign in placeholder.",
            ),
          ),
          _settingsTile(
            title: "settings.rateUs".tr(),
            leading: Icons.star_border,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.rateUs".tr(),
              "Rate us placeholder.",
            ),
            showDivider: false,
          ),

          const SizedBox(height: 8),

          _sectionTitle("settings.nutrition".tr()),
          _settingsTile(
            title: "settings.calorieGoal".tr(),
            leading: Icons.local_fire_department_outlined,
            trailingText: "$caloriesGoal kcal",
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalorieGoalPage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.macrosGoal".tr(),
            leading: Icons.pie_chart_outline,
            trailingText: macrosGoal,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MacrosGoalPage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.dietPreference".tr(),
            leading: Icons.favorite_border,
            trailingText: dietPreference,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DietPreferencePage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.allergens".tr(),
            leading: Icons.block,
            trailingText: allergensCount,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AllergensPage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.favoriteCuisines".tr(),
            leading: Icons.restaurant_menu,
            trailingText: cuisinesCount,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoriteCuisinesPage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.cookingSkill".tr(),
            leading: Icons.soup_kitchen_outlined,
            trailingText: cookingSkill,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CookingSkillPage()),
              );
              _loadData();
            },
            showDivider: false,
          ),

          const SizedBox(height: 8),

          _sectionTitle("settings.mealPlan".tr()),
          _settingsTile(
            title: "settings.mealsPerDay".tr(),
            leading: Icons.receipt_long_outlined,
            trailingText: "$mealsPerDay",
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MealsPerDayPage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.mealSchedule".tr(),
            leading: Icons.schedule,
            trailingText: mealSchedule,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MealSchedulePage()),
              );
              _loadData();
            },
          ),
          _settingsTile(
            title: "settings.mealPlanPriorities".tr(),
            leading: Icons.tune,
            trailingText: mealPriorities,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MealPrioritiesPage()),
              );
              _loadData();
            },
            showDivider: false,
          ),

          const SizedBox(height: 8),

          _sectionTitle("settings.general".tr()),
          _settingsTile(
            title: "settings.language".tr(),
            leading: Icons.language,
            trailingText:
            context.locale.languageCode == "ar" ? "Arabic" : "English",
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LanguagePage()),
              );
              if (mounted) setState(() {});
            },
          ),
          _settingsTile(
            title: "settings.units".tr(),
            leading: Icons.straighten,
            trailingText: units,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UnitsPage()),
              );
              _loadData();
            },
            showDivider: false,
          ),

          const SizedBox(height: 8),

          _sectionTitle("settings.support".tr()),
          _settingsTile(
            title: "settings.privacyPolicy".tr(),
            leading: Icons.lock_outline,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.privacyPolicy".tr(),
              "Privacy policy placeholder.",
            ),
          ),
          _settingsTile(
            title: "settings.terms".tr(),
            leading: Icons.description_outlined,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.terms".tr(),
              "Terms placeholder.",
            ),
          ),
          _settingsTile(
            title: "settings.recommendationSource".tr(),
            leading: Icons.info_outline,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.recommendationSource".tr(),
              "Recommendation source placeholder.",
            ),
          ),
          _settingsTile(
            title: "settings.contactUs".tr(),
            leading: Icons.mail_outline,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.contactUs".tr(),
              "Contact us placeholder.",
            ),
            showDivider: false,
          ),

          const SizedBox(height: 8),

          _sectionTitle("settings.access".tr()),
          _settingsTile(
            title: "settings.deleteAccount".tr(),
            leading: Icons.delete_outline,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.deleteAccount".tr(),
              "Delete account placeholder.",
            ),
          ),
          _settingsTile(
            title: "settings.referralCode".tr(),
            leading: Icons.qr_code_2,
            trailingText: null,
            onTap: () => _openInfo(
              "settings.referralCode".tr(),
              "Referral code placeholder.",
            ),
            showDivider: false,
          ),
        ],
      ),
    );

    if (widget.embedded) {
      return Container(color: Colors.grey.shade100, child: body);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "settings.title".tr(),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              accountPlan,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  void _openInfo(String title, String desc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InfoPage(infoKey: title),
      ),

    );
  }

  Widget _headerTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Text(
        "settings.title".tr(),
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(
        text,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _settingsTile({
    required String title,
    required IconData leading,
    String? trailingText,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.chevron_left, color: Colors.black54),
                  const SizedBox(width: 10),
                  if (trailingText != null)
                    Expanded(
                      child: Text(
                        trailingText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else
                    const Expanded(child: SizedBox()),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(leading, color: Colors.black87),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
      ],
    );
  }
}
