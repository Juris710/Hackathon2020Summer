import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/question.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class EditQuestion extends StatefulWidget {
  final DocumentReference questionReference;

  EditQuestion({this.questionReference});

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuestionModel>(
      stream: DatabaseService.getQuestion(widget.questionReference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        final question = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('質問を編集'),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: question.title,
                      decoration: textFieldDecoration.copyWith(
                        labelText: 'タイトル*',
                      ),
                      validator: (val) => val.isEmpty ? '必須項目です' : null,
                      onChanged: (val) {
                        setState(() {
                          title = val;
                        });
                      },
                    ),
                    SizedBox(height: 8.0),
                    TextFormField(
                      initialValue: question.content,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: textFieldDecoration.copyWith(
                        labelText: '質問内容*',
                      ),
                      validator: (val) => val.isEmpty ? '必須項目です' : null,
                      onChanged: (val) {
                        setState(() {
                          content = val;
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    RaisedButton(
                      child: Text(
                        '決定',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        widget.questionReference.update({
                          'title': title ?? question.title,
                          'content': content ?? question.content,
                          'updatedAt': DateTime.now(),
                        });
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
