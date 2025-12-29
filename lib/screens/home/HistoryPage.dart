import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';

// عندك بالمشروع
import 'CaloriesPage.dart';

class HistoryPage extends StatefulWidget {
  HistoryPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Color green = Colors.green;

  DateTime selectedDate = DateTime.now();

  int proteinTarget = 158;
  int fatTarget = 154;
  int carbsTarget = 126;

  int remainingCalories = 2525;

  final ImagePicker picker = ImagePicker();

  /// صور مختارة (من الكاميرا/المعرض) - مؤقتًا للعرض
  final List<File> images = [];

  // ===== Fallback ترجمة: لو الترجمة مش شغالة أو key مش موجود ما يطلع key =====
  String t(String key, String fallback, {List<String>? args}) {
    String v = key.tr(args: args);
    if (v == key) return fallback;
    return v;
  }

  @override
  Widget build(BuildContext context) {
    Widget pageBody = SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Header row (calendar active + title) =====
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.calendar_month_outlined,
                    size: 26,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    _openDatePicker(context);
                  },
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t("history.title", "History"),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            _WeekStrip(
              selected: selectedDate,
              onSelect: (d) => setState(() => selectedDate = d),
            ),

            SizedBox(height: 14),

            // ===== Cards: Macros + Calories =====
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _MacroCard(
                        title: t("history.protein", "Protein"),
                        icon: Icons.egg_alt_outlined,
                        valueText: "0 / $proteinTarget g",
                        progress: 0.0,
                      ),
                      SizedBox(height: 12),
                      _MacroCard(
                        title: t("history.fat", "Fat"),
                        icon: Icons.water_drop_outlined,
                        valueText: "0 / $fatTarget g",
                        progress: 0.0,
                      ),
                      SizedBox(height: 12),
                      _MacroCard(
                        title: t("history.carbs", "Carbs"),
                        icon: Icons.grain_outlined,
                        valueText: "0 / $carbsTarget g",
                        progress: 0.0,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                SizedBox(
                  width: 150,
                  child: _CaloriesCard(
                    remaining: remainingCalories,
                    progress: 0.0,
                    title: t("history.remainingCalories", "Remaining\nCalories"),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // ===== FIX overflow: Wrap بدل Row =====
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              runSpacing: 6,
              children: [
                Text(
                  t("history.consumedKcal", "0 kcal", args: ["0"]),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                Text(
                  t("history.consumedFood", "Consumed Food"),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ],
            ),

            SizedBox(height: 6),

            Padding(
              padding: EdgeInsets.only(top: 26, bottom: 18),
              child: Column(
                children: [
                  Text(
                    t("history.emptyTitle", "You haven't logged anything yet!"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 8),
                  Text(
                    t(
                      "history.emptyDesc",
                      "Start tracking today's meals using photos, text,\nor manual macro entry",
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.4),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8),

            Container(
              height: 170,
              alignment: Alignment.center,
              child: Text("🥑", style: TextStyle(fontSize: 110)),
            ),

            SizedBox(height: 80),
          ],
        ),
      ),
    );

    if (widget.embedded) {
      return Container(color: Colors.grey.shade100, child: pageBody);
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: green,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          t("app.name", "DIV Nutrition"),
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: t("common.notifications", "Notifications"),
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          ),
          IconButton(
            tooltip: t("common.profile", "Profile"),
            onPressed: () {},
            icon: Icon(Icons.person_outline),
          ),
        ],
      ),

      drawer: _MainDrawer(
        title: t("app.name", "DIV Nutrition"),
        subtitle: t("common.quickNav", "Quick navigation"),
        onOpenSettings: () => onOpenSettings(),
        onOpenPurchases: () => onOpenPurchases(),
        onOpenHistory: () {},
        onOpenMealPlan: () => onOpenMealPlan(),
        onOpenRecipes: () => onOpenRecipes(),
        t: t,
      ),

      // ===== FAB + (opens meals sheet) =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade900, // بدون Hex
        onPressed: () {
          _showPickMealTypeSheet(context);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),

      body: pageBody,
    );
  }

