import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<User>(context)?.uid;
    if (uid == null) {
      return Container();
    }
    return Container(
      child: Center(
        child: Text('ACCOUNT\n$uid'),
      ),
    );
  }
}
