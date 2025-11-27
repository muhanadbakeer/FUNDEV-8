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
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 20),
            Text(
              item.itemName ?? "No Name",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Description: ${item.itemDESCRIPTION ?? '_'}"),
            const SizedBox(height: 10),
            Text("Price: ${item.itemPRICE ?? '_'}"),
          ],
        ),
      ),
    );
  }
}
