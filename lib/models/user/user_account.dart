import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackathon_2020_summer/models/university/lecture.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';

class UserAccount {
  final String id;
  final String name;
  final University university;
  final List<Lecture> lectures;

  UserAccount._({this.id, this.name, this.university, this.lectures});

  static Future<UserAccount> fromFirestore(DocumentSnapshot doc) async {
    final data = doc?.data();
    if (data == null) return null;
    final university = await data['university']
        .get()
        .then((value) => University.fromFirestore(value));
    final lectureRefs = castToList<DocumentReference>(data['lectures']);
    final lectureFutures = lectureRefs.map(
        (ref) async => ref.get().then((value) => Lecture.fromFirestore(value)));
    final lectures = await Future.wait(lectureFutures);
    return UserAccount._(
      id: doc.id,
      name: data['name'],
      university: university,
      lectures: lectures,
    );
  }
}
