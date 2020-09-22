import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/question/question.dart';

//TODO：一からつくるためのstatic create()作成
class QuestionTarget {
  final String id;
  final String name;
  final List<Question> questions;

  QuestionTarget._({this.id, this.name, this.questions});

  static Future<QuestionTarget> create(QuestionTargetSource source) async {
    final questions = await source.questions
        .get()
        .then((value) => value.docs.map((e) => Question.fromFirestore(e)));
    return QuestionTarget._(
      id: source.id,
      name: source.name,
      questions: questions.toList(),
    );
  }
}

class QuestionTargetSource {
  final String id;
  final String name;
  final CollectionReference questions;

  QuestionTargetSource._({this.id, this.name, this.questions});

  factory QuestionTargetSource.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }
    final ref = doc.reference;
    return QuestionTargetSource._(
      id: doc.id,
      name: data['name'],
      questions: ref.collection('questions'),
    );
  }
}
