import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/uid.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(create: (context) => UidModel(), child: App()));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  static int beforeUserChanged;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UidModel>.value(
          initialData: UidModel(),
          value: FirebaseAuth.instance.userChanges().transform(
            StreamTransformer<User, UidModel>.fromHandlers(
              handleData: (value, sink) {
                final now = DateTime.now().millisecondsSinceEpoch;
                final before = beforeUserChanged ?? 0;
                if (now - before > 500) {
                  sink.add(UidModel(initialUid: value.uid));
                }
                beforeUserChanged = now;
              },
            ),
          ),
        ),
        ChangeNotifierProxyProvider<UidModel, AccountModel>(
          create: (context) => AccountModel(create: (uidModel) {
            if (uidModel?.uid == null) {
              return null;
            }
            return DatabaseService.getAccount(uidModel.uid);
          }),
          update: (context, uidModel, accountModel) {
            accountModel.update(uidModel);
            return accountModel;
          },
        ),
      ],
      child: Test(),
    );
  }
}

class Test extends StatelessWidget {
  void navigate(BuildContext context, bool hasUser) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) {
        if (hasUser) {
          return Root();
        } else {
          return Authenticate();
        }
      }),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accountModel = Provider.of<AccountModel>(context);
    accountModel.addListener(() {
      navigate(context, accountModel.value != null);
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primaryColor: Colors.deepOrange,
        colorScheme: ColorScheme.light(
          primary: Colors.deepOrange,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonColor: Colors.blue,
        cardTheme: CardTheme(
          elevation: 2.0,
        ),
      ),
      home: LoadingScaffold(),
    );
  }
}
