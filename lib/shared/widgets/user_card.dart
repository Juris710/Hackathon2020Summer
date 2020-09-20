import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String uid;

  UserCard({this.uid});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => value.data()),
      builder: (context, snapshot) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (snapshot.connectionState != ConnectionState.done)
                  ? ''
                  : snapshot.data['name'],
            ),
          ),
        );
      },
    );
  }
}
