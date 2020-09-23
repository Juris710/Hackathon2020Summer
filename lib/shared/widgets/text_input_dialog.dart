import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;

  TextInputDialog({this.title});

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  String text = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        onChanged: (val) {
          setState(() {
            text = val;
          });
        },
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('キャンセル'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(text);
          },
          child: Text('決定'),
        ),
      ],
    );
  }
}
