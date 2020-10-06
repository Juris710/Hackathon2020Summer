import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

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
          create: (_) =>
              AuthService(FirebaseAuth.instance, FirebaseFirestore.instance),
          dispose: (_, auth) => auth.dispose(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
      ],
      //TODO：Userの変更がEmailで登録した際Accountに反映されない
      child: StreamProvider<Account>.value(
        value: context.read<AuthService>().account,
        child: MaterialApp(
          title: appName,
          home: Consumer<Account>(
            //TODO：ここでNavigator遷移を担当するように
            builder: (context, account, _) {
              if (account == null) {
                return LoadingScaffold();
              }
              if (account.isNoUser) {
                return Authenticate();
              }
              return Root();
            },
          ),
        ),
      ),
    );
  }
}

// class Wrapper extends StatefulWidget {
//   @override
//   _WrapperState createState() => _WrapperState();
// }
//
// class _WrapperState extends State<Wrapper> {
//   final _navigatorKey = GlobalKey<NavigatorState>();
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<AuthService>().account.listen((account) {
//       _navigatorKey.currentState.pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) {
//           if (account.isNoUser) {
//             return Authenticate();
//           } else {
//             return Root();
//           }
//         }),
//         (route) => false,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: appName,
//       home: LoadingScaffold(),
//       navigatorKey: _navigatorKey,
//     );
//   }
// }
