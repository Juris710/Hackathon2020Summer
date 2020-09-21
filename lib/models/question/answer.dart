import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String content;
  final String createdBy;
  final Timestamp updatedAt;
  Answer({this.content, this.createdBy, this.updatedAt});
}
