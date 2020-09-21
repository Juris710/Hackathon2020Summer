import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionTarget {
  final String id;
  final String name;
  final CollectionReference questions;

  QuestionTarget._({this.id, this.name, this.questions});

  factory QuestionTarget.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }
    final ref = doc.reference;
    return QuestionTarget._(
      id: doc.id,
      name: data['name'],
      questions: ref.collection('questions'),
    );
  }
}
