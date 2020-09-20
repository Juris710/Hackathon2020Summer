import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/shared/widgets/lazy_text.dart';

class UserCard extends StatelessWidget {
  final String uid;

  UserCard({this.uid});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LazyText(
          future: FirebaseFirestore.instance.doc('users/$uid').get(),
          getString: (snapshot) => snapshot.data.data()['name'],
        ),
      ),
    );
  }
}
