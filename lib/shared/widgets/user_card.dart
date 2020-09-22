import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/screens/root/user_data.dart';
import 'package:hackathon_2020_summer/services/database.dart';

class UserCard extends StatelessWidget {
  final String uid;

  UserCard({this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseService.getUserDocument(uid)
          .get()
          .then((value) => Model.Account.fromFirestore(value)),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
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
                    account: snapshot.data,
                  ),
                ),
              ),
            );
          },
          child: Card(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(snapshot.data.name),
            ),
          ),
        );
      },
    );
  }
}
