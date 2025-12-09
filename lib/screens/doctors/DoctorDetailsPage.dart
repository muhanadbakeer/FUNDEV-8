import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/model/doctor.dart';
import 'DoctorChatPage.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;

  DoctorDetailsPage({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Doctor details".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale(Locale("ar"));
              } else {
                context.setLocale(Locale("en"));
              }
            },
            icon: Icon(Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12),
            Text(
              doctor.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 4),
            Text(
              doctor.specialty,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${"Experience".tr()}: ${doctor.experience}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About doctor".tr(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      doctor.about,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorChatPage(doctorName: doctor.name),
                    ),
                  );
                },
                icon: Icon(Icons.chat),
                label: Text("Chat with doctor".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
