import 'package:cloud_firestore/cloud_firestore.dart';

List<DocumentReference> castToRefList(dynamic references) {
  return references.cast<DocumentReference>() as List<DocumentReference>;
}
