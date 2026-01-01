import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/weights_api.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  final String userId = "1";

  bool loading = true;
  WeightSummaryDto? summary;
  List<WeightItemDto> history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final s = await WeightsApi.getSummary(userId);
      final list = await WeightsApi.getList(userId, take: 30);

      if (!mounted) return;
      setState(() {
        summary = s;
        history = list;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
      _msg("Failed to load".tr());
    }
  }
  void _msg(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  String _prettyDate(DateTime dt) {
    final now = DateTime.now();
    final d0 = DateTime(now.year, now.month, now.day);
    final d1 = DateTime(dt.year, dt.month, dt.day);
    final diff = d0.difference(d1).inDays;

    if (diff == 0) return "Today".tr();
    if (diff == 1) return "Yesterday".tr();
    if (diff < 7) return "${diff} days ago".tr();
    return "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<void> _openAddDialog() async {
    final c = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add new measurement".tr()),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: c,
            keyboardType:  TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: "Weight (kg)".tr(),
              hintText: "78".tr(),
            ),
            validator: (v) {
              final x = double.tryParse((v ?? "").trim());
              if (x == null || x <= 0) return "Invalid value".tr();
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel".tr()),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Save".tr(), style:  TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (ok != true) return;
    if (!formKey.currentState!.validate()) return;

    final value = double.parse(c.text.trim());

    try {
      await WeightsApi.addWeight(userId: userId, weightKg: value);
      _msg("Saved".tr());
      _load();
    } catch (_) {
      _msg("Failed to save".tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = summary?.currentWeightKg ?? 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Weight".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale( Locale("ar"));
              } else {
                context.setLocale( Locale("en"));
              }
            },
            icon:  Icon(Icons.language),
            tooltip: "Change language",
          ),
          IconButton(
            onPressed: _load,
            icon:  Icon(Icons.refresh),
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
              "Current weight".tr(),
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 8),
            Text(
              current > 0 ? "${current.toStringAsFixed(1)} kg" : "--",
              style:  TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
             SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _openAddDialog,
              icon:  Icon(Icons.add),
              label: Text("Add new measurement".tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
             SizedBox(height: 24),
            Text(
              "Weight history".tr(),
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 8),
            Expanded(
              child: history.isEmpty
                  ? Center(child: Text("No data".tr()))
                  : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return ListTile(
                    leading:  Icon(Icons.monitor_weight),
                    title: Text("${item.weightKg.toStringAsFixed(1)} kg"),
                    subtitle: Text(_prettyDate(item.createdAt)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
