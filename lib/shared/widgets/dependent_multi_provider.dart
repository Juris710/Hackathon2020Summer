import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependentMultiProvider<T> extends StatelessWidget {
  final List<SingleChildWidget> Function(T) providersBuilder;
  final Widget child;

  DependentMultiProvider({
    this.providersBuilder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final value = Provider.of<T>(context);
    return MultiProvider(
      providers: providersBuilder(value),
      child: child,
    );
  }
}
