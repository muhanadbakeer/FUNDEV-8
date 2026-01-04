import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'DietPreferencePage.dart';
import 'MacrosGoalPage.dart';

class DietDetailsPage extends StatelessWidget {
  DietDetailsPage({
    super.key,
    required this.userId,
    required this.caloriesPerDay,
    required this.diet,
    required this.selectedKey,
    required this.onSelect,
  });

  final String userId;
  final int caloriesPerDay;
  final DietOption diet;
  final String selectedKey;
  final Future<void> Function(String key) onSelect;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedKey == diet.keyName;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${diet.title} Diet".tr(),
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

            SizedBox(height: 10),

            // Macro + donut
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _legendRow("Protein".tr(), "${diet.protein}%", Colors.green),
                        SizedBox(height: 10),
                        _legendRow("Fat".tr(), "${diet.fat}%", Colors.orange),
                        SizedBox(height: 10),
                        _legendRow("Carb".tr(), "${diet.carb}%", Colors.blueGrey),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(180, 180),
                          painter: DonutPainter(
                            values: [
                              diet.protein.toDouble(),
                              diet.fat.toDouble(),
                              diet.carb.toDouble(),
                            ],
                            colors: [
                              Colors.green.shade300,
                              Colors.orange.shade300,
                              Colors.blueGrey.shade200,
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              caloriesPerDay == 0 ? "-" : "$caloriesPerDay",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              "kcal/day".tr(),
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Adjust nutrition targets button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MacrosGoalPage()),
                  );
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Icon(Icons.chevron_left),
                      SizedBox(width: 8),
                      Text(
                        "Adjust nutrition targets".tr(),
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 18),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                diet.description.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: 12),

            TextButton(
              onPressed: () {},
              child: Text(
                "Source of recommendations".tr(),
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            Spacer(),

            // big bottom image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.network(
                  diet.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),

            // Bottom select bar
            Padding(
              padding: EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () async {
                          await onSelect(diet.keyName);
                          Navigator.pop(context);
                        },
                        child: Text(
                          isSelected ? "Selected".tr() : "Select".tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendRow(String title, String value, Color dotColor) {
    return Row(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        SizedBox(width: 10),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: dotColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class DonutPainter extends CustomPainter {
  DonutPainter({required this.values, required this.colors});

  final List<double> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;

    final stroke = 22.0;
    final rect = Rect.fromLTWH(stroke, stroke, size.width - stroke * 2, size.height - stroke * 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * 2 * pi;
      paint.color = colors[i];
      canvas.drawArc(rect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.colors != colors;
  }
}
