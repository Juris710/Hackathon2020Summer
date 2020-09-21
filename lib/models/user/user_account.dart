import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/shared/Database_Utils.dart';

class UserAccount {
  final String name;
  final DocumentReference university;
  final List<DocumentReference> lectures;

  UserAccount({this.name, this.university, this.lectures});

  factory UserAccount.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return UserAccount(
      name: data['name'],
      university: data['university'],
      lectures: castToRefList(data['lectures']),
    );
  }
}
