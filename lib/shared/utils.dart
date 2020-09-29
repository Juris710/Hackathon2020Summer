import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:intl/intl.dart';

List<T> castToList<T>(dynamic l) {
  if (l == null) {
    return [];
  }
  return l.cast<T>() as List<T> ?? [];
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

void editUserConfigs<T>(Account account, String key, T value) {
  account.configs.doc(key).set({'value': value});
}
