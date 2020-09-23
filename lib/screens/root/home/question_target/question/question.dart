import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart';
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
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';

class AnswerCard extends StatelessWidget {
  final Answer answer;

  AnswerCard({this.answer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(answer.createdBy),
            Text(answer.content),
            Text(getDateString(answer.updatedAt.toDate())),
          ],
        ),
      ),
    );
  }
}

//TODO：データが不正だった場合のフェイルセーフ実装
class Question extends StatelessWidget {
  final DocumentReference questionReference;

  Question({this.questionReference});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('質問'),
      ),
      body: StreamBuilder<Model.Question>(
        stream: DatabaseService.getQuestion(questionReference),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          final Model.Question question = snapshot.data;
          return Container(
            margin: EdgeInsets.all(8.0),
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
                        UserCard(
                          userReference: question.createdBy,
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(getDateString(question.updateAt.toDate())),
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
                        StreamBuilder<List<Answer>>(
                          stream: DatabaseService.getAnswers(question.answers),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            final List<Answer> answers = snapshot.data;
                            if (answers.length == 0) return Text('まだ回答がありません。');
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
          );
        },
      ),
    );
  }
}
