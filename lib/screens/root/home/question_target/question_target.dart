import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/question.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/new_question.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/question/question.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class QuestionTargetScreen extends StatelessWidget {
  final DocumentReference targetReference;

  QuestionTargetScreen({this.targetReference});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    return StreamBuilder<QuestionTargetModel>(
      stream: DatabaseService.getQuestionTarget(targetReference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        final QuestionTargetModel target = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(target.name),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewQuestion(
                        questionTargetReference: targetReference,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  '追加',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                StreamBuilder<List<QuestionModel>>(
                  stream: target.questions.orderBy('updatedAt').snapshots().map(
                      (event) => event.docs
                          .map((doc) => QuestionModel.fromFirestore(doc))
                          .toList()),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return LoadingSmall();
                    }
                    final questions = snapshot.data;
                    if (questions.length == 0) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'まだ質問がありません',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuestionScreen(
                                  questionReference: question.reference,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            question.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          ),
                                        ),
                                      ),
                                      if (account.reference ==
                                          question.createdBy)
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: Text('確認'),
                                                  content: Text(
                                                      'この質問を削除しますか？\n削除した後、元に戻すことはできません。'),
                                                  actions: [
                                                    FlatButton(
                                                      textColor: Colors.blue,
                                                      child: Text('キャンセル'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    FlatButton(
                                                      textColor: Colors.blue,
                                                      child: Text('削除する'),
                                                      onPressed: () {
                                                        question.reference
                                                            .delete();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
