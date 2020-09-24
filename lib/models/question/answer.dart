import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerModel {
  final DocumentReference reference;
  final String content;
  final DocumentReference createdBy;
  final Timestamp updatedAt;
  final CollectionReference replies;

  AnswerModel._({
    this.reference,
    this.content,
    this.createdBy,
    this.updatedAt,
    this.replies,
  });

  factory AnswerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return AnswerModel._(
      reference: doc.reference,
      content: data['content'],
      createdBy: data['createdBy'],
      updatedAt: data['updatedAt'],
      replies: doc.reference.collection('replies'),
    );
  }
}
