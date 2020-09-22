//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';

class UserData extends StatelessWidget {
  final Account account;

  UserData({this.account});

  @override
  Widget build(BuildContext context) {
    //final isMyAccount = account.id == FirebaseAuth.instance.currentUser.uid;
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            account.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          //Text(account.university.name),
          SizedBox(height: 32.0),
          // Card(
          //   elevation: 10,
          //   child: Column(
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Row(
          //           children: [
          //             SizedBox(width: 8.0),
          //             Text('授業一覧'),
          //             if (isMyAccount) ...[
          //               Expanded(child: Container()),
          //               FlatButton.icon(
          //                 onPressed: () {
          //                   Navigator.of(context).push(
          //                     MaterialPageRoute(
          //                       builder: (context) => EditLectureList(
          //                         account: account,
          //                       ),
          //                     ),
          //                   );
          //                 },
          //                 icon: Icon(Icons.edit),
          //                 label: Text('編集'),
          //               ),
          //             ]
          //           ],
          //         ),
          //       ),
          //       ListView.separated(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         separatorBuilder: (context, index) {
          //           return Divider(color: Colors.black);
          //         },
          //         itemCount: account.lectures.length,
          //         itemBuilder: (context, index) {
          //           final lecture = account.lectures[index];
          //           return ListTile(
          //             onTap: () {
          //               Navigator.of(context).push(
          //                 MaterialPageRoute(
          //                   builder: (context) => Lecture(
          //                     target: lecture,
          //                     account: account,
          //                   ),
          //                 ),
          //               );
          //             },
          //             title: Text(
          //               lecture.name,
          //               style: Theme.of(context).textTheme.button,
          //             ),
          //             leading: Icon(Icons.school),
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
