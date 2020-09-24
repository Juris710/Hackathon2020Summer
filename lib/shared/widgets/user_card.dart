import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/user_data.dart';
import 'package:hackathon_2020_summer/services/database.dart';

class UserCard extends StatelessWidget {
  final DocumentReference userReference;
  final Widget Function(String) builder;

  UserCard({this.userReference, this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AccountModel>(
      stream: DatabaseService.getAccount(userReference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final account = snapshot.data;
        if (builder != null) {
          return builder(account.name);
        }
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text('ユーザー詳細'),
                  ),
                  body: UserData(
                    account: account,
                  ),
                ),
              ),
            );
          },
          child: Card(
            elevation: null,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                account.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}
