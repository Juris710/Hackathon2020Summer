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

  static DocumentReference getUserDocument(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid);
  }

  static void createNewUser(
      String uid, String useName, DocumentReference university) {
    getUserDocument(uid).set({
      'name': useName,
      'university': university,
    });
  }

  static Stream<AccountModel> getAccount(DocumentReference ref) {
    return ref.snapshots().map((event) => AccountModel.fromFirestore(event));
  }

  static Stream<UniversityModel> getUniversity(DocumentReference ref) {
    return ref.snapshots().map((doc) => UniversityModel.fromFirestore(doc));
  }

  static Stream<UniversityGroupModel> getUniversityGroup(
      DocumentReference ref) {
    return ref
        .snapshots()
        .map((doc) => UniversityGroupModel.fromFirestore(doc));
  }

  static Stream<QuestionModel> getQuestion(DocumentReference ref) {
    return ref.snapshots().map((doc) => QuestionModel.fromFirestore(doc));
  }

  static Stream<List<AnswerModel>> getAnswers(CollectionReference ref) {
    return ref.orderBy('updatedAt').snapshots().map((event) =>
        event.docs.map((doc) => AnswerModel.fromFirestore(doc)).toList());
  }

  static Stream<QuestionTargetModel> getQuestionTarget(DocumentReference ref) {
    return ref.snapshots().map((doc) => QuestionTargetModel.fromFirestore(doc));
  }

  static Stream<RegisteredItemModel> getRegisteredItem(DocumentReference ref) {
    return ref.snapshots().map((doc) => RegisteredItemModel.fromFirestore(doc));
  }

  static Stream<Map<String, dynamic>> getConfigs(CollectionReference ref) {
    return ref.snapshots().map(
          (event) => Map.fromIterable(
            event.docs,
            key: (doc) => doc.id,
            value: (doc) => doc.data()['value'],
          ),
        );
  }

  static Stream<List<RegisteredItemModel>> getRegistered(
      CollectionReference ref) {
    return ref.snapshots().map((event) => event.docs
        .map((doc) => RegisteredItemModel.fromFirestore(doc))
        .toList());
  }
}
