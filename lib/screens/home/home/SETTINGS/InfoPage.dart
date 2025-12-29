import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  InfoPage({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Text(description, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