  // =========================
  // Calendar icon action
  // =========================
  Future<void> _openDatePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: t("history.selectDate", "Select date"),
      confirmText: t("common.ok", "OK"),
      cancelText: t("common.cancel", "Cancel"),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // =========================
  // BottomSheet #1 (Meal type)
  // =========================
  void _showPickMealTypeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 0, 12, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14, 10, 14, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: () => Navigator.pop(ctx),
                            icon: Icon(Icons.close),
                            tooltip: t("common.close", "Close"),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: _mealChoiceButton(
                              text: t("meals.breakfast", "Breakfast"),
                              icon: Icons.wb_sunny_outlined,
                              onTap: () {
                                Navigator.pop(ctx);
                                _showAddMealMethodSheet(context, "breakfast");
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _mealChoiceButton(
                              text: t("meals.lunch", "Lunch"),
                              icon: Icons.wb_sunny,
                              onTap: () {
                                Navigator.pop(ctx);
                                _showAddMealMethodSheet(context, "lunch");
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _mealChoiceButton(
                              text: t("meals.snack", "Snack"),
                              icon: Icons.apple_outlined,
                              onTap: () {
                                Navigator.pop(ctx);
                                _showAddMealMethodSheet(context, "snack");
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _mealChoiceButton(
                              text: t("meals.dinner", "Dinner"),
                              icon: Icons.nightlight_outlined,
                              onTap: () {
                                Navigator.pop(ctx);
                                _showAddMealMethodSheet(context, "dinner");
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mealChoiceButton({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              Icon(icon, color: Colors.black87),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // BottomSheet #2 (Log meal like your screenshot)
  // (هنا حذفنا أي شيء زايد، وخليّناها نظيفة مثل صورتك)
  // =========================
  void _showAddMealMethodSheet(BuildContext context, String mealType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 16),

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close),
                    ),
                    Expanded(
                      child: Text(
                        t("addMeal.title", "Log Meal"),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),

                SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: _methodCard(
                        color: Colors.indigo.shade50,
                        icon: Icons.text_fields,
                        text: t("addMeal.text", "Text"),
                        onTap: () {
                          Navigator.pop(ctx);
                          _openTextInput(mealType);
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _methodCard(
                        color: Colors.amber.shade50,
                        icon: Icons.camera_alt_outlined,
                        text: t("addMeal.camera", "Camera"),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await _pickFromCamera();
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _methodCard(
                        color: Colors.green.shade50,
                        icon: Icons.image_outlined,
                        text: t("addMeal.gallery", "Gallery"),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await _pickFromGallery();
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18),

                Divider(),

                ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text(
                    t("addMeal.manual", "Manual macro entry"),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(ctx);
                    _openManualEntry(mealType);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _methodCard({
    required Color color,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 110,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.black87),
              SizedBox(height: 10),
              Text(text, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Camera / Gallery using image_picker (من كودك)
  // =========================
  Future<void> _pickFromCamera() async {
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        setState(() {
          images.add(File(picked.path));
        });
        _openPickedImagesPreview();
      }
    } catch (e) {
      debugPrint("Camera pick error: $e");
      _showMsg(t("common.error", "Error"));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> pickedImages = await picker.pickMultiImage(imageQuality: 85);
      if (pickedImages.isNotEmpty) {
        setState(() {
          images.addAll(pickedImages.map((e) => File(e.path)));
        });
        _openPickedImagesPreview();
      }
    } catch (e) {
      debugPrint("Gallery pick error: $e");
      _showMsg(t("common.error", "Error"));
    }
  }

  void _openPickedImagesPreview() {
    if (images.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealImagesPreviewPage(
          title: t("addMeal.title", "Log Meal"),
          images: images,
          onRemove: (index) {
            setState(() {
              images.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // =========================
  // Hooks (ربط الصفحات)
  // =========================
  void _openTextInput(String mealType) {
    // اربطها بصفحتك
    // Navigator.push(context, MaterialPageRoute(builder: (_) => TextMealPage(mealType: mealType)));
    _showMsg("Text pressed ($mealType)");
  }

  void _openManualEntry(String mealType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CaloriesPage()),
    );
  }

  // ===== Drawer hooks (اختياري) =====
  void onOpenSettings() {}
  void onOpenPurchases() {}
  void onOpenMealPlan() {}
  void onOpenRecipes() {}
}

// ===================== Preview Page =====================

class MealImagesPreviewPage extends StatelessWidget {
  MealImagesPreviewPage({
    super.key,
    required this.title,
    required this.images,
    required this.onRemove,
  });

  final String title;
  final List<File> images;
  final void Function(int index) onRemove;

  void _previewImage(BuildContext context, File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.all(12),
        child: InteractiveViewer(
          child: Image.file(file, fit: BoxFit.contain),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: images.isEmpty
            ? Center(child: Text("No Images Selected"))
            : GridView.builder(
          itemCount: images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final file = images[index];
            return Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => _previewImage(context, file),
                      child: Image.file(file, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: InkWell(
                    onTap: () => onRemove(index),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ================= Drawer =================

class _MainDrawer extends StatelessWidget {
  _MainDrawer({
    required this.title,
    required this.subtitle,
    required this.onOpenSettings,
    required this.onOpenPurchases,
    required this.onOpenHistory,
    required this.onOpenMealPlan,
    required this.onOpenRecipes,
    required this.t,
  });

  final String title;
  final String subtitle;

  final VoidCallback onOpenSettings;
  final VoidCallback onOpenPurchases;
  final VoidCallback onOpenHistory;
  final VoidCallback onOpenMealPlan;
  final VoidCallback onOpenRecipes;

  final String Function(String key, String fallback, {List<String>? args}) t;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.restaurant, color: Colors.green, size: 28),
                  ),
                  SizedBox(height: 10),
                  Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _drawerItem(Icons.settings, t("drawer.settings", "Settings"), () {
                    Navigator.pop(context);
                    onOpenSettings();
                  }),
                  _drawerItem(Icons.shopping_cart_outlined, t("drawer.purchases", "Purchases"), () {
                    Navigator.pop(context);
                    onOpenPurchases();
                  }),
                  _drawerItem(Icons.list_alt, t("drawer.history", "History"), () {
                    Navigator.pop(context);
                    onOpenHistory();
                  }),
                  _drawerItem(Icons.grid_view_rounded, t("drawer.mealPlan", "Meal Plan"), () {
                    Navigator.pop(context);
                    onOpenMealPlan();
                  }),
                  _drawerItem(Icons.restaurant, t("drawer.recipes", "Recipes"), () {
                    Navigator.pop(context);
                    onOpenRecipes();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }
}

// ================= Week strip =================

class _WeekStrip extends StatelessWidget {
  _WeekStrip({required this.selected, required this.onSelect});

  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = [];
    DateTime today = DateTime.now();

    for (int i = 4; i >= 0; i--) {
      days.add(DateTime(today.year, today.month, today.day - i));
    }
    days.add(DateTime(today.year, today.month, today.day + 1));
    days.add(DateTime(today.year, today.month, today.day + 2));

    List<String> labels = ["Wed", "Thu", "Fri", "Sat", "Sun", "Mon", "Tue"];

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Icon(Icons.calendar_today_outlined, color: Colors.black87, size: 20),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              DateTime d = days[i];
              bool isSelected =
                  d.year == selected.year && d.month == selected.month && d.day == selected.day;

              return GestureDetector(
                onTap: () => onSelect(d),
                child: Column(
                  children: [
                    Text(labels[i], style: TextStyle(color: Colors.black45, fontSize: 12)),
                    SizedBox(height: 8),
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueGrey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Text(
                        "${d.day}",
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// ================= Cards =================

class _MacroCard extends StatelessWidget {
  _MacroCard({
    required this.title,
    required this.icon,
    required this.valueText,
    required this.progress,
  });

  final String title;
  final IconData icon;
  final String valueText;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  valueText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(width: 8),
              Icon(icon, color: Colors.black54),
            ],
          ),
          SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: Colors.lightGreen.shade200,
            ),
          ),
        ],
      ),
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  _CaloriesCard({
    required this.remaining,
    required this.progress,
    required this.title,
  });

  final int remaining;
  final double progress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 224,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 92,
                height: 92,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  color: Colors.lightGreen.shade200,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              Icon(Icons.local_fire_department_outlined, size: 28, color: Colors.black87),
            ],
          ),
          SizedBox(height: 14),
          Text("$remaining", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
          SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.3),
          ),
        ],
      ),
    );
  }
}
