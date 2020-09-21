import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/shared/Database_Utils.dart';

class Lecture {
  final String name;
  final List<DocumentReference> questions;

  Lecture({this.name, this.questions});

  factory Lecture.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Lecture(
      name: data['name'],
      questions: castToRefList(data['questions']),
    );
  }
}
