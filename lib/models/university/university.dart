import 'package:cloud_firestore/cloud_firestore.dart';

//TODO：一からつくるためのstatic create()作成

class University {
  final DocumentReference reference;
  final String name;
  final CollectionReference groups;
  University._({this.reference, this.name, this.groups});

  factory University.fromFirestore(DocumentSnapshot doc) {
    final data = doc?.data();
    if (data == null) return null;
    return University._(
      reference: doc.reference,
      name: data['name'],
      groups: doc.reference.collection('groups'),
    );
  }
}
