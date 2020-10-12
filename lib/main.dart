import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/authenticate/new_account/new_account.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/authenticate_status.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
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
        Provider<DatabaseService>(
          create: (_) => DatabaseService(FirebaseFirestore.instance),
        ),
        Provider<AuthService>(
          create: (context) => AuthService(
            FirebaseAuth.instance,
            context.read<DatabaseService>(),
          ),
          dispose: (_, auth) => auth.dispose(),
        ),
        StreamProvider<Account>(
          create: (context) => context.read<AuthService>().account,
        ),
      ],
      child: Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<AuthService>().authStatus.listen((event) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigatorKey.currentState.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) {
            switch (event) {
              case AuthStatus.NO_USER:
                return Authenticate();
              case AuthStatus.NEW_USER:
                return NewAccount();
              case AuthStatus.USER:
                return Root();
              default:
                return LoadingScaffold();
            }
          }),
          (route) => false,
        );
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      home: LoadingScaffold(),
      navigatorKey: _navigatorKey,
    );
  }
}
