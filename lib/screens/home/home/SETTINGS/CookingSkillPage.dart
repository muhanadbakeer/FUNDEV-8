import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/cooking_skill_api.dart';

class CookingSkillPage extends StatefulWidget {
  CookingSkillPage({super.key});

  @override
  State<CookingSkillPage> createState() => _CookingSkillPageState();
}

class _CookingSkillPageState extends State<CookingSkillPage> {
  bool loading = true;
  String selected = "Novice";

  final String userId = "1";

  late List<_SkillItem> items;

  @override
  void initState() {
    super.initState();

    items = [
      _SkillItem(
        keyName: "Novice",
        title: "Novice",
        quote: "I can cook sandwich",
        helper: "We'll get started with delicious,\nbeginner-friendly recipes!",
        icon: Icons.layers_outlined,
      ),
      _SkillItem(
        keyName: "Basic",
        title: "Basic",
        quote: "I cook only simple recipes",
        helper: "",
        icon: Icons.ramen_dining_outlined,
      ),
      _SkillItem(
        keyName: "Intermediate",
        title: "Intermediate",
        quote: "I regularly try new recipes",
        helper: "",
        icon: Icons.restaurant_outlined,
      ),
      _SkillItem(
        keyName: "Advanced",
        title: "Advanced",
        quote: "I can cook any recipe",
        helper: "",
        icon: Icons.set_meal_outlined,
      ),
    ];

    _init();
  }

  Future<void> _init() async {
    try {
      final v = await CookingSkillApi.getSkill(userId);
      if (v.toString().trim().isNotEmpty) {
        selected = v.toString();
      }
    } catch (_) {}
    setState(() => loading = false);
  }

  Future<void> _save() async {
    await CookingSkillApi.saveSkill(userId, selected);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final green = Colors.green;
    final bg = Colors.blueGrey.shade50;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator(color: green))
            : Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Cooking skills".tr(),
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
              padding: EdgeInsets.fromLTRB(18, 0, 18, 12),
              child: Text(
                "How would you describe your cooking skills?".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 90),
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final it = items[i];
                  final isSelected = selected == it.keyName;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 14),
                    child: _SkillCard(
                      title: it.title.tr(),
                      quote: it.quote.tr(),
                      helper: it.helper.isEmpty ? "" : it.helper.tr(),
                      icon: it.icon,
                      selected: isSelected,
                      accent: green,
                      onTap: () {
                        setState(() => selected = it.keyName);
                      },
                    ),
                  );
                },
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
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

class _SkillItem {
  final String keyName;
  final String title;
  final String quote;
  final String helper;
  final IconData icon;

  _SkillItem({
    required this.keyName,
    required this.title,
    required this.quote,
    required this.helper,
    required this.icon,
  });
}

class _SkillCard extends StatelessWidget {
  _SkillCard({
    required this.title,
    required this.quote,
    required this.helper,
    required this.icon,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String quote;
  final String helper;
  final IconData icon;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? Colors.blueGrey.shade700 : Colors.black12,
            width: selected ? 1.4 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 8),
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Icon(icon, size: 30, color: accent),
                ),
                if (selected)
                  Positioned(
                    top: -10,
                    left: -10,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 18, color: Colors.white),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            title,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "“$quote”",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  if (helper.trim().isNotEmpty) ...[
                    SizedBox(height: 10),
                    Divider(height: 1, color: Colors.black12),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        helper,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
