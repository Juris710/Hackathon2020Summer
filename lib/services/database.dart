import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get universities {
    return _db.collection('universities');
  }

  DocumentReference getUserDocument(String uid) {
    return _db.collection('users').doc(uid);
  }

  // static void createNewUser(
  //     String uid, String useName, DocumentReference university) {
  //   getUserDocument(uid).set({
  //     'name': useName,
  //     'university': university,
  //   });
  // }

  Stream<Account> getAccount(String uid) {
    if (uid == null) {
      print("DEBUG_PRINT Account Empty");
      return Stream.empty();
    }
    return _db.collection('users').doc(uid).snapshots().map((event) {
      print("DEBUG_PRINT Account");
      return Account.fromFirestore(event);
    });
  }

  Future<void> updateUserData(String uid, {String name}) async {
    getUserDocument(uid).set({'name': name}, SetOptions(merge: true));
  }
  // static Stream<Account> getAccount(DocumentReference ref) {
  //   return ref.snapshots().map((event) => Account.fromFirestore(event));
  // }

  Stream<Map<String, dynamic>> getConfigs(CollectionReference ref) {
    return ref.snapshots().map(
          (event) => Map.fromIterable(
            event.docs,
            key: (doc) => doc.id,
            value: (doc) => doc.data()['value'],
          ),
        );
  }
}
