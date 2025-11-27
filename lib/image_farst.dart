import 'package:flutter/material.dart';

class image_farst extends StatefulWidget {
  const image_farst({super.key});

  @override
  State<image_farst> createState() => _image_farstState();
}

class _image_farstState extends State<image_farst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
        "assets/image/png/images.jpg"
        ),
      ),
    );
  }
}
