import 'package:cloud_firestore/cloud_firestore.dart';

//TODO：Firestoreからlectures関連を全て削除
//TODO：一からつくるためのstatic create()作成

class University {
  final String id;
  final String name;
  final CollectionReference groups;
  University._({this.id, this.name, this.groups});

  factory University.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return University._(
      id: doc.id,
      name: data['name'],
      groups: doc.reference.collection('groups'),
    );
  }
}
