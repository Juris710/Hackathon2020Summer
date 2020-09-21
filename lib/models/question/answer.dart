import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String id;
  final String content;
  final String createdBy;
  final Timestamp updatedAt;

  Answer._({this.id, this.content, this.createdBy, this.updatedAt});

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Answer._(
      id: doc.id,
      content: data['content'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> data() {
    return {
      'content': content,
      'createdBy': createdBy,
      'updatedAt': updatedAt,
    };
  }
}
