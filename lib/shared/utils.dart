import 'package:intl/intl.dart';

List<T> castToList<T>(dynamic l) {
  return l.cast<T>() as List<T>;
}

String getDateString(DateTime date) {
  return DateFormat('yyyy年MM月dd日 HH:mm').format(date);
}
