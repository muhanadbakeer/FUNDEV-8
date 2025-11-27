import 'package:flutter/material.dart';

import 'model/items.dart';

class Gredview extends StatefulWidget {
  const Gredview({super.key});

  @override
  State<Gredview> createState() => _GredviewState();
}

class _GredviewState extends State<Gredview> {
  List<ItemsModel> items = [
    ItemsModel(
      itemDESCRIPTION: "hp",
      itemIMAGE: "https://www.hp.com/content/dam/sites/worldwide/personal-computers/consumer/laptops-and-2-in-1s/new/bf-updates/media@2x1.jpg",
      itemName: "evi",
      itemPRICE: "1.34",
    ),
    ItemsModel(
      itemDESCRIPTION: "msi",
      itemIMAGE: "https://static0.pocketlintimages.com/wordpress/wp-content/uploads/144117-laptops-news-msi-unveils-new-line-of-gaming-laptops-including-the-world%E2%80%99s-first-intel-core-i9-powered-laptop-image1-vlu8d01wb5.jpg?w=1600&h=900&fit=crop",
      itemName: "sword",
      itemPRICE: "1.34",
    ),
    ItemsModel(
      itemDESCRIPTION: "dell",
      itemName: "fin",
      itemPRICE: "1.67",
      itemIMAGE: "https://zurimall.co.ke/wp-content/uploads/2022/12/Artboard-1-copy-2@300x-100-88.jpg",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GridView.builder(
        itemCount:items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:3,
          mainAxisExtent: 250,
          crossAxisSpacing: 15,
          mainAxisSpacing: 40
        ),
        itemBuilder:(context,index){
          return Padding(padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),

                ),
                child: Column(
                  children: [
                    Image.network(items[index].itemIMAGE??"_",
                    width: double.infinity,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Text(items[index].itemPRICE??"_"),
                     Text(items[index].itemName??"_"),

                   ],

                 ),
                    Text(items[index].itemDESCRIPTION??"_"),
                    ElevatedButton(onPressed: (){}, child: Text("ADD TO CART")),
                  ],
                ),
              ),
          );
        }

      ),
    );

  }
}
