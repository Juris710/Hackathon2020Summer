import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart';
import 'package:hackathon_2020_summer/models/question/question.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/edit_question.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/text_input_dialog.dart';
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';
import 'package:provider/provider.dart';

class AnswerCard extends StatelessWidget {
  final AnswerModel answer;

  AnswerCard({this.answer});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    return Card(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (answer.createdBy != null)
                      UserCard(
                        userReference: answer.createdBy,
                      ),
                    if (account.reference == answer.createdBy)
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return TextInputDialog(
                                    title: '回答の編集',
                                    defaultText: answer.content,
                                  );
                                },
                              );
                              if (result == null) {
                                return;
                              }
                              answer.reference.update({
                                'content': result,
                                'updatedAt': DateTime.now(),
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('確認'),
                                    content: Text(
                                        'この回答を削除してもよろしいですか？\n削除した場合、元に戻すことはできません。'),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('キャンセル'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          answer.reference.delete();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('削除する'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
                Text(answer.content),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (answer.updatedAt != null)
                      Text(getDateString(answer.updatedAt.toDate())),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
            child: Divider(color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FlatButton(
              onPressed: () {},
              child: Text(
                '返信する',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Question extends StatefulWidget {
  final DocumentReference questionReference;

  Question({this.questionReference});

  @override
  _QuestionState createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  final _answerContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    return StreamBuilder<QuestionModel>(
      stream: DatabaseService.getQuestion(widget.questionReference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        final question = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text('質問'),
            actions: [
              if (account.reference == question.createdBy)
                FlatButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return EditQuestion(
                            questionReference: question.reference,
                          );
                        },
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  label: Text(
                    '編集',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ],
          ),
          body: Container(
            margin: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                question.title,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (question.createdBy != null)
                                    UserCard(
                                      userReference: question.createdBy,
                                    ),
                                  if (question.updatedAt != null)
                                    Text(getDateString(
                                        question.updatedAt.toDate())),
                                ],
                              ),
                              SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                question.content,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(
                                height: 32.0,
                              ),
                              StreamBuilder<List<AnswerModel>>(
                                stream: DatabaseService.getAnswers(
                                    question.answers),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }
                                  final List<AnswerModel> answers =
                                      snapshot.data;
                                  if (answers.length == 0) {
                                    return Text('まだ回答がありません。');
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: answers.length,
                                    itemBuilder: (context, index) {
                                      return AnswerCard(answer: answers[index]);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _answerContentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration:
                            textFieldDecoration.copyWith(hintText: '回答を入力する'),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_answerContentController.value.text.isEmpty) {
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        widget.questionReference.collection('answers').add({
                          'content': _answerContentController.value.text,
                          'createdBy': account.reference,
                          'updatedAt': DateTime.now(),
                        });
                        _answerContentController.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _answerContentController.dispose();
    super.dispose();
  }
}
