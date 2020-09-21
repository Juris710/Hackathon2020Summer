import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/lecture.dart' as Model;

class Lecture extends StatelessWidget {
  final Model.Lecture lecture;

  Lecture({this.lecture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.name),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Text(
              lecture.allocation.reduce((value, element) => '$value $element'),
            ),
          ],
        ),
      ),
    );
  }
}
