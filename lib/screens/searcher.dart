import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class Searcher<T> extends StatelessWidget {
  final Stream<List<T>> getSearchTargets;
  final AppBar appBar;
  final String inputLabelText;
  final Widget notFoundWidget;
  final bool Function(T, String) matches;
  final Widget Function(T) itemBuilder;

  Searcher({
    this.getSearchTargets,
    this.appBar,
    this.inputLabelText,
    this.notFoundWidget,
    this.matches,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<T>>(
      stream: getSearchTargets,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        return _SearcherImpl<T>(
          searchTargets: snapshot.data,
          appBar: appBar,
          inputLabelText: inputLabelText,
          notFoundWidget: notFoundWidget,
          matches: matches,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

class _SearcherImpl<T> extends StatefulWidget {
  final List<T> searchTargets;
  final AppBar appBar;
  final String inputLabelText;
  final Widget notFoundWidget;
  final bool Function(T, String) matches;
  final Widget Function(T) itemBuilder;

  _SearcherImpl({
    this.searchTargets,
    this.appBar,
    this.inputLabelText,
    this.notFoundWidget,
    this.matches,
    this.itemBuilder,
  });

  @override
  _SearcherImplState<T> createState() => _SearcherImplState<T>();
}

class _SearcherImplState<T> extends State<_SearcherImpl<T>> {
  String input = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.searchTargets
        .where((element) => widget.matches(element, input))
        .toList();
    return Scaffold(
      appBar: widget.appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            children: [
              TextField(
                decoration: textFieldDecoration.copyWith(
                  prefixIcon: Icon(Icons.search),
                  labelText: widget.inputLabelText,
                ),
                onChanged: (val) {
                  setState(() {
                    input = val;
                  });
                },
              ),
              if (filtered.length == 0) widget.notFoundWidget,
              if (filtered.length > 0) ...[
                SizedBox(
                  height: 16.0,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return widget.itemBuilder(filtered[index]);
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
