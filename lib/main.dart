import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/services/database.dart';
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
        title: appName,
        home: InitialLoading(),
      ),
    );
  }
}

class InitialLoading extends StatefulWidget {
  @override
  _InitialLoadingState createState() => _InitialLoadingState();
}

class _InitialLoadingState extends State<InitialLoading> {
  StreamSubscription initialLoadingSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initialLoadingSubscription = context.read<AuthService>().userChanges.listen(
      (user) {
        initialLoadingSubscription.cancel();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) {
              if (user == null) {
                return Authenticate();
              }
              return Root();
            },
          ),
          (_) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoadingScaffold();
  }
}
