import 'package:flutter/material.dart';
import 'package:div/model/items.dart';

class items_mode extends StatefulWidget {
  const items_mode({super.key});

  @override
  State<items_mode> createState() => _items_modeState();
}

class _items_modeState extends State<items_mode> {
  List<ItemsModel> items = [
    ItemsModel(
      itemDESCRIPTION: "كيفك يا زلمة؟",
      itemIMAGE: "assets/image/png/images.jpg",
      itemName: "Mohamad",
      itemPRICE: "10:24 AM",
    ),
    ItemsModel(
      itemDESCRIPTION: "لا تنسى تسلّم المشروع",
      itemIMAGE: "assets/image/png/WhatsApp Image 2025-11-19 at 10.23.59 PM.jpeg",
      itemName: "Mohanad",
      itemPRICE: "09:11 AM",
    ),
    ItemsModel(
      itemDESCRIPTION: "العشا جاهز ",
      itemIMAGE: "assets/image/png/WhatsApp Image 2025-11-19 at 11.20.02 PM.jpeg",
      itemName: "Family Group",
      itemPRICE: "Yesterday",
    ),
    ItemsModel(
      itemDESCRIPTION: "ارسلتلك الملفات على الإيميل",
      itemIMAGE: "assets/image/png/WhatsApp Image 2025-11-19 at 11.20.02 PM.png",
      itemName: "Work Group",
      itemPRICE: "06:20 PM",
    ),
    ItemsModel(
      itemDESCRIPTION: "متى طالعين عالجامعة؟",
      itemIMAGE: "assets/image/png/دد.png",
      itemName: "College Friends",
      itemPRICE: "05:55 PM",
    ),
    ItemsModel(
      itemDESCRIPTION: "تمام الحمدلله، وانت؟",
      itemIMAGE: "assets/image/png/images.jpg",
      itemName: "Mohamad",
      itemPRICE: "04:18 PM",
    ),
    ItemsModel(
      itemDESCRIPTION: "تذكّر الامتحان بكرة ",
      itemIMAGE: "assets/image/png/WhatsApp Image 2025-11-19 at 11.20.02 PM.png",
      itemName: "Study Group",
      itemPRICE: "03:02 PM",
    ),
    ItemsModel(
      itemDESCRIPTION: "بوصلك بعد نص ساعة",
      itemIMAGE: "assets/image/png/WhatsApp Image 2025-11-19 at 11.20.02 PM.png",
      itemName: "Driver",
      itemPRICE: "01:47 PM",
    ),
    ItemsModel(
      itemDESCRIPTION: "شفت اللعبة مبارح؟",
      itemIMAGE: "assets/image/png/دد.png",
      itemName: "Gaming Squad",
      itemPRICE: "12:33 PM",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        title:  Text(
          "WhatsApp",
          style: TextStyle(
            color: Colors.white,

          ),
        ),
        centerTitle: false,
        iconTheme:  IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon:  Icon(Icons.camera_alt_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon:  Icon(Icons.search),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            iconColor: Colors.white,
            itemBuilder: (context) =>  [],
          ),
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.all(0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Container(
              margin:  EdgeInsets.only(bottom: 0),
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade800,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                   SizedBox(width: 12),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      items[index].itemIMAGE ?? "",
                    ),
                  ),
                   SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[index].itemName ?? "",
                          style:  TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                         SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                items[index].itemDESCRIPTION ?? "_",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                   SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        items[index].itemPRICE ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                       SizedBox(height: 6),
                      Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child:  Text(
                          "2",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                   SizedBox(width: 13),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.chat),
      ),
    );
  }
}
