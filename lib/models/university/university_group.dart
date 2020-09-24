import 'package:cloud_firestore/cloud_firestore.dart';

//日本語名：質問グループ
class UniversityGroupModel {
  final DocumentReference reference;
  final String name;
  final CollectionReference questionTargets;
  final CollectionReference children;

  UniversityGroupModel._(
      {this.reference, this.name, this.questionTargets, this.children});

  factory UniversityGroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data();
    if (data == null) {
      return null;
    }
    final ref = doc.reference;
    return UniversityGroupModel._(
      reference: doc.reference,
      name: data['name'],
      questionTargets: ref.collection('question_targets'),
      children: ref.collection('children'),
    );
  }
}
