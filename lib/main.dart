import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/authenticate/new_account/new_account.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'authenticate_status.dart';
import 'models/user/account.dart';

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
          create: (_) => AuthService(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
          dispose: (_, auth) => auth.dispose(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(FirebaseFirestore.instance),
        ),
        StreamProvider<Account>(
          create: (context) => context.read<AuthService>().account,
        ),
      ],
      child: Wrapper(),
    );
  }
}

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

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  AuthStatus authStatus;

  void switchPage(BuildContext context) {
    final account = context.watch<Account>();
    final currentAuthStatus = getAuthStatus(account);
    if (authStatus == currentAuthStatus) {
      return;
    }
    setState(() {
      authStatus = currentAuthStatus;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          if (account == null) {
            return LoadingScaffold();
          }
          if (account.isNoUser) {
            return Authenticate();
          } else if (!account.dataExists) {
            return NewAccount();
          }
          return Root();
        }),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    switchPage(context);
    return MaterialApp(
      title: appName,
      home: LoadingScaffold(),
      navigatorKey: _navigatorKey,
    );
  }
}
