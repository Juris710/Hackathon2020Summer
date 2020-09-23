import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';

class RegisteredItemModel {
  final DocumentReference reference;
  final DocumentReference group;
  final List<DocumentReference> questionTargets;

  RegisteredItemModel._({this.reference, this.group, this.questionTargets});

  factory RegisteredItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return RegisteredItemModel._(
      reference: doc.reference,
      group: data['group'],
      questionTargets: castToList<DocumentReference>(data['question_targets']),
    );
  }
}
