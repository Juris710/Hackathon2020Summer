import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final DocumentReference reference;
  final bool isNewUser;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;
  final CollectionReference configs;

  Account._({
    this.reference,
    this.isNewUser,
    this.name,
    this.university,
    this.registered,
    this.configs,
  });

  bool get isNoUser {
    return (reference == null);
  }

  factory Account.noUser() {
    return Account._();
  }

  factory Account.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data() ?? {};
    if (data.isEmpty) {
      return Account._(
        reference: doc.reference,
        isNewUser: true,
      );
    }
    return Account._(
      reference: doc.reference,
      isNewUser: false,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
      configs: doc.reference.collection('configs'),
    );
  }
}
