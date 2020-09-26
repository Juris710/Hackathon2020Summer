import 'package:flutter/material.dart';

const appName = 'Nior(ニアー)';
const appVersion = '1.0.0';

final textFieldDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.0),
    borderSide: BorderSide(),
  ),
);

class UserSettings {
  static const String KEY_NEVER_SHOW_AGAIN_CONFIRM_REGISTER_UNIVERSITY_GROUP =
      'NEVER_SHOW_AGAIN_CONFIRM_REGISTER_UNIVERSITY_GROUP';
}
