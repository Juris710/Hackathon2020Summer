import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyModel {
  final DocumentReference reference;
  final String content;
  final DocumentReference createdBy;
  final Timestamp createdAt;

  ReplyModel._({this.reference, this.content, this.createdBy, this.createdAt});

  factory ReplyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return ReplyModel._(
      reference: doc.reference,
      content: data['content'],
      createdBy: data['createdBy'],
      createdAt: data['createdAt'],
    );
  }
}
