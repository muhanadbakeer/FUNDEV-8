import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../ profile/profile.dart';

class SettingsPage extends StatelessWidget {
   SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings".tr()),
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
        children: [
          ListTile(
            leading:  Icon(Icons.person),
            title: Text("Profile".tr()),
            subtitle: Text("Edit your information".tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  items_mode(),
                ),
              );
            },
          ),

          ListTile(
            leading:  Icon(Icons.notifications),
            title: Text("Notifications".tr()),
            subtitle: Text("Reminders & alerts".tr()),
            onTap: () {},
          ),
          ListTile(
            leading:  Icon(Icons.language),
            title: Text("Language".tr()),
            subtitle: Text("Change app language".tr()),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }
}
