import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:div/core/uite/db_helper.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController    = TextEditingController();
  TextEditingController emailController   = TextEditingController();
  TextEditingController phoneController   = TextEditingController();
  TextEditingController ageController     = TextEditingController();
  TextEditingController weightController  = TextEditingController();
  TextEditingController heightController  = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileFromDB();
  }

  Future<void> _loadProfileFromDB() async {
    final data = await NotesDatabase().getProfile();

    if (data != null) {
      nameController.text   = data['name']   ?? "";
      emailController.text  = data['email']  ?? "";
      phoneController.text  = data['phone']  ?? "";
      ageController.text    = data['age']    ?? "";
      weightController.text = data['weight'] ?? "";
      heightController.text = data['height'] ?? "";
    } else {
      nameController.text   = "";
      emailController.text  = "";
      phoneController.text  = "";
      ageController.text    = "";
      weightController.text = "";
      heightController.text = "";
    }

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Edit profile".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              String lang = context.locale.languageCode;
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
      body: isLoading
          ?  Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding:  EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.green.withOpacity(0.2),
                child:  Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.green,
                ),
              ),
               SizedBox(height: 16),

              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full name".tr(),
                  prefixIcon:  Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your name".tr();
                  }
                  return null;
                },
              ),
               SizedBox(height: 12),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email".tr(),
                  prefixIcon:  Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter your email".tr();
                  }
                  if (!value.contains("@")) {
                    return "Invalid email".tr();
                  }
                  return null;
                },
              ),
               SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone number".tr(),
                  prefixIcon:  Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
               SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Age".tr(),
                        prefixIcon:  Icon(Icons.cake),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                   SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Weight (kg)".tr(),
                        prefixIcon:  Icon(Icons.monitor_weight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 12),

              TextFormField(
                controller: heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Height (cm)".tr(),
                  prefixIcon:  Icon(Icons.height),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

               SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding:  EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Save changes".tr(),
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profile = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'age': ageController.text,
        'weight': weightController.text,
        'height': heightController.text,
      };

      await NotesDatabase().upsertProfile(profile);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile updated successfully".tr()),
        ),
      );

      Navigator.pop(context, true);
    }
  }
}
