import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart';
import 'package:hackathon_2020_summer/models/question/question.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';

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

  static Stream<AccountModel> getAccount(String uid) {
    return getUserDocument(uid)
        .snapshots()
        .map((event) => AccountModel.fromFirestore(event));
  }

  static void createNewUser(
      String uid, String useName, DocumentReference university) {
    getUserDocument(uid).set({
      'name': useName,
      'university': university,
    });
  }

  static Stream<UniversityModel> getUniversity(DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, UniversityModel>.fromHandlers(
        handleData: (value, sink) {
          sink.add(UniversityModel.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<UniversityGroupModel> getUniversityGroup(
      DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, UniversityGroupModel>.fromHandlers(
        handleData: (value, sink) {
          sink.add(UniversityGroupModel.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<QuestionModel> getQuestion(DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, QuestionModel>.fromHandlers(
        handleData: (value, sink) {
          sink.add(QuestionModel.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<List<AnswerModel>> getAnswers(CollectionReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<QuerySnapshot, List<AnswerModel>>.fromHandlers(
        handleData: (value, sink) {
          sink.add(
            value.docs.map((doc) => AnswerModel.fromFirestore(doc)).toList(),
          );
        },
      ),
    );
  }

  static Stream<QuestionTargetModel> getQuestionTarget(DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, QuestionTargetModel>.fromHandlers(
        handleData: (value, sink) {
          sink.add(QuestionTargetModel.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<RegisteredItemModel> getRegisteredItem(DocumentReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<DocumentSnapshot, RegisteredItemModel>.fromHandlers(
        handleData: (value, sink) {
          return sink.add(RegisteredItemModel.fromFirestore(value));
        },
      ),
    );
  }

  static Stream<List<RegisteredItemModel>> getRegistered(
      CollectionReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<QuerySnapshot, List<RegisteredItemModel>>.fromHandlers(
        handleData: (value, sink) {
          return sink.add(value.docs
              .map((doc) => RegisteredItemModel.fromFirestore(doc))
              .toList());
        },
      ),
    );
  }
}
