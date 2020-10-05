import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
      ],
      //TODO：Userの変更がEmailで登録した際Accountに反映されない
      child: Wrapper(),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    print('DEBUG_PRINT: USER ${user != null}');
    return MultiProvider(
      providers: [
        StreamProvider<Account>(
          //key: ValueKey(user?.uid ?? ''),
          create: (context) =>
              context.read<DatabaseService>().getAccount(user?.uid),
        ),
      ],
      child: Wrapper2(),
    );
  }
}

class Wrapper2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User>();
    print('DEBUG_PRINT: USER2 ${user != null}');
    return MaterialApp(
      title: appName,
      home: (user != null) ? Root() : Authenticate(),
    );
  }
}
