// import 'package:flutter/material.dart';
// import 'package:hackathon_2020_summer/models/user/account.dart';
// import 'package:hackathon_2020_summer/models/university/lecture.dart' as Model;
// import 'package:hackathon_2020_summer/screens/root/account/lecture_searcher.dart';
// import 'package:hackathon_2020_summer/services/database.dart';
//
// import 'lecture/lecture.dart';
//
// class EditLectureList extends StatefulWidget {
//   final UserAccount account;
//
//   EditLectureList({this.account});
//
//   @override
//   _EditLectureListState createState() => _EditLectureListState();
// }
//
// class _EditLectureListState extends State<EditLectureList> {
//   List<Model.Lecture> lectureList;
//
//   void reloadLectureList() {
//     setState(() {
//       lectureList = widget.account.lectures;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     reloadLectureList();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final account = widget.account;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('授業一覧編集'),
//         actions: [
//           FlatButton.icon(
//             onPressed: () async {
//               final lecture = await Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => LectureSearcher(
//                     account: account,
//                     excludesExisting: true,
//                   ),
//                 ),
//               );
//               if (lecture == null) {
//                 return;
//               }
//               account.lectures.add(lecture);
//               //DatabaseService.updateAccount(account);
//               reloadLectureList();
//             },
//             icon: Icon(
//               Icons.add,
//               color: Colors.white,
//             ),
//             label: Text(
//               '授業追加',
//               style: TextStyle(color: Colors.white),
//             ),
//           )
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.all(8.0),
//         child: ListView.separated(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           separatorBuilder: (context, index) {
//             return Divider();
//           },
//           itemCount: lectureList.length,
//           itemBuilder: (context, index) {
//             final lecture = lectureList[index];
//             return ListTile(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => Lecture(
//                       lecture: lecture,
//                       account: account,
//                     ),
//                   ),
//                 );
//               },
//               title: Text(
//                 lecture.name,
//                 style: Theme.of(context).textTheme.button,
//               ),
//               leading: Icon(Icons.school),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
