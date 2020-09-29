import 'dart:async';

import 'package:flutter/cupertino.dart';

class StreamProxyModel<T, R> extends ChangeNotifier {
  final Stream<R> Function(T) create;
  StreamProxyModel({this.create});

  R value;
  StreamSubscription subscription;

  void update(T otherModelValue) {
    subscription?.cancel();
    subscription = create(otherModelValue)?.listen((event) {
      value = event;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }
}
