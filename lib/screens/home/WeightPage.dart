import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class WeightPage extends StatelessWidget {
   WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],

      ),
      body: Padding(
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
              "78 kg",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
             SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
              },
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
              child: ListView(
                children:  [
                  ListTile(
                    leading: Icon(Icons.monitor_weight),
                    title: Text("78 kg"),
                    subtitle: Text("Today"),
                  ),
                  ListTile(
                    leading: Icon(Icons.monitor_weight),
                    title: Text("79 kg"),
                    subtitle: Text("2 days ago"),
                  ),
                  ListTile(
                    leading: Icon(Icons.monitor_weight),
                    title: Text("80 kg"),
                    subtitle: Text("1 week ago"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
