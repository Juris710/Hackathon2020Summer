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
              home: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: getTransition(Theme.of(context).platform),
                child: (user != null) ? Root() : Authenticate(),
              ),
            ),
          );
        },
      ),
    );
  }
}

AnimatedSwitcherTransitionBuilder getTransition(TargetPlatform platform) {
  /*
  参考
  https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/about.dart
  https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/page_transitions_theme.dart
  */
  const Map<TargetPlatform, PageTransitionsBuilder> defaultBuilders =
      <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
  };
  return (child, animation) {
    return defaultBuilders[platform].buildTransitions<void>(
      null,
      null,
      animation,
      null,
      child,
    );
  };
}
