import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_list/question_list.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<UserAccount>(context);
    if (account == null) return Container();
    return Container(
      child: Column(
        children: [
          Text('HOME'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: account.lectures.length,
            itemBuilder: (context, index) {
              final lecture = account.lectures[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QuestionList(lecture: lecture),
                    ),
                  );
                },
                child: Card(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(child: Center(child: Text(lecture.name))),
                          Text('${lecture.questions.length}個の質問')
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
