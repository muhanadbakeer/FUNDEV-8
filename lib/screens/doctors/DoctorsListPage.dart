import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/model/doctor.dart';
import 'DoctorChatPage.dart';
import 'DoctorDetailsPage.dart';

class DoctorsListPage extends StatelessWidget {
  DoctorsListPage({super.key});

  final List<Doctor> doctors = [
    Doctor(
      name: "Dr. sandy Ahmad",
      specialty: "Clinical Dietitian",
      image: "",
      experience: "5 years",
      about: "Specialized in weight loss programs and diabetic nutrition.",
    ),
    Doctor(
      name: "Dr. muhamad Ali",
      specialty: "Sports Nutritionist",
      image: "",
      experience: "7 years",
      about: "Helps athletes and gym clients with performance nutrition.",
    ),
    Doctor(
      name: "Dr. Lina Khaled",
      specialty: "Child Nutrition",
      image: "",
      experience: "4 years",
      about: "Focus on kids growth, picky eaters and healthy habits.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Select nutritionist".tr()),
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
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
              ),
              title: Text(
                doctor.name,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "${doctor.specialty}\n${"Experience".tr()}: ${doctor.experience}",
              ),
              isThreeLine: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailsPage(doctor: doctor),
                  ),
                );
              },
              trailing: IconButton(
                icon: Icon(Icons.chat, color: Colors.green),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DoctorChatPage(doctorName: doctor.name),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
