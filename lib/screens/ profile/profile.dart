import 'package:div/screens/%20profile/EditProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:div/core/uite/db_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'EditProfilePage.dart';

class items_mode extends StatefulWidget {
  const items_mode({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<items_mode> createState() => _items_modeState();
}

class _items_modeState extends State<items_mode> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await NotesDatabase().getProfile();
    if (!mounted) return;
    setState(() {
      userData = data;
      isLoading = false;
    });
  }

  Future<void> _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  EditProfilePage(),
      ),
    );

    if (result == true) {
      _loadProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageBody = isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
      padding:  EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 12),
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.green.withOpacity(0.2),
            child:  Icon(Icons.person, size: 50, color: Colors.green),
          ),
          SizedBox(height: 12),
          Text(
            userData?['name'] ?? "User",
            style:  TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            userData?['email'] ?? "",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 20),

          Card(
            child: ListTile(
              leading:  Icon(Icons.phone),
              title: Text("Phone number".tr()),
              subtitle: Text(userData?['phone'] ?? "-"),
            ),
          ),
          Card(
            child: ListTile(
              leading:  Icon(Icons.cake),
              title: Text("Age".tr()),
              subtitle: Text(userData?['age'] ?? "-"),
            ),
          ),
          Card(
            child: ListTile(
              leading:  Icon(Icons.monitor_weight),
              title: Text("Weight (kg)".tr()),
              subtitle: Text(userData?['weight'] ?? "-"),
            ),
          ),
          Card(
            child: ListTile(
              leading:  Icon(Icons.height),
              title: Text("Height (cm)".tr()),
              subtitle: Text(userData?['height'] ?? "-"),
            ),
          ),
        ],
      ),
    );

    if (widget.embedded) {
      return Container(
        color: Colors.grey.shade100,
        child: pageBody,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Profile".tr()),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              final lang = context.locale.languageCode;
              if (lang == "en") {
                context.setLocale(const Locale("ar"));
              } else {
                context.setLocale(const Locale("en"));
              }
            },
            icon: const Icon(Icons.language),
          ),
          IconButton(
            onPressed: _goToEditProfile,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: pageBody,
    );
  }
}

