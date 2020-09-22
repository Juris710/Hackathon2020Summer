// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hackathon_2020_summer/models/university/lecture.dart' as Model;
// import 'package:hackathon_2020_summer/models/user/account.dart';
// import 'package:hackathon_2020_summer/services/database.dart';
// import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
//
// class LectureSearcher extends StatefulWidget {
//   final UserAccount account;
//   final bool excludesExisting;
//
//   LectureSearcher({this.account, this.excludesExisting = false});
//
//   @override
//   _LectureSearcherState createState() => _LectureSearcherState();
// }
//
// class _LectureSearcherState extends State<LectureSearcher> {
//   String inputText = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final account = widget.account;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('授業検索'),
//         actions: [
//           FlatButton.icon(
//             onPressed: () {},
//             icon: Icon(
//               Icons.add,
//               color: Colors.white,
//             ),
//             label: Text(
//               '新しく授業を登録',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),
//                 labelText: '授業名を入力してください',
//               ),
//               onChanged: (val) {
//                 setState(() {
//                   inputText = val;
//                 });
//               },
//             ),
//             FutureBuilder(
//               future: DatabaseService.universities
//                   .doc(account.university.id)
//                   .collection('lectures')
//                   .get(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState != ConnectionState.done) {
//                   return Loading();
//                 }
//                 List<QueryDocumentSnapshot> lecturesSnapshot = snapshot
//                     .data.docs
//                     .where(
//                         (doc) => doc.data()['name'].contains(inputText) as bool)
//                     .toList();
//                 if (widget.excludesExisting) {
//                   lecturesSnapshot = lecturesSnapshot.where((doc) {
//                     return account.lectures
//                         .where((lecture) => lecture.id == doc.id)
//                         .isEmpty;
//                   }).toList();
//                 }
//                 if (lecturesSnapshot.length == 0) {
//                   return Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           '授業が見つかりませんでした',
//                           style: Theme.of(context).textTheme.headline6,
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: lecturesSnapshot.length,
//                   itemBuilder: (context, index) {
//                     final lecture = Model.Lecture.fromFirestore(
//                       lecturesSnapshot[index],
//                     );
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).pop(lecture);
//                       },
//                       child: Card(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Center(child: Text(lecture.name)),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
