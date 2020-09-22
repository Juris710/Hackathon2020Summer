import 'package:intl/intl.dart';

List<T> castToList<T>(dynamic l) {
  return l.cast<T>() as List<T>;
}

String getDateString(DateTime date) {
  return DateFormat('yyyy年MM月dd日 HH:mm').format(date);
}

// void navigate(BuildContext context, Widget page, List<dynamic> values) {
//   Navigator.of(context).push(
//     MaterialPageRoute(builder: (context) {
//       return MultiProvider(
//         providers: [
//           ...values.map((e) => Provider.value(value: e)).toList(),
//         ],
//         child: page,
//       );
//     }),
//   );
// }
