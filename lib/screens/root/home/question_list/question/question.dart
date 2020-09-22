import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/answer.dart';
import 'package:hackathon_2020_summer/models/question/question.dart' as Model;
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
  final Model.Question question;

  Question({this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('質問'),
      ),
      body: FutureBuilder(
        future: question.answers.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          }
          final QuerySnapshot answersSnapshot = snapshot.data;
          final answers =
              answersSnapshot.docs.map((e) => Answer.fromFirestore(e)).toList();
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
                          uid: question.createdBy,
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: answers.length,
                          itemBuilder: (context, index) {
                            return AnswerCard(answer: answers[index]);
                          },
                        ),
                        if (answers.length == 0) Text('まだ回答がありません。')
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
