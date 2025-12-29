import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool pushEnabled = true;
  bool mealReminders = true;
  bool workoutReminders = false;
  bool waterReminders = true;
  bool weeklyReport = true;
  bool sound = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text("notifications.title".tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _sectionTitle("notifications.general".tr()),
          _cardSwitch(
            title: "notifications.push".tr(),
            subtitle: "notifications.pushDesc".tr(),
            value: pushEnabled,
            onChanged: (v) => setState(() => pushEnabled = v),
          ),
          const SizedBox(height: 10),

          _sectionTitle("notifications.reminders".tr()),
          _cardSwitch(
            title: "notifications.mealReminders".tr(),
            subtitle: "notifications.mealRemindersDesc".tr(),
            value: mealReminders,
            onChanged: pushEnabled ? (v) => setState(() => mealReminders = v) : null,
          ),
          _cardSwitch(
            title: "notifications.workoutReminders".tr(),
            subtitle: "notifications.workoutRemindersDesc".tr(),
            value: workoutReminders,
            onChanged: pushEnabled ? (v) => setState(() => workoutReminders = v) : null,
          ),
          _cardSwitch(
            title: "notifications.waterReminders".tr(),
            subtitle: "notifications.waterRemindersDesc".tr(),
            value: waterReminders,
            onChanged: pushEnabled ? (v) => setState(() => waterReminders = v) : null,
          ),
          const SizedBox(height: 10),

          _sectionTitle("notifications.reports".tr()),
          _cardSwitch(
            title: "notifications.weeklyReport".tr(),
            subtitle: "notifications.weeklyReportDesc".tr(),
            value: weeklyReport,
            onChanged: pushEnabled ? (v) => setState(() => weeklyReport = v) : null,
          ),
          const SizedBox(height: 10),

          _sectionTitle("notifications.behavior".tr()),
          _cardSwitch(
            title: "notifications.sound".tr(),
            subtitle: "notifications.soundDesc".tr(),
            value: sound,
            onChanged: pushEnabled ? (v) => setState(() => sound = v) : null,
          ),
          _cardSwitch(
            title: "notifications.vibration".tr(),
            subtitle: "notifications.vibrationDesc".tr(),
            value: vibration,
            onChanged: pushEnabled ? (v) => setState(() => vibration = v) : null,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w900,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget _cardSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
