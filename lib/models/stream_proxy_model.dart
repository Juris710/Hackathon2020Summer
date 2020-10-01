import 'dart:async';

import 'package:flutter/material.dart';

class StreamProxyModel<T, R> extends ChangeNotifier {
  final Stream<R> Function(T) create;
  final bool notifyOnStreamIsNull;

  StreamProxyModel({this.create, this.notifyOnStreamIsNull});

  R value;
  StreamSubscription subscription;

  void update(T otherModelValue) {
    subscription?.cancel();
    final newStream = create(otherModelValue);
    if (newStream == null) {
      if (notifyOnStreamIsNull == true) {
        value = null;
        notifyListeners();
      }
    } else {
      subscription = newStream.listen((event) {
        value = event;
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
