import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/uite/recipe_filter.dart';

class FiltersPage extends StatefulWidget {
  FiltersPage({
    super.key,
    required this.initial,
    this.totalRecipesCount = 0,
  });

  final RecipeFiltersSelection initial;
  final int totalRecipesCount;

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  late RecipeFiltersSelection selection;
  TextEditingController searchCtrl = TextEditingController();

  Color primaryColor = Colors.blueGrey;

  List<_ChipItem> mealTimes = [
    _ChipItem(keyName: 'breakfast', labelKey: 'filters.breakfast', icon: Icons.wb_sunny_outlined),
    _ChipItem(keyName: 'lunch', labelKey: 'filters.lunch', icon: Icons.wb_sunny),
    _ChipItem(keyName: 'dinner', labelKey: 'filters.dinner', icon: Icons.nightlight_outlined),
  ];

  List<_CircleItem> includeIngredients = [
    _CircleItem(keyName: 'chickpeas', labelKey: 'filters.chickpeas', emoji: ''),
    _CircleItem(keyName: 'butter', labelKey: 'filters.butter', emoji: ''),
    _CircleItem(keyName: 'mushroom', labelKey: 'filters.mushroom', emoji: ''),
    _CircleItem(keyName: 'tofu', labelKey: 'filters.tofu', emoji: ''),
    _CircleItem(keyName: 'rice', labelKey: 'filters.rice', emoji: ''),
    _CircleItem(keyName: 'pasta', labelKey: 'filters.pasta', emoji: ''),
    _CircleItem(keyName: 'peas', labelKey: 'filters.peas', emoji: ''),
    _CircleItem(keyName: 'beet', labelKey: 'filters.beet', emoji: ''),
  ];

  List<_FlagItem> cuisines = [
    _FlagItem(keyName: 'chinese', labelKey: 'filters.chinese', emoji: '🇨🇳'),
    _FlagItem(keyName: 'american', labelKey: 'filters.american', emoji: '🇺🇸'),
    _FlagItem(keyName: 'asian', labelKey: 'filters.asian', emoji: '🇯🇵'),
    _FlagItem(keyName: 'mexican', labelKey: 'filters.mexican', emoji: '🇲🇽'),
    _FlagItem(keyName: 'italian', labelKey: 'filters.italian', emoji: '🇮🇹'),
    _FlagItem(keyName: 'indian', labelKey: 'filters.indian', emoji: '🇮🇳'),
  ];

  List<_CircleItem> diets = [
    _CircleItem(keyName: 'plant', labelKey: 'filters.plant', emoji: ''),
    _CircleItem(keyName: 'keto', labelKey: 'filters.keto', emoji: ''),
    _CircleItem(keyName: 'lowcarb', labelKey: 'filters.lowcarb', emoji: ''),
    _CircleItem(keyName: 'clean', labelKey: 'filters.clean', emoji: ''),
    _CircleItem(keyName: 'med', labelKey: 'filters.med', emoji: ''),
    _CircleItem(keyName: 'flex', labelKey: 'filters.flex', emoji: ''),
  ];

  List<_CircleItem> excludeIngredients = [
    _CircleItem(keyName: 'ginger', labelKey: 'filters.ginger', emoji: ''),
    _CircleItem(keyName: 'egg', labelKey: 'filters.egg', emoji: ''),
    _CircleItem(keyName: 'beef', labelKey: 'filters.beef', emoji: ''),
    _CircleItem(keyName: 'kale', labelKey: 'filters.kale', emoji: ''),
    _CircleItem(keyName: 'lamb', labelKey: 'filters.lamb', emoji: ''),
    _CircleItem(keyName: 'honey', labelKey: 'filters.honey', emoji: ''),
    _CircleItem(keyName: 'avocado', labelKey: 'filters.avocado', emoji: ''),
    _CircleItem(keyName: 'tuna', labelKey: 'filters.tuna', emoji: ''),
  ];

  List<int> cookTimes = [15, 30, 60];

  List<_IconTile> foodExclusions = [
    _IconTile(keyName: 'lactose_free', labelKey: 'filters.lactose_free', icon: Icons.local_drink_outlined),
    _IconTile(keyName: 'dairy_free', labelKey: 'filters.dairy_free', icon: Icons.water_drop_outlined),
    _IconTile(keyName: 'gluten_free', labelKey: 'filters.gluten_free', icon: Icons.grass_outlined),
    _IconTile(keyName: 'kosher', labelKey: 'filters.kosher', icon: Icons.food_bank_outlined),
    _IconTile(keyName: 'halal', labelKey: 'filters.halal', icon: Icons.verified_outlined),
    _IconTile(keyName: 'alcohol_free', labelKey: 'filters.alcohol_free', icon: Icons.wine_bar_outlined),
  ];

