import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionTarget {
  final DocumentReference reference;
  final String name;
  final CollectionReference questions;

  QuestionTarget._({this.reference, this.name, this.questions});

  factory QuestionTarget.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }
    final ref = doc.reference;
    return QuestionTarget._(
      reference: doc.reference,
      name: data['name'],
      questions: ref.collection('questions'),
    );
  }
}
