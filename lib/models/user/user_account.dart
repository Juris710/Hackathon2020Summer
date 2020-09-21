import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/university/lecture.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';

class UserAccount {
  final String name;
  final DocumentReference university;
  final List<Lecture> lectures;

  UserAccount({this.name, this.university, this.lectures});

  static Future<UserAccount> fromFirestore(DocumentSnapshot doc) async {
    final data = doc?.data();
    if (data == null) return null;
    final lectureRefs = castToList<DocumentReference>(data['lectures']);
    final lectureFutures = lectureRefs.map(
        (ref) async => ref.get().then((value) => Lecture.fromFirestore(value)));
    final lectures = await Future.wait(lectureFutures);
    return UserAccount(
      name: data['name'],
      university: data['university'],
      lectures: lectures,
    );
  }
}
