import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  final String title;
  final String defaultText;

  TextInputDialog({this.title, this.defaultText = ''});

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.defaultText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: controller,
        autofocus: true,
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
            Navigator.of(context).pop(controller.text);
          },
          child: Text('決定'),
        ),
      ],
    );
  }
}
