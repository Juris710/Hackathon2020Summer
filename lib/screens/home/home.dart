import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';

class Home extends StatefulWidget {
  final String uid;

  Home({this.uid});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //TODO：中身実装
    //final uid = widget.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign out'),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'HOME',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            // Text(
            //   uid,
            //   style: Theme.of(context).textTheme.headline6,
            // ),
          ],
        ),
      ),
    );
  }
}
