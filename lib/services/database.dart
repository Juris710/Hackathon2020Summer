import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';

class DatabaseService {
  static DocumentReference getUserDocument(String uid) {
    return FirebaseFirestore.instance.doc('users/$uid');
  }

  static Stream<UserAccount> getAccount(String uid) {
    return getUserDocument(uid)
        .snapshots()
        .asyncMap((event) => UserAccount.fromFirestore(event));
  }
}
