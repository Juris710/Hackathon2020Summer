import 'package:firebase_auth/firebase_auth.dart';
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: new Text('ホーム'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.person),
        title: new Text('アカウント'),
      ),
    ];
  }

  void pageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  Widget buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(),
        Account(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      drawerEdgeDragWidth: 0,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(appName),
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
          icon: Icon(Icons.menu),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                appName,
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text('このアプリについて'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationVersion: appVersion,
                );
              },
            ),
            ListTile(
              title: Text('ログアウト'),
              onTap: () => FirebaseAuth.instance.signOut(),
            )
          ],
        ),
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        items: buildBottomNavBarItems(),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: textTheme.caption.fontSize,
        unselectedFontSize: textTheme.caption.fontSize,
        onTap: (index) {
          bottomTapped(index);
        },
        selectedItemColor: colorScheme.onPrimary,
        unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
        backgroundColor: colorScheme.primary,
      ),
    );
    // final uid = Provider.of<User>(context)?.uid;
    // if (uid == null) return Container();
    // return StreamProvider.value(
    //   value: DatabaseService.getAccount(uid),
    //   catchError: (context, e) {
    //     if (e is TypeError) {
    //       print(e.stackTrace);
    //     } else {
    //       print(e);
    //     }
    //   },
    //   child: Scaffold(
    //     key: _scaffoldKey,
    //     drawerEdgeDragWidth: 0,
    //     appBar: AppBar(
    //       automaticallyImplyLeading: false,
    //       title: Text(appName),
    //       leading: IconButton(
    //         onPressed: () => _scaffoldKey.currentState.openDrawer(),
    //         icon: Icon(Icons.menu),
    //       ),
    //     ),
    //     drawer: Drawer(
    //       child: ListView(
    //         children: [
    //           DrawerHeader(
    //             child: Text(appName),
    //             decoration: BoxDecoration(
    //               color: Theme.of(context).primaryColor,
    //             ),
    //           ),
    //           ListTile(
    //             title: Text('このアプリについて'),
    //             onTap: () {
    //               Navigator.pop(context);
    //               showAboutDialog(
    //                 context: context,
    //                 applicationVersion: appVersion,
    //               );
    //             },
    //           ),
    //           ListTile(
    //             title: Text('ログアウト'),
    //             onTap: () => FirebaseAuth.instance.signOut(),
    //           )
    //         ],
    //       ),
    //     ),
    //     body: buildPageView(),
    //     bottomNavigationBar: BottomNavigationBar(
    //       showUnselectedLabels: true,
    //       items: buildBottomNavBarItems(),
    //       currentIndex: _currentIndex,
    //       type: BottomNavigationBarType.fixed,
    //       selectedFontSize: textTheme.caption.fontSize,
    //       unselectedFontSize: textTheme.caption.fontSize,
    //       onTap: (index) {
    //         bottomTapped(index);
    //       },
    //       selectedItemColor: colorScheme.onPrimary,
    //       unselectedItemColor: colorScheme.onPrimary.withOpacity(0.38),
    //       backgroundColor: colorScheme.primary,
    //     ),
    //   ),
    // );
  }
}
