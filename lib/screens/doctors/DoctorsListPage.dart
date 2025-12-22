import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/model/doctor.dart';
import 'package:div/model/doctor_extra.dart';
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

  final List<DoctorExtra> extras = [
    DoctorExtra(
      phone: "0790000000",
      address: "Amman - Khalda",
      clinicName: "DIV Clinic",
      details: "Certified nutritionist, weight loss plans, diabetic diet programs.",
      lat: 31.9539,
      lng: 35.9106,
    ),
    DoctorExtra(
      phone: "0781111111",
      address: "Amman - Tlaa Al Ali",
      clinicName: "Performance Nutrition Center",
      details: "Sports nutrition, muscle gain, fat loss plans for athletes.",
      lat: 31.9865,
      lng: 35.8541,
    ),
    DoctorExtra(
      phone: "0772222222",
      address: "Amman - Sweifieh",
      clinicName: "Kids Nutrition Care",
      details: "Child nutrition, picky eaters programs, healthy habits coaching.",
      lat: 31.9497,
      lng: 35.8801,
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
                context.setLocale( Locale("ar"));
              } else {
                context.setLocale( Locale("en"));
              }
            },
            icon:  Icon(Icons.language),
          ),
        ],
      ),
      body: ListView.builder(
        padding:  EdgeInsets.all(16),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];

          final DoctorExtra extra = (index < extras.length)
              ? extras[index]
              : DoctorExtra(
            phone: "",
            address: "",
            clinicName: "",
            details: "",
            lat: null,
            lng: null,
          );

          return Card(
            margin:  EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.green.withOpacity(0.1),
                backgroundImage: (doctor.image.isNotEmpty)
                    ? AssetImage(doctor.image)
                    : null,
                child: (doctor.image.isEmpty)
                    ?  Icon(Icons.person, color: Colors.green)
                    : null,
              ),
              title: Text(
                doctor.name,
                style:  TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "${doctor.specialty}\n${"Experience".tr()}: ${doctor.experience}",
              ),
              isThreeLine: true,

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailsPage(
                      doctor: doctor,
                      extra: extra,
                    ),
                  ),
                );
              },

              trailing: IconButton(
                icon:  Icon(Icons.chat, color: Colors.green),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorChatPage(
                        doctorName: doctor.name,
                      ),
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
