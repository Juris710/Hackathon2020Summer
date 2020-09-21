import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';

class DatabaseService {
  static CollectionReference get universities {
    return FirebaseFirestore.instance.collection('universities');
  }

  static DocumentReference getUserDocument(String uid) {
    return FirebaseFirestore.instance.doc('users/$uid');
  }

  static Stream<UserAccount> getAccount(String uid) {
    return getUserDocument(uid)
        .snapshots()
        .asyncMap((event) => UserAccount.fromFirestore(event));
  }

  static void createNewUser(String uid, String useName, String universityId) {
    getUserDocument(uid).set({
      'name': useName,
      'lectures': [],
      'university': universities.doc(universityId),
    });
  }
}
