import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
      ),
    );
  }
}
