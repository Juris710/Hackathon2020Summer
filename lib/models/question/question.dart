import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String title;
  final String content;
  final String createdBy;
  final Timestamp updateAt;
  final CollectionReference answers;

  Question._({
    this.title,
    this.content,
    this.createdBy,
    this.updateAt,
    this.answers,
  });

  factory Question.fromMap(Map<String, dynamic> data) {
    return Question._(
      title: data['title'],
      content: data['content'],
      createdBy: data['createdBy'],
      updateAt: data['updatedAt'],
      answers: data['answers'],
    );
  }
}
