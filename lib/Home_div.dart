import 'package:div/Gredview.dart';
import 'package:div/profile.dart';
import 'package:div/home page.dart';
import 'package:div/screens/SettingsPage.dart';
import 'package:div/sigin_in.dart';
import 'package:div/screens/test.dart';
import 'package:flutter/material.dart';

class HomeDiv extends StatefulWidget {
  const HomeDiv({super.key});

  @override
  State<HomeDiv> createState() => _HomeDivState();
}

class _HomeDivState extends State<HomeDiv> {
  int selectedindex = 0;

  List<Widget> screens = [ListViow(), items_mode(), Gredview(), test()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== Drawer =====
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Center(
                child: Text(
                  "DIV Nutrition",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("Home", style: TextStyle(fontSize: 18)),
              onTap: () {
                setState(() {
                  selectedindex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Profile", style: TextStyle(fontSize: 18)),
              onTap: () {
                setState(() {
                  selectedindex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Settings", style: TextStyle(fontSize: 18)),
              onTap: () {
                setState(() {
                  selectedindex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => First()),
                );
              },
            ),
          ],
        ),
      ),

      // ===== Main Body =====
      body: Center(child: screens[selectedindex]),

      // ===== Floating Action Button =====
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.menu), // بدل أيقونة الشات إلى قائمة
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Container(
              padding: EdgeInsets.all(16),
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.green),
                    title: Text("Home"),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ListViow()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.green),
                    title: Text("Profile"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => items_mode()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.green),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text("Logout"),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const First()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
