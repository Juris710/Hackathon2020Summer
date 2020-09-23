import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  final DocumentReference reference;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;

  AccountModel._({
    this.reference,
    this.name,
    this.university,
    this.registered,
  });

  factory AccountModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return AccountModel._(
      reference: doc.reference,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
    );
  }
}
