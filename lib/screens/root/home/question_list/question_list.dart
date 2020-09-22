import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_list/question/question.dart';
import 'package:provider/provider.dart';

class QuestionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final target = Provider.of<QuestionTargetSource>(context);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(target.name),
    //   ),
    //   body: ListView.builder(
    //     itemCount: target.questions.length,
    //     itemBuilder: (context, index) {
    //       final question = target.questions[index];
    //       return GestureDetector(
    //         onTap: () {
    //           Navigator.of(context).push(
    //             MaterialPageRoute(
    //               builder: (context) => Question(question: question),
    //             ),
    //           );
    //         },
    //         child: Card(
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Center(
    //               child: Text(
    //                 question.title,
    //                 style: Theme.of(context).textTheme.headline5,
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
