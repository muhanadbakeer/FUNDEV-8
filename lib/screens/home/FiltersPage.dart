import 'package:flutter/material.dart';
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
  final TextEditingController searchCtrl = TextEditingController();

  final Color primaryDark = Colors.green;
  final Color bg = Colors.grey.shade100;
  final Color card = Colors.white;
  final Color border = Colors.grey.shade300;
  final Color textStrong = Colors.black87;
  final Color textSoft = Colors.grey;
  final Color selectedFill = Colors.green.shade50;

  final List<_ChipItem> mealTimes = [
    _ChipItem(keyName: 'breakfast', label: 'Breakfast', icon: Icons.wb_sunny_outlined),
    _ChipItem(keyName: 'lunch', label: 'Lunch', icon: Icons.wb_sunny),
    _ChipItem(keyName: 'dinner', label: 'Dinner', icon: Icons.nightlight_outlined),
  ];

  final List<_CircleItem> includeIngredients = [
    _CircleItem(keyName: 'chickpeas', label: 'Chickpeas', emoji: '🫘'),
    _CircleItem(keyName: 'butter', label: 'Butter', emoji: '🧈'),
    _CircleItem(keyName: 'mushroom', label: 'Mushroom', emoji: '🍄'),
    _CircleItem(keyName: 'tofu', label: 'Tofu', emoji: '🍱'),
    _CircleItem(keyName: 'rice', label: 'Rice', emoji: '🍚'),
    _CircleItem(keyName: 'pasta', label: 'Pasta', emoji: '🍝'),
    _CircleItem(keyName: 'peas', label: 'Peas', emoji: '🟢'),
    _CircleItem(keyName: 'beet', label: 'Beet', emoji: '🫜'),
  ];

  final List<_FlagItem> cuisines = [
    _FlagItem(keyName: 'chinese', label: 'Chinese', emoji: '🇨🇳'),
    _FlagItem(keyName: 'american', label: 'American', emoji: '🇺🇸'),
    _FlagItem(keyName: 'asian', label: 'Asian', emoji: '🇯🇵'),
    _FlagItem(keyName: 'mexican', label: 'Mexican', emoji: '🇲🇽'),
    _FlagItem(keyName: 'italian', label: 'Italian', emoji: '🇮🇹'),
    _FlagItem(keyName: 'indian', label: 'Indian', emoji: '🇮🇳'),
  ];

  final List<_CircleItem> diets = [
    _CircleItem(keyName: 'plant', label: 'Plant-based', emoji: '🥗'),
    _CircleItem(keyName: 'keto', label: 'Keto', emoji: '🥩'),
    _CircleItem(keyName: 'lowcarb', label: 'Low carb', emoji: '🍗'),
    _CircleItem(keyName: 'clean', label: 'Clean', emoji: '🌿'),
    _CircleItem(keyName: 'med', label: 'Mediterranean', emoji: '🫒'),
    _CircleItem(keyName: 'flex', label: 'Flexitarian', emoji: '🍽️'),
  ];

  final List<_CircleItem> excludeIngredients = [
    _CircleItem(keyName: 'ginger', label: 'Ginger', emoji: '🫚'),
    _CircleItem(keyName: 'egg', label: 'Egg', emoji: '🥚'),
    _CircleItem(keyName: 'beef', label: 'Beef', emoji: '🥩'),
    _CircleItem(keyName: 'kale', label: 'Kale', emoji: '🥬'),
    _CircleItem(keyName: 'lamb', label: 'Lamb', emoji: '🍖'),
    _CircleItem(keyName: 'honey', label: 'Honey', emoji: '🍯'),
    _CircleItem(keyName: 'avocado', label: 'Avocado', emoji: '🥑'),
    _CircleItem(keyName: 'tuna', label: 'Tuna', emoji: '🐟'),
  ];

  final List<int> cookTimes = [15, 30, 60];

  final List<_IconTile> foodExclusions = [
    _IconTile(keyName: 'lactose_free', label: 'Lactose free', icon: Icons.local_drink_outlined),
    _IconTile(keyName: 'dairy_free', label: 'Dairy free', icon: Icons.water_drop_outlined),
    _IconTile(keyName: 'gluten_free', label: 'Gluten free', icon: Icons.grass_outlined),
    _IconTile(keyName: 'kosher', label: 'Kosher', icon: Icons.food_bank_outlined),
    _IconTile(keyName: 'halal', label: 'Halal', icon: Icons.verified_outlined),
    _IconTile(keyName: 'alcohol_free', label: 'Alcohol free', icon: Icons.wine_bar_outlined),
  ];

  final List<_IconTile> medicalDiets = [
    _IconTile(keyName: 'dash', label: 'DASH', icon: Icons.favorite_outline),
    _IconTile(keyName: 'diabetes', label: 'Diabetes', icon: Icons.bloodtype_outlined),
    _IconTile(keyName: 'low_fodmap', label: 'Low FODMAP', icon: Icons.bubble_chart_outlined),
    _IconTile(keyName: 'mind', label: 'MIND', icon: Icons.psychology_alt_outlined),
    _IconTile(keyName: 'anti_inflam', label: 'Anti-inflam', icon: Icons.local_fire_department_outlined),
    _IconTile(keyName: 'low_sodium', label: 'Low sodium', icon: Icons.soup_kitchen_outlined),
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

  void _clearAll() => setState(() => selection = selection.cleared());
  void _applyAndClose() => Navigator.pop(context, selection);

  // =======================
  // View All Bottom Sheet
  // =======================
  Future<void> _openViewAll({
    required String title,
    required List<_ViewAllItem> items,
    required Set<String> selectedKeys,
    required void Function(String keyName) onToggle,
    required void Function(Set<String> next) onSetAll,
  }) async {
    final TextEditingController ctrl = TextEditingController();
    final FocusNode focus = FocusNode();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            final query = ctrl.text.trim().toLowerCase();
            final filtered = items.where((e) {
              if (query.isEmpty) return true;
              return e.label.toLowerCase().contains(query);
            }).toList();

            void selectAllFiltered() {
              final next = <String>{...selectedKeys};
              for (final it in filtered) {
                next.add(it.keyName);
              }
              onSetAll(next);
              setLocal(() {});
            }

            void clearAllFiltered() {
              final next = <String>{...selectedKeys};
              for (final it in filtered) {
                next.remove(it.keyName);
              }
              onSetAll(next);
              setLocal(() {});
            }

            return Container(
              height: MediaQuery.of(ctx).size.height * 0.86,
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  SizedBox(height: 12),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textStrong),
                          ),
                        ),
                        TextButton(
                          onPressed: filtered.isEmpty ? null : selectAllFiltered,
                          child: Text(
                            "Select all",
                            style: TextStyle(fontWeight: FontWeight.w900, color: primaryDark),
                          ),
                        ),
                        TextButton(
                          onPressed: filtered.isEmpty ? null : clearAllFiltered,
                          child: Text(
                            "Clear",
                            style: TextStyle(fontWeight: FontWeight.w900, color: textSoft),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: border),
                      ),
                      child: TextField(
                        controller: ctrl,
                        focusNode: focus,
                        onChanged: (_) => setLocal(() {}),
                        decoration: InputDecoration(
                          hintText: "Search...",
                          prefixIcon: Icon(Icons.search, color: textSoft),
                          suffixIcon: ctrl.text.isEmpty
                              ? null
                              : IconButton(
                            onPressed: () {
                              ctrl.clear();
                              setLocal(() {});
                              FocusScope.of(ctx).requestFocus(focus);
                            },
                            icon: Icon(Icons.close, color: textSoft),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      itemCount: filtered.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 10,
                        mainAxisExtent: 112,
                      ),
                      itemBuilder: (context, i) {
                        final it = filtered[i];
                        final selected = selectedKeys.contains(it.keyName);

                        return InkWell(
                          onTap: () {
                            onToggle(it.keyName);
                            setLocal(() {});
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      color: selected ? selectedFill : Colors.grey.shade200,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected ? primaryDark : Colors.transparent,
                                        width: 1.2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: it.widget,
                                  ),
                                  if (selected)
                                    Positioned(
                                      top: -2,
                                      left: -2,
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: BoxDecoration(color: primaryDark, shape: BoxShape.circle),
                                        child: Icon(Icons.check, size: 16, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                it.label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textStrong, height: 1.1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: SizedBox(
                      height: 54,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                          elevation: 4,
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          "Done",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    ctrl.dispose();
    focus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: textStrong,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
          tooltip: "Back",
        ),
        title: Text("Filters", style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              "Clear",
              style: TextStyle(color: primaryDark, fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(width: 6),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 120),
            children: [
              _topSearchBar(),
              SizedBox(height: 16),

              _sectionTitle("Meal time"),
              SizedBox(height: 10),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: mealTimes.map((m) {
                  final label = m.label;
                  if (!_matchSearch(label)) return SizedBox.shrink();

                  final selectedNow = selection.mealTimes.contains(m.keyName);

                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 16 * 2 - 12 * 2) / 3,
                    child: _timeChip(
                      label: label,
                      icon: m.icon,
                      selected: selectedNow,
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
                title: "Include ingredients",
                onViewAll: () async {
                  await _openViewAll(
                    title: "Include ingredients",
                    items: includeIngredients
                        .map((e) => _ViewAllItem(keyName: e.keyName, label: e.label, widget: Text(e.emoji, style: TextStyle(fontSize: 22))))
                        .toList(),
                    selectedKeys: selection.includeIngredients,
                    onToggle: (k) => setState(() {
                      _toggleInSet(selection.includeIngredients, k, (next) {
                        selection = selection.copyWith(includeIngredients: next);
                      });
                    }),
                    onSetAll: (next) => setState(() {
                      selection = selection.copyWith(includeIngredients: next);
                    }),
                  );
                },
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
                title: "Cuisines",
                onViewAll: () async {
                  await _openViewAll(
                    title: "Cuisines",
                    items: cuisines
                        .map((e) => _ViewAllItem(keyName: e.keyName, label: e.label, widget: Text(e.emoji, style: TextStyle(fontSize: 24))))
                        .toList(),
                    selectedKeys: selection.cuisines,
                    onToggle: (k) => setState(() {
                      _toggleInSet(selection.cuisines, k, (next) {
                        selection = selection.copyWith(cuisines: next);
                      });
                    }),
                    onSetAll: (next) => setState(() {
                      selection = selection.copyWith(cuisines: next);
                    }),
                  );
                },
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
                title: "Diets",
                onViewAll: () async {
                  await _openViewAll(
                    title: "Diets",
                    items: diets
                        .map((e) => _ViewAllItem(keyName: e.keyName, label: e.label, widget: Text(e.emoji, style: TextStyle(fontSize: 22))))
                        .toList(),
                    selectedKeys: selection.diets,
                    onToggle: (k) => setState(() {
                      _toggleInSet(selection.diets, k, (next) {
                        selection = selection.copyWith(diets: next);
                      });
                    }),
                    onSetAll: (next) => setState(() {
                      selection = selection.copyWith(diets: next);
                    }),
                  );
                },
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
                title: "Exclude ingredients",
                onViewAll: () async {
                  await _openViewAll(
                    title: "Exclude ingredients",
                    items: excludeIngredients
                        .map((e) => _ViewAllItem(keyName: e.keyName, label: e.label, widget: Text(e.emoji, style: TextStyle(fontSize: 22))))
                        .toList(),
                    selectedKeys: selection.excludeIngredients,
                    onToggle: (k) => setState(() {
                      _toggleInSet(selection.excludeIngredients, k, (next) {
                        selection = selection.copyWith(excludeIngredients: next);
                      });
                    }),
                    onSetAll: (next) => setState(() {
                      selection = selection.copyWith(excludeIngredients: next);
                    }),
                  );
                },
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
              _sectionTitle("Cook time"),
              SizedBox(height: 10),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: cookTimes.map((min) {
                  final selectedNow = selection.maxCookMinutes == min;
                  return SizedBox(
                    width: (MediaQuery.of(context).size.width - 16 * 2 - 12 * 2) / 3,
                    child: _timeTextChip(
                      label: "≤ $min min",
                      selected: selectedNow,
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
                title: "Medical diets",
                onViewAll: () async {
                  await _openViewAll(
                    title: "Medical diets",
                    items: medicalDiets
                        .map((e) => _ViewAllItem(keyName: e.keyName, label: e.label, widget: Icon(e.icon, color: textSoft)))
                        .toList(),
                    selectedKeys: selection.medicalDiets,
                    onToggle: (k) => setState(() {
                      _toggleInSet(selection.medicalDiets, k, (next) {
                        selection = selection.copyWith(medicalDiets: next);
                      });
                    }),
                    onSetAll: (next) => setState(() {
                      selection = selection.copyWith(medicalDiets: next);
                    }),
                  );
                },
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
                title: "Food exclusions",
                onViewAll: () async {
                  await _openViewAll(
                    title: "Food exclusions",
                    items: foodExclusions
                        .map((e) => _ViewAllItem(keyName: e.keyName, label: e.label, widget: Icon(e.icon, color: textSoft)))
                        .toList(),
                    selectedKeys: selection.foodExclusions,
                    onToggle: (k) => setState(() {
                      _toggleInSet(selection.foodExclusions, k, (next) {
                        selection = selection.copyWith(foodExclusions: next);
                      });
                    }),
                    onSetAll: (next) => setState(() {
                      selection = selection.copyWith(foodExclusions: next);
                    }),
                  );
                },
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
                  backgroundColor: primaryDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 6,
                ),
                onPressed: _applyAndClose,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Show ${widget.totalRecipesCount} recipes",
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

  Widget _topSearchBar() {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: TextField(
        controller: searchCtrl,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "Search filters...",
          prefixIcon: Icon(Icons.search, color: textSoft),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textStrong),
      ),
    );
  }

  Widget _cardSection({required String title, required Widget child, VoidCallback? onViewAll}) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: textStrong),
                  ),
                ),
              ),
              InkWell(
                onTap: onViewAll,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      Text("View all", style: TextStyle(fontWeight: FontWeight.w800, color: textSoft)),
                      SizedBox(width: 6),
                      Icon(Icons.chevron_right, color: textSoft),
                    ],
                  ),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: selected ? selectedFill : card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? primaryDark : border, width: 1.2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: selected ? primaryDark : textSoft),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w900, color: selected ? primaryDark : textStrong),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedFill : card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? primaryDark : border, width: 1.2),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, color: selected ? primaryDark : textStrong),
        ),
      ),
    );
  }

  Widget _circleGrid({
    required List<_CircleItem> items,
    required Set<String> selectedKeys,
    required void Function(String keyName) onToggle,
  }) {
    final filtered = items.where((e) => _matchSearch(e.label)).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        mainAxisExtent: 108,
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
                      color: selected ? selectedFill : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(color: selected ? primaryDark : Colors.transparent, width: 1.2),
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
                        decoration: BoxDecoration(color: primaryDark, shape: BoxShape.circle),
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                it.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: textStrong, height: 1.1),
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
    final filtered = items.where((e) => _matchSearch(e.label)).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 10,
        mainAxisExtent: 100,
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
                      color: selected ? selectedFill : Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.all(color: selected ? primaryDark : Colors.transparent, width: 1.2),
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
                        decoration: BoxDecoration(color: primaryDark, shape: BoxShape.circle),
                        child: Icon(Icons.check, size: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                it.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w900, color: textStrong),
              ),
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
    final filtered = items.where((e) => _matchSearch(e.label)).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 10,
        mainAxisExtent: 120,
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
                  color: selected ? selectedFill : card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: selected ? primaryDark : border, width: 1.2),
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
                        border: Border.all(color: selected ? primaryDark : Colors.transparent, width: 1.2),
                      ),
                      child: Icon(it.icon, size: 24, color: selected ? primaryDark : textSoft),
                    ),
                    SizedBox(height: 10),
                    Text(
                      it.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textStrong, height: 1.1),
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
                    decoration: BoxDecoration(color: primaryDark, shape: BoxShape.circle),
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
  final String label;
  final IconData icon;
  _ChipItem({required this.keyName, required this.label, required this.icon});
}

class _CircleItem {
  final String keyName;
  final String label;
  final String emoji;
  _CircleItem({required this.keyName, required this.label, required this.emoji});
}

class _FlagItem {
  final String keyName;
  final String label;
  final String emoji;
  _FlagItem({required this.keyName, required this.label, required this.emoji});
}

class _IconTile {
  final String keyName;
  final String label;
  final IconData icon;
  _IconTile({required this.keyName, required this.label, required this.icon});
}

class _ViewAllItem {
  final String keyName;
  final String label;
  final Widget widget;
  _ViewAllItem({required this.keyName, required this.label, required this.widget});
}
