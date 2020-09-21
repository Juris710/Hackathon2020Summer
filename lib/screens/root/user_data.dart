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
          Card(
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('授業一覧'),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.black);
                  },
                  itemCount: account.lectures.length,
                  itemBuilder: (context, index) {
                    final lecture = account.lectures[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Lecture(
                              lecture: lecture,
                              account: account,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        lecture.name,
                        style: Theme.of(context).textTheme.button,
                      ),
                      leading: Icon(Icons.school),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
