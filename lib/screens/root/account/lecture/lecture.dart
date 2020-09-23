// import 'package:flutter/material.dart';
// import 'package:hackathon_2020_summer/models/user/account.dart';
//
// class Lecture extends StatelessWidget {
//   final UserAccount account;
//   final Lecture lecture;
//
//   Lecture({this.lecture, this.account});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('授業の詳細'),
//         actions: [],
//       ),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               lecture.name,
//               style: Theme.of(context).textTheme.headline4,
//             ),
//             SizedBox(height: 16.0),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: lecture.allocation.length,
//               itemBuilder: (context, index) {
//                 return Center(
//                     child: Text(
//                   lecture.allocation[index],
//                   style: Theme.of(context).textTheme.bodyText2,
//                 ));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
