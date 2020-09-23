import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final DocumentReference reference;
  final String content;
  final String createdBy;
  final Timestamp updatedAt;

  AnswerModel._({this.reference, this.content, this.createdBy, this.updatedAt});

  factory AnswerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return AnswerModel._(
      reference: doc.reference,
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
