import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:div/screens/home/api_home/calories_api.dart';

class CaloriesPage extends StatefulWidget {
  const CaloriesPage({super.key});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {
  final String userId = "1";

  bool loading = true;

  List<Map<String, dynamic>> weeklyCalories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      weeklyCalories = await CaloriesApi.getWeekly(userId);
    } catch (_) {
      weeklyCalories = [
        {"label": "This week", "kcal": 12340, "range": "Dec 1 - Dec 7"},
        {"label": "Last week", "kcal": 11800, "range": "Nov 24 - Nov 30"},
        {"label": "2 weeks ago", "kcal": 11050, "range": "Nov 17 - Nov 23"},
        {"label": "3 weeks ago", "kcal": 13200, "range": "Nov 10 - Nov 16"},
      ];
    }

    if (!mounted) return;
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final thisWeek = weeklyCalories.isNotEmpty ? (weeklyCalories[0]["kcal"] as int) : 0;
    final avg = weeklyCalories.isNotEmpty ? (thisWeek / 7).round() : 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Calories".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              String lang = context.locale.languageCode;
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
      body: loading
          ?  Center(child: CircularProgressIndicator())
          : Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "This week's calories".tr(),
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 8),
            Card(
              elevation: 3,
              child: Padding(
                padding:  EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child:  Icon(
                        Icons.local_fire_department,
                        color: Colors.green,
                        size: 32,
                      ),
                    ),
                     SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total calories".tr(),
                            style:  TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                           SizedBox(height: 4),
                          Text(
                            "$thisWeek kcal",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.green.shade700,
                            ),
                          ),
                           SizedBox(height: 4),
                          Text(
                            "Average: $avg kcal / day".tr(),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

             SizedBox(height: 20),

            Text(
              "Weekly calories chart".tr(),
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 8),

            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles:  AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles:  AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles:  AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= weeklyCalories.length) {
                            return  SizedBox();
                          }
                          final label = weeklyCalories[index]["label"].toString();

                          String shortLabel;
                          if (label == "This week") {
                            shortLabel = "Now";
                          } else if (label == "Last week") {
                            shortLabel = "Last";
                          } else {
                            shortLabel = label;
                          }

                          return Padding(
                            padding:  EdgeInsets.only(top: 4.0),
                            child: Text(
                              shortLabel.tr(),
                              style:  TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: _buildBarGroups(),
                ),
              ),
            ),

             SizedBox(height: 20),

            Text(
              "Previous weeks".tr(),
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: weeklyCalories.length,
                itemBuilder: (context, index) {
                  final item = weeklyCalories[index];
                  return Card(
                    child: ListTile(
                      leading:  Icon(Icons.calendar_today, color: Colors.green),
                      title: Text(item["label"].toString().tr()),
                      subtitle: Text("${item["range"]} • ${item["kcal"]} kcal"),
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

  List<BarChartGroupData> _buildBarGroups() {
    if (weeklyCalories.isEmpty) return [];

    final maxKcal = weeklyCalories
        .map((e) => e['kcal'] as int)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return weeklyCalories.asMap().entries.map((entry) {
      final index = entry.key;
      final kcal = (entry.value['kcal'] as int).toDouble();

      final double normalized = maxKcal == 0 ? 0 : (kcal / maxKcal) * 10;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: normalized,
            width: 18,
            borderRadius: BorderRadius.circular(6),
            color: Colors.green,
          ),
        ],
      );
    }).toList();
  }
}
