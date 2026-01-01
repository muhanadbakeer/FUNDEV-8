import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/screens/home/api_home/appointments_api.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final String userId = "1";

  List<Map<String, dynamic>> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final data = await AppointmentsApi.getAll(userId);
      if (!mounted) return;
      setState(() {
        appointments = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _showAddAppointmentDialog(BuildContext context) {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Book new appointment".tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title".tr(),
                  ),
                ),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "Date (YYYY-MM-DD)".tr(),
                  ),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: "Time (HH:MM)".tr(),
                  ),
                ),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: "Note (optional)".tr(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel".tr()),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isEmpty ||
                    dateController.text.isEmpty ||
                    timeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please fill required fields".tr()),
                    ),
                  );
                  return;
                }

                await AppointmentsApi.create(
                  userId: userId,
                  title: titleController.text,
                  date: dateController.text,
                  time: timeController.text,
                  note: noteController.text,
                );

                if (!mounted) return;
                Navigator.pop(context);
                _loadAppointments();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Appointment added successfully".tr()),
                  ),
                );
              },
              child: Text("Save".tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAppointment(int id) async {
    await AppointmentsApi.delete(id);
    _loadAppointments();
  }

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
      body: Padding(
        padding:  EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Upcoming sessions".tr(),
                style:  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
             SizedBox(height: 12),

            Expanded(
              child: isLoading
                  ?  Center(child: CircularProgressIndicator())
                  : appointments.isEmpty
                  ? Center(
                child: Text(
                  "No appointments yet".tr(),
                  style:  TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final item = appointments[index];
                  return Card(
                    child: ListTile(
                      leading:  Icon(Icons.calendar_today),
                      title: Text("${item['date']} • ${item['time']}"),
                      subtitle: Text(
                        (item['title'] ?? "").toString() +
                            ((item['note'] != null &&
                                item['note'].toString().isNotEmpty)
                                ? "\n${item['note']}"
                                : ""),
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon:  Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteAppointment(item['id'] as int),
                      ),
                    ),
                  );
                },
              ),
            ),

             SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddAppointmentDialog(context),
                icon:  Icon(Icons.add),
                label: Text("Book new appointment".tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
