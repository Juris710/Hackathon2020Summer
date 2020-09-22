import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart'
    as Model;
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/models/user/registered_item.dart'
    as Model;
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Model.Account>(context);
    final university = Provider.of<Model.University>(context);
    final registered = Provider.of<List<Model.RegisteredItem>>(context);
    if (account == null || university == null || registered == null) {
      return Loading();
    }

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            account.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(university.name),
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
