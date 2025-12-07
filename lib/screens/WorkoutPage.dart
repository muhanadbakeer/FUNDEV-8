import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WorkoutPage extends StatelessWidget {
   WorkoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Today's workout".tr(),
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
           SizedBox(height: 12),
           Card(
            child: ListTile(
              leading: Icon(Icons.directions_run),
              title: Text("Walking"),
              subtitle: Text("30 minutes - moderate"),
            ),
          ),
           Card(
            child: ListTile(
              leading: Icon(Icons.fitness_center),
              title: Text("Strength training"),
              subtitle: Text("20 minutes - full body"),
            ),
          ),
           SizedBox(height: 16),
          Text(
            "Notes".tr(),
            style:  TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
           SizedBox(height: 8),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: "Add your workout notes".tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
