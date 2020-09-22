import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_list/question_list.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Account>(context);
    if (account == null) return Loading();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          StreamBuilder(
            stream: account.registered.snapshots().transform(StreamTransformer<
                QuerySnapshot,
                List<RegisteredItem>>.fromHandlers(handleData: (value, sink) {
              return sink.add(value.docs
                  .map((doc) => RegisteredItem.fromFirestore(doc))
                  .toList());
            })),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) => RegisteredCardHome(
                  registeredItem: snapshot.data[index],
                ),
              );
            },
          ),
        ],
        // children: [
        // ListView.builder(
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemCount: account.lectures.length,
        //   itemBuilder: (context, index) {
        //     final lecture = account.lectures[index];
        //     return GestureDetector(
        //       onTap: () {
        //         Navigator.of(context).push(
        //           MaterialPageRoute(
        //             builder: (context) => QuestionList(lecture: lecture),
        //           ),
        //         );
        //       },
        //       child: Card(
        //         child: Center(
        //           child: Padding(
        //             padding: const EdgeInsets.all(16.0),
        //             child: Row(
        //               children: [
        //                 Expanded(child: Center(child: Text(lecture.name))),
        //                 Text('${lecture.questions.length}個の質問')
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        // ],
      ),
    );
  }
}

class RegisteredCardHome extends StatelessWidget {
  final RegisteredItem registeredItem;

  RegisteredCardHome({this.registeredItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream:
                      DatabaseService.getUniversityGroup(registeredItem.group),
                  builder: (context, snapshot) {
                    final str = snapshot.hasData ? snapshot.data.name : '';
                    return Text(
                      str,
                      style: Theme.of(context).textTheme.headline6,
                    );
                  },
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: registeredItem.questionTargets.length,
              itemBuilder: (context, index) {
                final targetDocument = registeredItem.questionTargets[index];
                return StreamBuilder(
                  stream: DatabaseService.getQuestionTarget(targetDocument),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Loading();
                    }
                    final Model.QuestionTarget target = snapshot.data;
                    return ListTile(
                      onTap: () {
                        navigate(context, QuestionList(), values: [
                          Provider.of<Account>(context, listen: false),
                        ]);
                      },
                      title: Text(target.name),
                      trailing: StreamBuilder(
                        stream: target.questions.snapshots(),
                        builder: (context, snapshot) {
                          return Text(
                            (snapshot.hasData)
                                ? '${snapshot.data.docs.length}個の質問'
                                : '',
                          );
                        },
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
  }
}
