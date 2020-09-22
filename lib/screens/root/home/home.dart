import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
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

    final registeredCards = account.registered.map((item) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: [
              Center(child: Text(item.group.name)),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: item.questionTargets.length,
                  itemBuilder: (context, index) {
                    final target = item.questionTargets[index];
                    return ListTile(
                      title: Text(target.name),
                      trailing: Text('${target.questions.length}個の質問'),
                    );
                  })
            ],
          ),
        ),
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: registeredCards,
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
