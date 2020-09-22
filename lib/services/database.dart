import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/university/group.dart' as Model;
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
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
        .map((event) => Account.fromFirestore(event));
  }

  static void createNewUser(String uid, String useName, String universityId) {
    getUserDocument(uid).set({
      'name': useName,
      'lectures': [],
      'university': universities.doc(universityId),
    });
  }

  static Stream<Model.UniversityGroup> getUniversityGroup(
      DocumentReference doc) {
    return doc.snapshots().transform(
      StreamTransformer<DocumentSnapshot, Model.UniversityGroup>.fromHandlers(
        handleData: (value, sink) {
          return sink.add(Model.UniversityGroup.fromFireStore(value));
        },
      ),
    );
  }

  static Stream<Model.QuestionTarget> getQuestionTarget(DocumentReference doc) {
    return doc.snapshots().transform(
      StreamTransformer<DocumentSnapshot, Model.QuestionTarget>.fromHandlers(
        handleData: (value, sink) {
          sink.add(Model.QuestionTarget.fromFireStore(value));
        },
      ),
    );
  }
// static void updateAccount(UserAccount account) {
//   getUserDocument(account.id).update(account.data());
// }
}
