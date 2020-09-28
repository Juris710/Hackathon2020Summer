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
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';
import 'package:hackathon_2020_summer/shared/writing_status.dart';
import 'package:provider/provider.dart';

import 'answer.dart';

class QuestionDetail extends StatelessWidget {
  final QuestionModel question;

  QuestionDetail({this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectableText(
          question.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (question.createdBy != null)
              UserCard(
                userReference: question.createdBy,
              ),
            if (question.updatedAt != null)
              Text(getDateString(question.updatedAt.toDate())),
          ],
        ),
        SizedBox(
          height: 16.0,
        ),
        SelectableText(
          question.content,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 32.0,
        ),
      ],
    );
  }
}

class QuestionScreen extends StatefulWidget {
  final DocumentReference questionReference;

  QuestionScreen({this.questionReference});

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen>
    with SingleTickerProviderStateMixin {
  final _answerContentController = TextEditingController();
  WritingStatus writingStatus = WritingStatus.NotWriting;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _answerContentController.dispose();
    super.dispose();
  }

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
          body: NotificationListener<WritingStatusNotification>(
            onNotification: (notification) {
              setState(() {
                writingStatus = notification.writingStatus;
              });
              return true;
            },
            child: Provider.value(
              value: writingStatus,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  QuestionDetail(question: question),
                                  StreamBuilder<List<AnswerModel>>(
                                    stream: DatabaseService.getAnswers(
                                        question.answers),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return LoadingSmall();
                                      }
                                      final List<AnswerModel> answers =
                                          snapshot.data;
                                      if (answers.length == 0) {
                                        return Text('まだ回答がありません。');
                                      }
                                      return ListView.separated(
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 32.0),
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: answers.length,
                                        itemBuilder: (context, index) {
                                          return AnswerCard(
                                            answer: answers[index],
                                          );
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
                    AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                      vsync: this,
                      child: Container(
                        constraints: (writingStatus == WritingStatus.Writing)
                            ? BoxConstraints(maxHeight: 0.0)
                            : BoxConstraints(maxHeight: double.infinity),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _answerContentController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: textFieldDecoration.copyWith(
                                    hintText: '回答を入力する'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (_answerContentController
                                    .value.text.isEmpty) {
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                widget.questionReference
                                    .collection('answers')
                                    .add({
                                  'content':
                                      _answerContentController.value.text,
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
                      ),
                    ),
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
