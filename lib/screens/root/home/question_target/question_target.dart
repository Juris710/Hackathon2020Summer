import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/question.dart' as Model;
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
import 'package:hackathon_2020_summer/screens/root/home/question_target/new_question.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/question/question.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class QuestionTarget extends StatelessWidget {
  final DocumentReference targetReference;

  QuestionTarget({this.targetReference});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Model.QuestionTarget>(
      stream: DatabaseService.getQuestionTarget(targetReference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        final Model.QuestionTarget target = snapshot.data;
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
          body: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: target.questions.orderBy('updatedAt').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final QuerySnapshot query = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: query.docs.length,
                    itemBuilder: (context, index) {
                      final questionDoc = query.docs[index];
                      final question =
                          Model.Question.fromFirestore(questionDoc);
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Question(
                                questionReference: questionDoc.reference,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                question.title,
                                style: Theme.of(context).textTheme.headline5,
                              ),
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
        );
      },
    );
  }
}
