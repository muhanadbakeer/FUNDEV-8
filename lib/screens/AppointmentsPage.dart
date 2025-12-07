import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppointmentsPage extends StatelessWidget {
   AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments".tr()),
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
        ],

      ),
      body: ListView(
        padding:  EdgeInsets.all(16),
        children: [
          Text(
            "Upcoming sessions".tr(),
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
           SizedBox(height: 12),
           Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Thursday • 4:00 PM"),
              subtitle: Text("Follow-up with nutritionist"),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
           Card(
            child: ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text("Next week"),
              subtitle: Text("Body composition check"),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
           SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: حجز موعد جديد
            },
            icon:  Icon(Icons.add),
            label: Text("Book new appointment".tr()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
