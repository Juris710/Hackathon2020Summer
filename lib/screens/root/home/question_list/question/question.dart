import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/question.dart' as Model;
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/user_card.dart';

class Question extends StatelessWidget {
  final String questionId;

  Question({this.questionId});

  Widget _questionCard(BuildContext context, Model.Question question) {
    return Padding(
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
            height: 16.0,
          ),
          Text(
            question.content,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionDoc = FirebaseFirestore.instance.doc('questions/$questionId');
    return FutureBuilder(
      future: questionDoc.get().then((value) => value.data()),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading();
        }
        final question = Model.Question.fromMap(snapshot.data);
        print(question.answers);
        return Container(
          margin: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _questionCard(context, question),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text(question.answers[index])),
                      ),
                    );
                  },
                  itemCount: question.answers.length,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
