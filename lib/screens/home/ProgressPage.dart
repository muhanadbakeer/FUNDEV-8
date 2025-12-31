import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/progress_api.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  final String userId = "1"; // مؤقت

  bool loading = true;
  ProgressSummaryDto? summary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final s = await ProgressApi.getSummary(userId);
      if (!mounted) return;
      setState(() {
        summary = s;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      _showMsg("Failed to load".tr());
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _weightText() {
    final s = summary;
    if (s == null) return "--";
    final change = s.weightChangeKg; // current - start
    final sign = change > 0 ? "+" : "";
    return "${sign}${change.toStringAsFixed(1)} kg in ${s.periodDays} days";
  }

  String _avgCaloriesText() {
    final s = summary;
    if (s == null) return "--";
    return "${s.averageCaloriesPerDay} kcal / day";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Progress".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale(const Locale("ar"));
              } else {
                context.setLocale(const Locale("en"));
              }
            },
            icon: const Icon(Icons.language),
            tooltip: "Change language",
          ),
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Overview".tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.monitor_weight),
                title: Text("Weight change".tr()),
                subtitle: Text(_weightText()),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_fire_department),
                title: Text("Average calories".tr()),
                subtitle: Text(_avgCaloriesText()),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Notes".tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  "Charts and detailed progress can be shown here".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
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
