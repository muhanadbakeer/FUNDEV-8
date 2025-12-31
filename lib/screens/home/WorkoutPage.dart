import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/workouts_api.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({super.key});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final String userId = "1"; // مؤقت
  bool loading = true;

  List<WorkoutItemDto> items = [];
  final TextEditingController notes = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    notes.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final day = await WorkoutsApi.getDay(userId: userId, date: DateTime.now());
      if (!mounted) return;
      setState(() {
        items = day.items;
        notes.text = day.notes ?? "";
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
      _msg("Failed to load".tr());
    }
  }

  Future<void> _save() async {
    try {
      await WorkoutsApi.saveDay(
        userId: userId,
        date: DateTime.now(),
        items: items,
        notes: notes.text.trim(),
      );
      _msg("Saved".tr());
    } catch (_) {
      _msg("Failed to save".tr());
    }
  }

  void _msg(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  IconData _iconFromKey(String key) {
    switch (key) {
      case "strength":
        return Icons.fitness_center;
      case "run":
        return Icons.directions_run;
      case "walk":
      default:
        return Icons.directions_walk;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Workout".tr()),
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
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "Today's workout".tr(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          ...items.map(
                (x) => Card(
              child: ListTile(
                leading: Icon(_iconFromKey(x.icon)),
                title: Text(x.title.tr()),
                subtitle: Text(x.subtitle.tr()),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            "Notes".tr(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: notes,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Add your workout notes".tr(),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _save,
              child: Text("common.save".tr(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          )
        ],
      ),
    );
  }
}
