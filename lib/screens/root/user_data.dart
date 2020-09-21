import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';
import 'package:hackathon_2020_summer/screens/root/account/lecture/lecture.dart';

class UserData extends StatelessWidget {
  final UserAccount account;

  UserData({this.account});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            account.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(account.university.name),
          SizedBox(height: 32.0),
          Text('授業一覧'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: account.lectures.length,
            itemBuilder: (context, index) {
              final lecture = account.lectures[index];
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Lecture(lecture: lecture),
                    ),
                  );
                },
                title: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        lecture.name,
                        style: Theme.of(context).textTheme.button,
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
