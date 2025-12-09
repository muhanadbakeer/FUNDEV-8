import 'package:flutter/material.dart';
import 'package:div/model/items.dart';

class ItemDetailsPage extends StatelessWidget {
  final ItemsModel item;

  const ItemDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.itemName ?? "Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                item.itemIMAGE ?? "",
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
             SizedBox(height: 20),
            Text(
              item.itemName ?? "No Name",
              style:  TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
             SizedBox(height: 10),
            Text("Description: ${item.itemDESCRIPTION ?? '_'}"),
             SizedBox(height: 10),
            Text("Price: ${item.itemPRICE ?? '_'}"),
          ],
        ),
      ),
    );
  }
}
