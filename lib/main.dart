import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

void setUpFirebaseData() async {
  final content =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  final r = FirebaseFirestore.instance
      .doc('/universities/8D21SXiMRejcz5EMSrJz/groups/HsXpGovygzCnpxO0qOxA');
  final r1 = await r.collection('children').add({'name': '工学域'});
  final r2 = await r1.collection('children').add({'name': '電気電子系学類'});
  final r7 = await r2.collection('children').add({'name': '情報工学課程'});
  await r2.collection('children').add({'name': '電気電子システム工学課程'});
  await r2.collection('children').add({'name': '電子物理工学課程'});
  final r3 = await r1.collection('children').add({'name': '機械系学類'});
  await r3.collection('children').add({'name': '航空宇宙工学課程'});
  await r3.collection('children').add({'name': '海洋システム工学課程'});
  await r3.collection('children').add({'name': '機械工学課程'});
  final r4 = await r1.collection('children').add({'name': '物質化系学類'});
  await r4.collection('children').add({'name': '応用化学課程'});
  await r4.collection('children').add({'name': '化学工学課程'});
  await r4.collection('children').add({'name': 'マテリアル工学課程'});

  final r5 = await r2.collection('question_targets').add({
    'name': '微積分学I',
  });
  r5.collection('questions').add({
    'title': '質問1',
    'content': content,
    'createdBy': 'sGsQgC6uyDV1GnjCOYIgTL4KWPN2',
    'updatedAt': DateTime(2020, 9, 22, 1, 0),
  });
  r5.collection('questions').add({
    'title': '質問2',
    'content': content,
    'createdBy': '5rnEG09L8mWKi0BILH09bSHPo3V2',
    'updatedAt': DateTime(2020, 9, 22, 2, 0),
  });
  final r6 = await r7.collection('question_targets').add({
    'name': '情報工学演習I',
  });
  r6.collection('questions').add({
    'title': '質問3',
    'content': content,
    'createdBy': 'sGsQgC6uyDV1GnjCOYIgTL4KWPN2',
    'updatedAt': DateTime(2020, 9, 22, 3, 0),
  });
  r6.collection('questions').add({
    'title': '質問4',
    'content': content,
    'createdBy': '5rnEG09L8mWKi0BILH09bSHPo3V2',
    'updatedAt': DateTime(2020, 9, 22, 4, 0),
  });
}

void main() async {
  await initializeDateFormatting('ja_JP');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
  // setUpFirebaseData();
  // runApp(MaterialApp(
  //   home: Scaffold(
  //     appBar: AppBar(
  //       title: Text(appName),
  //     ),
  //     body: Container(),
  //   ),
  // ));
}

class App extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  StatelessElement createElement() {
    FirebaseAuth.instance.userChanges().listen((user) {
      navigatorKey.currentState.pushReplacement(
        MaterialPageRoute(builder: (context) {
          if (user == null) {
            return Authenticate();
          } else {
            return Root();
          }
        }),
      );
    });
    return super.createElement();
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
            primarySwatch: Colors.blue,
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
