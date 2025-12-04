import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class http1 extends StatefulWidget {
  const http1({super.key});

  @override
  State<http1> createState() => _httpState();
}

class _httpState extends State<http1> {
  List data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final uri = Uri.parse("https://jsonplaceholder.typicode.com/posts");
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      print("res body=>${res.body}");
      setState(() {
        data = jsonDecode(res.body);
        print("data=>${data}");
      });
    } else {
      print("object=>${res.statusCode}");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GIT API"), centerTitle: true),
      body: ListView.separated(
        itemCount: data.length,
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },

        itemBuilder: (context, index) {
          return data.isEmpty
              ? Center(child: Text("NO DATA FAUND"))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(13),
                      color: Colors.cyan,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      children: [
                        Text("title:${data[index]["title"]}"),
                        Text("body:${data[index]["body"]}"),

                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}
