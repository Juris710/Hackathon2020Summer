import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionModel {
  final DocumentReference reference;
  final String title;
  final String content;
  final DocumentReference createdBy;
  final Timestamp updatedAt;
  final CollectionReference answers;

  QuestionModel._({
    this.reference,
    this.title,
    this.content,
    this.createdBy,
    this.updatedAt,
    this.answers,
  });

  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return QuestionModel._(
      reference: doc.reference,
      title: data['title'],
      content: data['content'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'],
      answers: doc.reference.collection('answers'),
    );
  }
  Map<String, dynamic> data() {
    return {
      'title': title,
      'content': content,
      'createdBy': createdBy,
      'updateAt': updatedAt,
      //'answers': answers,
    };
  }
}
