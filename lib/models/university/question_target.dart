import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionTargetModel {
  final DocumentReference reference;
  final String name;
  final CollectionReference questions;

  QuestionTargetModel._({this.reference, this.name, this.questions});

  factory QuestionTargetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }
    final ref = doc.reference;
    return QuestionTargetModel._(
      reference: doc.reference,
      name: data['name'],
      questions: ref.collection('questions'),
    );
  }
}
