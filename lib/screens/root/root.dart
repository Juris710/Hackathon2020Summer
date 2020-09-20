import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/screens/root/account/account.dart';
import 'package:hackathon_2020_summer/screens/root/home/home.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';

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

    var bottomNavigationBarItems = <BottomNavigationBarItem>[
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
    // bottomNavigationBarItems = bottomNavigationBarItems.sublist(
    //     0, bottomNavigationBarItems.length - 2);
    // _currentIndex =
    //     _currentIndex.clamp(0, bottomNavigationBarItems.length - 1).toInt();

    return Scaffold(
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
    );
  }
}
