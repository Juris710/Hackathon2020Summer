import 'package:flutter/material.dart';

class UidModel extends ChangeNotifier {
  String _uid;
  get uid => _uid;
  set uid(String newUid) {
    _uid = newUid;
    notifyListeners();
  }
}