  List<_IconTile> medicalDiets = [
    _IconTile(keyName: 'dash', labelKey: 'filters.dash', icon: Icons.favorite_outline),
    _IconTile(keyName: 'diabetes', labelKey: 'filters.diabetes', icon: Icons.bloodtype_outlined),
    _IconTile(keyName: 'low_fodmap', labelKey: 'filters.low_fodmap', icon: Icons.bubble_chart_outlined),
    _IconTile(keyName: 'mind', labelKey: 'filters.mind', icon: Icons.psychology_alt_outlined),
    _IconTile(keyName: 'anti_inflam', labelKey: 'filters.anti_inflam', icon: Icons.local_fire_department_outlined),
    _IconTile(keyName: 'low_sodium', labelKey: 'filters.low_sodium', icon: Icons.soup_kitchen_outlined),
  ];

  @override
  void initState() {
    super.initState();
    selection = widget.initial;
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  bool _matchSearch(String text) {
    final q = searchCtrl.text.trim().toLowerCase();
    if (q.isEmpty) return true;
    return text.toLowerCase().contains(q);
  }

  void _toggleInSet(Set<String> set, String keyName, void Function(Set<String>) apply) {
    final next = <String>{...set};
    if (next.contains(keyName)) {
      next.remove(keyName);
    } else {
      next.add(keyName);
    }
    apply(next);
  }

  void _clearAll() {
    setState(() => selection = selection.cleared());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.tune, color: Colors.white),
                ),
                if (selection.selectedCount > 0)
                  Positioned(
                    top: -8,
                    left: -8,
                    child: Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.lightGreenAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${selection.selectedCount}",
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "filters.search".tr(),
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            TextButton(
              onPressed: _clearAll,
              child: Text(
                "filters.clear".tr(),
                style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800),
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_forward_ios, color: Colors.black87),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              _sectionTitle("filters.meal_time".tr()),
              SizedBox(height: 10),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: mealTimes.map((m) {
                  final label = m.labelKey.tr();
                  if (!_matchSearch(label)) return SizedBox();

                  final selectedNow = selection.mealTimes.contains(m.keyName);

                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 16 * 2 - 12 * 2) / 3,
                    child: _timeChip(
                      label: label,
                      icon: m.icon,
                      selected: selectedNow,
                      borderColor: selectedNow ? primaryColor : Colors.black12,
                      onTap: () {
                        setState(() {
                          _toggleInSet(selection.mealTimes, m.keyName, (next) {
                            selection = selection.copyWith(mealTimes: next);
                          });
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 14),

              _cardSection(
                title: "filters.include_ingredients".tr(),
                child: _circleGrid(
                  items: includeIngredients,
                  selectedKeys: selection.includeIngredients,
                  onToggle: (k) => setState(() {
                    _toggleInSet(selection.includeIngredients, k, (next) {
                      selection = selection.copyWith(includeIngredients: next);
                    });
                  }),
                ),
              ),

              SizedBox(height: 14),

              _cardSection(
                title: "filters.cuisines".tr(),
                child: _flagGrid(
                  items: cuisines,
                  selectedKeys: selection.cuisines,
                  onToggle: (k) => setState(() {
                    _toggleInSet(selection.cuisines, k, (next) {
                      selection = selection.copyWith(cuisines: next);
                    });
                  }),
                ),
              ),

              SizedBox(height: 14),

              _cardSection(
                title: "filters.diets".tr(),
                child: _circleGrid(
                  items: diets,
                  selectedKeys: selection.diets,
                  onToggle: (k) => setState(() {
                    _toggleInSet(selection.diets, k, (next) {
                      selection = selection.copyWith(diets: next);
                    });
                  }),
                ),
              ),

              SizedBox(height: 14),

              _cardSection(
                title: "filters.exclude_ingredients".tr(),
                child: _circleGrid(
                  items: excludeIngredients,
                  selectedKeys: selection.excludeIngredients,
                  onToggle: (k) => setState(() {
                    _toggleInSet(selection.excludeIngredients, k, (next) {
                      selection = selection.copyWith(excludeIngredients: next);
                    });
                  }),
                ),
              ),

              SizedBox(height: 14),

              _sectionTitle("filters.cook_time".tr()),
              SizedBox(height: 10),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cookTimes.map((min) {
                  final selectedNow = selection.maxCookMinutes == min;
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 16 * 2 - 12 * 2) / 3,
                    child: _timeTextChip(
                      label: "filters.less_equal_minutes".tr(args: ["$min"]),
                      selected: selectedNow,
                      borderColor: selectedNow ? primaryColor : Colors.black12,
                      onTap: () {
                        setState(() {
                          selection = selection.copyWith(
                            maxCookMinutes: selectedNow ? null : min,
                            clearCookTime: selectedNow,
                          );
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 14),

              _cardSection(
                title: "filters.medical_diets".tr(),
                child: _iconGrid(
                  items: medicalDiets,
                  selectedKeys: selection.medicalDiets,
                  onToggle: (k) => setState(() {
                    _toggleInSet(selection.medicalDiets, k, (next) {
                      selection = selection.copyWith(medicalDiets: next);
                    });
                  }),
                ),
              ),

              SizedBox(height: 14),

              _cardSection(
                title: "filters.food_exclusions".tr(),
                child: _iconGrid(
                  items: foodExclusions,
                  selectedKeys: selection.foodExclusions,
                  onToggle: (k) => setState(() {
                    _toggleInSet(selection.foodExclusions, k, (next) {
                      selection = selection.copyWith(foodExclusions: next);
                    });
                  }),
                ),
              ),

              SizedBox(height: 16),
            ],
          ),

          Positioned(
            right: 16,
            left: 16,
            bottom: 18,
            child: SizedBox(
              height: 58,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 6,
                ),
                onPressed: () {
                  Navigator.pop(context, selection);
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "filters.show_recipes".tr(args: ["${widget.totalRecipesCount}"]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
    );
  }

  Widget _cardSection({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text("filters.view_all".tr(), style: TextStyle(fontWeight: FontWeight.w800)),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _timeChip({
    required String label,
    required IconData icon,
    required bool selected,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeTextChip({
    required String label,
    required bool selected,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _circleGrid({
    required List<_CircleItem> items,
    required Set<String> selectedKeys,
    required void Function(String keyName) onToggle,
  }) {
    final filtered = items.where((e) => _matchSearch(e.labelKey.tr())).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, i) {
        final it = filtered[i];
        final selected = selectedKeys.contains(it.keyName);

        return InkWell(
          onTap: () => onToggle(it.keyName),
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(it.emoji, style: TextStyle(fontSize: 22)),
                  ),
                  if (selected)
                    Positioned(
                      top: -2,
                      left: -2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                it.labelKey.tr(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _flagGrid({
    required List<_FlagItem> items,
    required Set<String> selectedKeys,
    required void Function(String keyName) onToggle,
  }) {
    final filtered = items.where((e) => _matchSearch(e.labelKey.tr())).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 10,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, i) {
        final it = filtered[i];
        final selected = selectedKeys.contains(it.keyName);

        return InkWell(
          onTap: () => onToggle(it.keyName),
          borderRadius: BorderRadius.circular(14),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(it.emoji, style: TextStyle(fontSize: 24)),
                  ),
                  if (selected)
                    Positioned(
                      top: -2,
                      left: -2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(it.labelKey.tr(), style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        );
      },
    );
  }

  Widget _iconGrid({
    required List<_IconTile> items,
    required Set<String> selectedKeys,
    required void Function(String keyName) onToggle,
  }) {
    final filtered = items.where((e) => _matchSearch(e.labelKey.tr())).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, i) {
        final it = filtered[i];
        final selected = selectedKeys.contains(it.keyName);

        return InkWell(
          onTap: () => onToggle(it.keyName),
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(it.icon, size: 24),
                    ),
                    SizedBox(height: 10),
                    Text(
                      it.labelKey.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              if (selected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ChipItem {
  final String keyName;
  final String labelKey;
  final IconData icon;
  _ChipItem({required this.keyName, required this.labelKey, required this.icon});
}

class _CircleItem {
  final String keyName;
  final String labelKey;
  final String emoji;
  _CircleItem({required this.keyName, required this.labelKey, required this.emoji});
}

class _FlagItem {
  final String keyName;
  final String labelKey;
  final String emoji;
  _FlagItem({required this.keyName, required this.labelKey, required this.emoji});
}

class _IconTile {
  final String keyName;
  final String labelKey;
  final IconData icon;
  _IconTile({required this.keyName, required this.labelKey, required this.icon});
}
