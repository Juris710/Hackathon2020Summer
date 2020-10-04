import 'package:cloud_firestore/cloud_firestore.dart';
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
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(FirebaseFirestore.instance),
        ),
        StreamProvider<User>(
          create: (context) => context.read<AuthService>().userChanges,
        ),
      ],
      //TODO：Userの変更がAccountに反映されない
      child: Consumer<User>(
        builder: (context, user, child) {
          return MultiProvider(
            providers: [
              StreamProvider<Account>(
                create: (context) =>
                    context.read<DatabaseService>().getAccount(user?.uid),
              ),
            ],
            child: MaterialApp(
              title: appName,
              home: (user != null) ? Root() : Authenticate(),
            ),
          );
        },
      ),
    );
  }
}
