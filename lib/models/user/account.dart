import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';

class AccountSource {
  final String id;
  final String name;
  final DocumentReference university;
  final CollectionReference registered;

  AccountSource._({
    this.id,
    this.name,
    this.university,
    this.registered,
  });

  factory AccountSource.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return AccountSource._(
      id: doc.id,
      name: data['name'],
      university: data['university'],
      registered: doc.reference.collection('registered'),
    );
  }
}

class Account {
  final AccountSource source;
  final String id;
  final String name;
  final University university;
  final List<RegisteredItem> registered;

  Account._(
      {this.source, this.id, this.name, this.university, this.registered});

  static Future<Account> create(AccountSource source) async {
    final university = await source.university
        .get()
        .then((value) => University.fromFirestore(value));
    final registeredSource = await source.registered.get().then((value) =>
        value.docs.map((e) => RegisteredItemSource.fromFirestore(e)));
    final registered = await Future.wait(
        registeredSource.map((e) async => RegisteredItem.create(e)));
    return Account._(
      source: source,
      id: source.id,
      name: source.name,
      university: university,
      registered: registered,
    );
  }
}
