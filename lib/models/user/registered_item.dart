import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';

class RegisteredItem {
  final DocumentReference group;
  final List<DocumentReference> questionTargets;

  RegisteredItem._({this.group, this.questionTargets});

  factory RegisteredItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return RegisteredItem._(
      group: data['group'],
      questionTargets: castToList<DocumentReference>(data['question_targets']),
    );
  }
}
