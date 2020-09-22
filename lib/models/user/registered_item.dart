import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/university/group.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';

class RegisteredItem {
  final UniversityGroup group;
  final List<QuestionTarget> questionTargets;

  RegisteredItem._({this.group, this.questionTargets});

  static Future<RegisteredItem> create(RegisteredItemSource source) async {
    final group = await source.group
        .get()
        .then((value) => UniversityGroup.fromFireStore(value));
    final questionTargetSources = await Future.wait(source.questionTargets.map(
        (e) async => e
            .get()
            .then((value) => QuestionTargetSource.fromFireStore(value))));
    final questionTargets = await Future.wait(
        questionTargetSources.map((e) async => await QuestionTarget.create(e)));
    return RegisteredItem._(
      group: group,
      questionTargets: questionTargets,
    );
  }
}

class RegisteredItemSource {
  final DocumentReference group;
  final List<DocumentReference> questionTargets;

  RegisteredItemSource._({this.group, this.questionTargets});

  factory RegisteredItemSource.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return RegisteredItemSource._(
      group: data['group'],
      questionTargets: castToList<DocumentReference>(data['question_targets']),
    );
  }
}
