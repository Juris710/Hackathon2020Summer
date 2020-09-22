import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';

class DatabaseService {
  static CollectionReference get universities {
    return FirebaseFirestore.instance.collection('universities');
  }

  static DocumentReference getUniversityDocument(String universityId) {
    return universities.doc(universityId);
  }

  static DocumentReference getUserDocument(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  static Stream<Account> getAccount(String uid) {
    return getUserDocument(uid)
        .snapshots()
        .map((event) => AccountSource.fromFirestore(event))
        .asyncMap((event) => Account.create(event));
  }

  static void createNewUser(String uid, String useName, String universityId) {
    getUserDocument(uid).set({
      'name': useName,
      'lectures': [],
      'university': universities.doc(universityId),
    });
  }

  // static void updateAccount(UserAccount account) {
  //   getUserDocument(account.id).update(account.data());
  // }
}
