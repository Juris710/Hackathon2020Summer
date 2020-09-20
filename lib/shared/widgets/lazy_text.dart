import 'package:flutter/material.dart';

class LazyText extends StatelessWidget {
  final Future future;
  final String Function(AsyncSnapshot) getText;
  LazyText({this.future, this.getText});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Text('');
          }
          return Text(getText(snapshot));
        });
  }
}
