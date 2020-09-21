import 'package:flutter/material.dart';

class LazyText extends StatelessWidget {
  final Future future;
  final String Function(AsyncSnapshot) getString;
  final Text Function(String) textBuilder;

  LazyText({this.future, this.textBuilder, this.getString});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Text('');
        }
        if (textBuilder != null) {
          return textBuilder(getString(snapshot));
        } else {
          return Text(getString(snapshot));
        }
      },
    );
  }
}
