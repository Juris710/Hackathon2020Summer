import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/root.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     appBar: AppBar(
  //       title: Text(appName),
  //     ),
  //     body: Question(
  //       questionId: 'R1ZqwzPkRwXk8rEVLmJf',
  //     ),
  //   ),
  // ));
}

class App extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  StatelessElement createElement() {
    FirebaseAuth.instance.userChanges().listen((user) {
      Widget page;
      Offset tweenBegin;
      if (user == null) {
        page = Authenticate();
        tweenBegin = Offset(0.0, -1.0);
      } else {
        page = Root();
        tweenBegin = Offset(0.0, 1.0);
      }
      navigatorKey.currentState.pushReplacement(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var tween = Tween(
              begin: tweenBegin,
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.ease));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
        ),
      );
    });
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider.value(value: FirebaseAuth.instance.userChanges())
      ],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          buttonColor: Colors.pink,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(appName),
          ),
          body: Loading(),
        ),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
