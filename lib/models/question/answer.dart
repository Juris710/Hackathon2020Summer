import 'package:cloud_firestore/cloud_firestore.dart';

//TODO：一からつくるためのstatic create()作成
class Answer {
  final DocumentReference reference;
  final String content;
  final String createdBy;
  final Timestamp updatedAt;

  Answer._({this.reference, this.content, this.createdBy, this.updatedAt});

  factory Answer.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Answer._(
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
