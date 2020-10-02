import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';

class Loading extends StatelessWidget {
  Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SpinKitWave(
          color: Theme.of(context).accentColor,
          size: 50.0,
        ),
      ),
    );
  }
}

class LoadingScaffold extends StatelessWidget {
  final String title;

  LoadingScaffold({Key key, this.title = appName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Loading(),
    );
  }
}

class LoadingSmall extends StatelessWidget {
  LoadingSmall({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
