import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class items_mode extends StatefulWidget {
   items_mode({super.key});

  @override
  State<items_mode> createState() => _items_modeState();
}

class _items_modeState extends State<items_mode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Profile".tr(),
          style:  TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 2,
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
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
             SizedBox(height: 12),
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.green.withOpacity(0.2),
              child:  Icon(
                Icons.person,
                size: 50,
                color: Colors.green,
              ),
            ),
             SizedBox(height: 12),
            Text(
              "Mohamad User".tr(),
              style:  TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
             SizedBox(height: 4),
            Text(
              "user@email.com".tr(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
             SizedBox(height: 20),
            // كروت الإحصائيات
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Current weight".tr(),
                            style:  TextStyle(fontSize: 12),
                          ),
                           SizedBox(height: 4),
                           Text(
                            "78 kg",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: 8),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Goal".tr(),
                            style:  TextStyle(fontSize: 12),
                          ),
                           SizedBox(height: 4),
                           Text(
                            "70 kg",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: 8),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Days in plan".tr(),
                            style:  TextStyle(fontSize: 12),
                          ),
                           SizedBox(height: 4),
                           Text(
                            "14",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
             SizedBox(height: 20),
            // قائمة الخيارات
            Card(

              child: Column(
                children: [
                  ListTile(
                    leading:  Icon(Icons.edit),
                    title: Text("Edit profile".tr()),
                    subtitle: Text("Name, email, phone".tr()),
                    onTap: () {},
                  ),

                  ListTile(
                    leading:  Icon(Icons.restaurant_menu),
                    title: Text("Meal plan".tr()),
                    subtitle: Text("View your nutrition plan".tr()),
                    onTap: () {},
                  ),
                  ListTile(
                    leading:  Icon(Icons.monitor_weight),
                    title: Text("Weight history".tr()),
                    subtitle: Text("View previous measurements".tr()),
                    onTap: () {},
                  ),

                  ListTile(
                    leading:  Icon(Icons.notifications_none),
                    title: Text("Notifications".tr()),
                    subtitle: Text("Reminders & alerts".tr()),
                    onTap: () {},
                  ),

                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      "Logout".tr(),
                      style:  TextStyle(color: Colors.red),
                    ),
                    onTap: () {},
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
