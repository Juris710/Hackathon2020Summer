import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String content;
  final String createdBy;
  final Timestamp updatedAt;
  Answer({this.content, this.createdBy, this.updatedAt});

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Answer(
      content: data['content'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'],
    );
  }
}
