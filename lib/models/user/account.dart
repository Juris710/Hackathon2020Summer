import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String id;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;

  Account._({
    this.id,
    this.name,
    this.university,
    this.registered,
  });

  factory Account.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Account._(
      id: doc.id,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
    );
  }
}
