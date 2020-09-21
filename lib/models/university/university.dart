import 'package:cloud_firestore/cloud_firestore.dart';

//TODO：Firestoreからlectures関連を全て削除
//TODO：一からつくるためのstatic create()作成
class University {
  final String id;
  final String name;
  final CollectionReference lectures; //このフィールドを削除
  final CollectionReference groups;

  University._({this.id, this.name, this.lectures, this.groups});

  factory University.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return University._(
      id: doc.id,
      name: data['name'],
      lectures: doc.reference.collection('lectures'),
      groups: doc.reference.collection('groups'),
    );
  }
  // Map<String, dynamic> data() {
  //   return {
  //     'name': name,
  //   };
  // }
}
