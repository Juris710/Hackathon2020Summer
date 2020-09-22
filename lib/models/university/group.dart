import 'package:cloud_firestore/cloud_firestore.dart';

//TODO：一からつくるためのstatic create()作成
class UniversityGroup {
  final String id;
  final String name;
  final CollectionReference questionTargets;
  final CollectionReference children;

  UniversityGroup._({this.id, this.name, this.questionTargets, this.children});

  factory UniversityGroup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }
    final ref = doc.reference;
    return UniversityGroup._(
      id: doc.id,
      name: data['name'],
      questionTargets: ref.collection('question_targets'),
      children: ref.collection('children'),
    );
  }
}
