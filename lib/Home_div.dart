import 'package:div/Gredview.dart';
import 'package:div/Items_mode.dart';
import 'package:div/List_viow.dart';
import 'package:div/first.dart';
import 'package:flutter/material.dart';

class HomeDiv extends StatefulWidget {
  const HomeDiv({super.key});

  @override
  State<HomeDiv> createState() => _HomeDivState();
}

class _HomeDivState extends State<HomeDiv> {
  int selectedindex = 0;
  List<Widget> screens = [
    ListViow(),
    items_mode(),
    Gredview(),
    Text("LOGOUT"),
  ];

  @override
 Widget build(BuildContext context) {
    return Scaffold(
   //   appBar: AppBar(
      //  title: Text("WELCOM"),
       // centerTitle: true,
       // backgroundColor: Colors.blue,
     // ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text("data"),
            ),
            ListTile(
              title: Text(
                "home",
                style: TextStyle(
                  color: Colors.black12,
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "profile",
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontSize: 25,
                ),
              ),
              onTap: () {},
            ),
            ExpansionTile(
              title: Text("SETTING"),
              children: [
                ListTile(
                  title: Text(
                    "name",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                    ),
                  ),
                  onTap: () {},
                  leading: Icon(Icons.home),
                ),
                ListTile(
                  title: Text(
                    "profiles",
                    style: TextStyle(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 25,
                    ),
                  ),
                  onTap: () {},
                  leading: Icon(Icons.person),
                ),
              ],
            ),
            ListTile(
              title: Text("logaut"),

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
      body: Center(child: screens[selectedindex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedindex,
        onTap: (index) {
          print("index = $index");
          setState(() {
            selectedindex = index;
          });
        },
        // backgroundColor: Colors.brown,
        // selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "home",
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "profile",
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "setting",
            backgroundColor: Colors.brown,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.abc),
            label: "LOGOUT",
            backgroundColor: Colors.greenAccent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(
          Icons.chat,
        ),
      ),

    );
  }
}
