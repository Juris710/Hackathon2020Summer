import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';

class DatabaseService {
  static CollectionReference get universities {
    return FirebaseFirestore.instance.collection('universities');
  }

  static DocumentReference getUserDocument(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  // static void createNewUser(
  //     String uid, String useName, DocumentReference university) {
  //   getUserDocument(uid).set({
  //     'name': useName,
  //     'university': university,
  //   });
  // }

  static Stream<Account> getAccount(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => Account.fromFirestore(event));
  }

  // static Stream<Account> getAccount(DocumentReference ref) {
  //   return ref.snapshots().map((event) => Account.fromFirestore(event));
  // }

  static Stream<Map<String, dynamic>> getConfigs(CollectionReference ref) {
    return ref.snapshots().map(
          (event) => Map.fromIterable(
            event.docs,
            key: (doc) => doc.id,
            value: (doc) => doc.data()['value'],
          ),
        );
  }
}
