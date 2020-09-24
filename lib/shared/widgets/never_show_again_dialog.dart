import 'package:flutter/material.dart';

class NeverShowAgainDialog extends StatefulWidget {
  final Widget title;
  final Widget content;
  final List<Widget> Function(bool) actions;

  NeverShowAgainDialog({this.title, this.content, this.actions});

  @override
  _NeverShowAgainDialogState createState() => _NeverShowAgainDialogState();
}

class _NeverShowAgainDialogState extends State<NeverShowAgainDialog> {
  bool neverShowAgain = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.content,
          Row(
            children: [
              Checkbox(
                value: neverShowAgain,
                onChanged: (val) {
                  setState(() {
                    neverShowAgain = val;
                  });
                },
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      neverShowAgain = !neverShowAgain;
                    });
                  },
                  child: Text('次回から表示しない')),
            ],
          ),
        ],
      ),
      actions: widget.actions(neverShowAgain),
    );
  }
}
