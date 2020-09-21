import 'package:cloud_firestore/cloud_firestore.dart';

class University {
  final String id;
  final String name;
  final CollectionReference lectures;

  University._({this.id, this.name, this.lectures});

  factory University.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return University._(
      id: doc.id,
      name: data['name'],
      lectures: doc.reference.collection('lectures'),
    );
  }
  Map<String, dynamic> data() {
    return {
      'name': name,
      //'lectures': lectures
    };
  }
}
