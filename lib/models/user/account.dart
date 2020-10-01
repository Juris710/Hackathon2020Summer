import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon_2020_summer/models/stream_proxy_model.dart';

class Account {
  final DocumentReference reference;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;
  final CollectionReference configs;

  Account._({
    this.reference,
    this.name,
    this.university,
    this.registered,
    this.configs,
  });

  factory Account.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Account._(
      reference: doc.reference,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
      configs: doc.reference.collection('configs'),
    );
  }
}

class AccountModel extends StreamProxyModel<User, Account> {
  AccountModel({Stream<Account> Function(User) create})
      : super(create: create, notifyOnStreamIsNull: true);
}
