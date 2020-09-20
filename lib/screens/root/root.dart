import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';
import 'package:hackathon_2020_summer/screens/root/account/account.dart';
import 'package:hackathon_2020_summer/screens/root/home/home.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bottomNavigationBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        title: Text('ホーム'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        title: Text('アカウント'),
      ),
    ];

    final widgets = [
      Home(),
      Account(),
    ];
    final uid = Provider.of<User>(context)?.uid;
    if (uid == null) return Container();

    return StreamProvider.value(
      value: FirebaseFirestore.instance
          .doc('users/$uid')
          .snapshots()
          .map((event) => UserAccount.fromFireStore(event)),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(appName),
        ),
        body: Center(
          child: PageTransitionSwitcher(
            child: widgets[_currentIndex],
            transitionBuilder: (child, animation, secondaryAnimation) {
              return FadeThroughTransition(
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
              );
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          items: bottomNavigationBarItems,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: textTheme.caption.fontSize,
          unselectedFontSize: textTheme.caption.fontSize,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: colorScheme.onPrimary,
          unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
          backgroundColor: colorScheme.primary,
        ),
      ),
    );
  }
}
