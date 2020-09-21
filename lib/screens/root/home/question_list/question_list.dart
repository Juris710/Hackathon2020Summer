import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/question/question.dart' as Model;
import 'package:hackathon_2020_summer/models/university/lecture.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_list/question/question.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class QuestionList extends StatelessWidget {
  final Lecture lecture;

  QuestionList({this.lecture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.name),
      ),
      body: FutureBuilder(
        future: Future.wait(lecture.questions.map((ref) =>
            ref.get().then((doc) => Model.Question.fromFirestore(doc)))),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          }
          final questions = castToList<Model.Question>(snapshot.data);
          return ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Question(question: question),
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
              });
        },
      ),
    );
  }
}
