import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_list/question_list.dart';
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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: account.registered.length,
            itemBuilder: (context, index) {
              return RegisteredCardHome(
                registeredItem: account.registered[index],
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
                child: Text(
                  registeredItem.group.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: registeredItem.questionTargets.length,
              itemBuilder: (context, index) {
                final target = registeredItem.questionTargets[index];
                return ListTile(
                  onTap: () {
                    navigate(
                      context,
                      QuestionList(
                        target: target,
                      ),
                      [Provider.of<Account>(context, listen: false)],
                    );
                  },
                  title: Text(target.name),
                  trailing: Text('${target.questions.length}個の質問'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
