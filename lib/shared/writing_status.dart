import 'package:flutter/material.dart';

class WritingStatusNotification extends Notification {
  final WritingStatus writingStatus;

  WritingStatusNotification({this.writingStatus});
}

enum WritingStatus { NotWriting, Writing }
