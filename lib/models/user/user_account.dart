import 'package:cloud_firestore/cloud_firestore.dart';

class UserAccount {
  final String name;
  final DocumentReference university;
  final List<DocumentReference> lectures;
  UserAccount({this.name, this.university, this.lectures});

  factory UserAccount.fromFireStore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return UserAccount(
        name: data['name'],
        university: data['university'],
        lectures: data['lectures'].cast<DocumentReference>()
            as List<DocumentReference>);
  }
}
