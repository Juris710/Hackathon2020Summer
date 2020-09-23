import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart' as Model;
import 'package:hackathon_2020_summer/models/question/question.dart' as Model;
import 'package:hackathon_2020_summer/models/university/group.dart' as Model;
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
import 'package:hackathon_2020_summer/models/university/university.dart'
    as Model;
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/models/user/registered_item.dart'
    as Model;
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class NewQuestion extends StatefulWidget {
  final DocumentReference questionTargetReference;

  NewQuestion({this.questionTargetReference});

  @override
  _NewQuestionState createState() => _NewQuestionState();
}

class _NewQuestionState extends State<NewQuestion> {
  final _formKey = GlobalKey<FormState>();
  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Model.Account>(context);
    return StreamBuilder<Model.QuestionTarget>(
        stream:
            DatabaseService.getQuestionTarget(widget.questionTargetReference),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingScaffold();
          }
          final universityGroup = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('${universityGroup.name}に質問を追加'),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
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
                          '作成',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          widget.questionTargetReference
                              .collection('questions')
                              .add({
                            'title': title,
                            'content': content,
                            'createdBy': account.reference,
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
        });
  }
}
