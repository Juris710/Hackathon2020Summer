import 'package:hackathon_2020_summer/models/user/account.dart';

enum AuthStatus { NO_USER, NEW_USER, USER }

AuthStatus getAuthStatus(Account account) {
  if (account == null) {
    return null;
  }
  if (account.isNoUser) {
    return AuthStatus.NO_USER;
  }
  if (!account.dataExists) {
    return AuthStatus.NEW_USER;
  }
  return AuthStatus.USER;
}
