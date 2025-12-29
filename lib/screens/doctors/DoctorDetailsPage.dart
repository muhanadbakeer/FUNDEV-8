import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:div/model/doctor.dart';
import 'package:div/model/doctor_extra.dart';
import '../../feature/map/googl_map.dart';
import 'DoctorChatPage.dart';

class DoctorDetailsPage extends StatelessWidget {
  final Doctor doctor;
  final DoctorExtra extra;

  DoctorDetailsPage({
    super.key,
    required this.doctor,
    required this.extra,
  });

  String _normalizeForCall(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }

  String _normalizeForWhatsApp(String phone) {
    String p = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (p.startsWith('0')) p = '962${p.substring(1)}';

    if (p.startsWith('+')) p = p.substring(1);

    return p;
  }

  Future<void> _openCall(BuildContext context, String phone) async {
    final p = _normalizeForCall(phone);
    final uri = Uri(scheme: "tel", path: p);

    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Cannot open phone app".tr())),
      );
    }
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final p = _normalizeForWhatsApp(phone);

    final uriApp = Uri.parse("whatsapp://send?phone=$p");
    final okApp = await launchUrl(uriApp, mode: LaunchMode.externalApplication);
    if (okApp) return;

    final uriWeb = Uri.parse("https://wa.me/$p");
    final okWeb = await launchUrl(uriWeb, mode: LaunchMode.externalApplication);

    if (!okWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("WhatsApp not available".tr())),
      );
    }
  }

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
                context.setLocale( Locale("ar"));
              } else {
                context.setLocale( Locale("en"));
              }
            },
            icon:  Icon(Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green.withOpacity(0.2),
              child:  Icon(Icons.person, size: 50, color: Colors.green),
            ),
            SizedBox(height: 12),

            Text(
              doctor.name,
              style:  TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 4),

            Text(
              doctor.specialty,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            SizedBox(height: 8),

            Text(
              "${"Experience".tr()}: ${doctor.experience}",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),

            SizedBox(height: 16),

            Card(
              child: Padding(
                padding:  EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About doctor".tr(),
                      style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      doctor.about,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 12),

            Card(
              child: Padding(
                padding:  EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Clinic info".tr(),
                      style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:  Icon(Icons.local_hospital, color: Colors.green),
                      title: Text(extra.clinicName),
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:  Icon(Icons.location_on, color: Colors.green),
                      title: Text(extra.address),
                    ),

                    Divider(height: 24),

                    Text(
                      "Contact".tr(),
                      style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:  Icon(Icons.call, color: Colors.green),
                      title: Text("Call".tr()),
                      subtitle: Text(extra.phone),
                      trailing:  Icon(Icons.chevron_right),
                      onTap: () => _openCall(context, extra.phone),
                    ),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading:  Icon(Icons.ac_unit, color: Colors.green),
                      title: Text("WhatsApp".tr()),
                      subtitle: Text(extra.phone),
                      trailing:  Icon(Icons.chevron_right),
                      onTap: () => _openWhatsApp(context, extra.phone),
                    ),

                    if (extra.lat != null && extra.lng != null)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading:  Icon(Icons.map, color: Colors.green),
                        title: Text("Open location".tr()),
                        trailing:  Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MapSample(
                                lat: extra.lat!,
                                lng: extra.lng!,
                              ),
                            ),
                          );
                        },
                      ),

                    SizedBox(height: 8),
                    Divider(height: 24),

                    Text(
                      "Details".tr(),
                      style:  TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      extra.details,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorChatPage(doctorName: doctor.name),
                    ),
                  );
                },
                icon:  Icon(Icons.chat),
                label: Text("Chat with doctor".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:  EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

