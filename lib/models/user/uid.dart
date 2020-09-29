import 'package:flutter/material.dart';

class UidModel extends ChangeNotifier {
  final String initialUid;
  UidModel({this.initialUid}) {
    if (initialUid != null) {
      _uid = initialUid;
    }
  }
  String _uid;
  get uid => _uid;
  set uid(String newUid) {
    _uid = newUid;
    notifyListeners();
  }
}
