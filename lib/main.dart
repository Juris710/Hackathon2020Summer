import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // runApp(ChangeNotifierProvider(create: (context) => UidModel(), child: App()));
  //runApp(App());

  runApp(App());
}

// class Test extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     FirebaseAuth.instance.userChanges().listen((event) {
//       print('DEBUG_PRINT User Changes:$event');
//     });
//     FirebaseAuth.instance.authStateChanges().listen((event) {
//       print('DEBUG_PRINT AuthState Changes:$event');
//     });
//     FirebaseAuth.instance.idTokenChanges().listen((event) {
//       print('DEBUG_PRINT IdToken Changes:$event');
//     });
//
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(appName),
//         ),
//         body: Container(),
//       ),
//     );
//   }
// }

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider<User>(
          create: (context) => context.read<AuthService>().userChanges,
        ),
        ChangeNotifierProxyProvider<User, AccountModel>(
          create: (context) {
            return AccountModel(create: (user) {
              if (user == null) {
                return null;
              }
              return DatabaseService.getAccount(user.uid);
            });
          },
          update: (context, user, accountModel) {
            accountModel.update(user);
            return accountModel;
          },
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(appName),
          ),
          body: Container(),
        ),
      ),
    );
  }
}


// class App extends StatefulWidget {
//   @override
//   _AppState createState() => _AppState();
// }
//
// class _AppState extends State<App> {
//   static int beforeUserChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         StreamProvider<UidModel>.value(
//           initialData: UidModel(),
//           value: FirebaseAuth.instance.userChanges().transform(
//             StreamTransformer<User, UidModel>.fromHandlers(
//               handleData: (value, sink) {
//                 final now = DateTime.now().millisecondsSinceEpoch;
//                 final before = beforeUserChanged ?? 0;
//                 if (now - before > 500) {
//                   sink.add(UidModel(initialUid: value.uid));
//                 }
//                 beforeUserChanged = now;
//               },
//             ),
//           ),
//         ),
//         ChangeNotifierProxyProvider<UidModel, AccountModel>(
//           create: (context) => AccountModel(create: (uidModel) {
//             if (uidModel?.uid == null) {
//               return null;
//             }
//             return DatabaseService.getAccount(uidModel.uid);
//           }),
//           update: (context, uidModel, accountModel) {
//             accountModel.update(uidModel);
//             return accountModel;
//           },
//         ),
//       ],
//       child: Test(),
//     );
//   }
// }
//
// class Test extends StatelessWidget {
//   void navigate(BuildContext context, bool hasUser) {
//     Navigator.of(context).pushAndRemoveUntil(
//       MaterialPageRoute(builder: (context) {
//         if (hasUser) {
//           return Root();
//         } else {
//           return Authenticate();
//         }
//       }),
//       (route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final accountModel = Provider.of<AccountModel>(context);
//     accountModel.addListener(() {
//       navigate(context, accountModel.value != null);
//     });
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: appName,
//       theme: ThemeData(
//         primaryColor: Colors.deepOrange,
//         colorScheme: ColorScheme.light(
//           primary: Colors.deepOrange,
//         ),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         buttonColor: Colors.blue,
//         cardTheme: CardTheme(
//           elevation: 2.0,
//         ),
//       ),
//       home: LoadingScaffold(),
//     );
//   }
// }
