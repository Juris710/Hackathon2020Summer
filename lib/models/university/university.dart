import 'package:cloud_firestore/cloud_firestore.dart';

//TODO：一からつくるためのstatic create()作成

class UniversityModel {
  final DocumentReference reference;
  final String name;
  final CollectionReference groups;

  UniversityModel._({this.reference, this.name, this.groups});

  factory UniversityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;

    return UniversityModel._(
      reference: doc.reference,
      name: data['name'],
      groups: doc.reference.collection('groups'),
    );
  }
}
