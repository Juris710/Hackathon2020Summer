import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String title;
  final String content;
  final String createdBy;
  final Timestamp updateAt;
  final CollectionReference answers;

  Question._({
    this.id,
    this.title,
    this.content,
    this.createdBy,
    this.updateAt,
    this.answers,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Question._(
      id: doc.id,
      title: data['title'],
      content: data['content'],
      createdBy: data['createdBy'],
      updateAt: data['updatedAt'],
      answers: doc.reference.collection('answers'),
    );
  }
  Map<String, dynamic> data() {
    return {
      'title': title,
      'content': content,
      'createdBy': createdBy,
      'updateAt': updateAt,
      //'answers': answers,
    };
  }
}
