import 'package:cloud_firestore/cloud_firestore.dart';

class University {
  final String name;
  final CollectionReference lectures;

  University({this.name, this.lectures});

  factory University.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return University(
      name: data['name'],
      lectures: doc.reference.collection('lectures'),
    );
  }
}
