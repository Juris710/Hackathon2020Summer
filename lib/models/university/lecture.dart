import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';

class Lecture {
  final String id;
  final String name;
  final List<String> allocation;
  final List<DocumentReference> questions;

  Lecture._({this.id, this.name, this.allocation, this.questions});

  factory Lecture.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return Lecture._(
      id: doc.id,
      name: data['name'],
      allocation: castToList<String>(data['allocation']),
      questions: castToList<DocumentReference>(data['questions']),
    );
  }

  Map<String, dynamic> data() {
    return {
      'name': name,
      'allocation': allocation,
      'questions': questions,
    };
  }
}
