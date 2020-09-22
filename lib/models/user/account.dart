import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final DocumentReference reference;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;

  Account._({
    this.reference,
    this.name,
    this.university,
    this.registered,
  });

  factory Account.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Account._(
      reference: doc.reference,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
    );
  }
}
