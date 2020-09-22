import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart' as Model;
import 'package:hackathon_2020_summer/models/question/question.dart' as Model;
import 'package:hackathon_2020_summer/models/university/group.dart' as Model;
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/models/user/registered_item.dart'
    as Model;

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

  static Stream<Model.Account> getAccount(String uid) {
    return getUserDocument(uid)
        .snapshots()
        .map((event) => Model.Account.fromFirestore(event));
  }

  static void createNewUser(String uid, String useName, String universityId) {
    getUserDocument(uid).set({
      'name': useName,
      'university': universities.doc(universityId),
    });
  }

  static Stream<Model.UniversityGroup> getUniversityGroup(
      DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, Model.UniversityGroup>.fromHandlers(
        handleData: (value, sink) {
          return sink.add(Model.UniversityGroup.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<Model.Question> getQuestion(DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, Model.Question>.fromHandlers(
        handleData: (value, sink) {
          sink.add(Model.Question.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<List<Model.Answer>> getAnswers(CollectionReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<QuerySnapshot, List<Model.Answer>>.fromHandlers(
        handleData: (value, sink) {
          sink.add(
            value.docs.map((doc) => Model.Answer.fromFirestore(doc)).toList(),
          );
        },
      ),
    );
  }

  static Stream<Model.QuestionTarget> getQuestionTarget(DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, Model.QuestionTarget>.fromHandlers(
        handleData: (value, sink) {
          sink.add(Model.QuestionTarget.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<List<Model.RegisteredItem>> getRegistered(
      CollectionReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<QuerySnapshot, List<Model.RegisteredItem>>.fromHandlers(
        handleData: (value, sink) {
          return sink.add(value.docs
              .map((doc) => Model.RegisteredItem.fromFirestore(doc))
              .toList());
        },
      ),
    );
  }
}
