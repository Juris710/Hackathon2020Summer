import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/dependent_multi_provider.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    FirebaseAuth.instance.userChanges().listen((user) async {
      navigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          if (user == null) {
            return Authenticate();
          }
          return Root();
        }),
        (_) => false,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<AccountModel>.value(
          value: FirebaseAuth.instance.userChanges().transform(
            StreamTransformer<User, AccountModel>.fromHandlers(
              handleData: (value, sink) async {
                if (value == null) return;
                final account = await DatabaseService.getUserDocument(value.uid)
                    .get()
                    .then((doc) => AccountModel.fromFirestore(doc));
                sink.add(account);
              },
            ),
          ),
        ),
      ],
      child: DependentMultiProvider<AccountModel>(
        providersBuilder: (value) {
          return [
            StreamProvider<UniversityModel>.value(
              value: (value == null)
                  ? null
                  : DatabaseService.getUniversity(value.university),
            ),
            StreamProvider<List<RegisteredItemModel>>.value(
              value: (value == null)
                  ? null
                  : DatabaseService.getRegistered(value.registered),
            ),
          ];
        },
        child: MaterialApp(
          title: appName,
          theme: ThemeData(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.light(
              primary: Colors
                  .blue, // -------> This will be your FlatButton's text color
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            buttonColor: Colors.pink,
            cardTheme: CardTheme(
              elevation: 2.0,
            ),
          ),
          home: LoadingScaffold(),
          navigatorKey: navigatorKey,
        ),
      ),
    );
  }
}
