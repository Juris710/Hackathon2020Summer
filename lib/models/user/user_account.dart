import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  final String name;
  final DocumentReference university;
  UserAccount({this.name, this.university});

  factory UserAccount.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data();
    return UserAccount(
      name: data['name'],
      university: data['university'],
    );
  }
}
