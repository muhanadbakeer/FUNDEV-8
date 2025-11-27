import 'package:div/model/person.dart';
import 'package:flutter/material.dart';

class ListViow extends StatefulWidget {
  const ListViow({super.key});

  @override
  State<ListViow> createState() => _ListViowState();
}

class _ListViowState extends State<ListViow> {
  List<personModel> person = [
    personModel(name: "mohamad", age: 20, gender: "male"),
    personModel(name: "mohanad", age: 21, gender: "male"),
    personModel(name: "majed", age: 22, gender: "male"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: person.length,
          itemBuilder: (context, index) {
            return Card(
              child: Center(
                child: Column(
                  children: [
                    Text("MY neme is : ${person[index].name}"),
                    Text("MY age is :" + person[index].age.toString()),
                    Text("MY gender is :" + person[index].gender!),
                  ],
                ),
              ),
            );
            // return Text(person[index].name ?? "-");
          },
        ),
      ),
    );
  }
}
