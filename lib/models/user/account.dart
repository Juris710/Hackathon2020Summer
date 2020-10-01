import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final DocumentReference reference;
  final bool dataExists;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;
  final CollectionReference configs;

  Account._({
    this.reference,
    this.dataExists,
    this.name,
    this.university,
    this.registered,
    this.configs,
  });

  factory Account.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (!doc.exists || data == null) {
      return Account._(
        reference: doc.reference,
        dataExists: false,
      );
    }
    return Account._(
      reference: doc.reference,
      dataExists: true,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
      configs: doc.reference.collection('configs'),
    );
  }
}
