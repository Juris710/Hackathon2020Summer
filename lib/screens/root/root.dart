import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/edit_account.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<Account>();
    if (account == null) {
      return LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          FlatButton.icon(
            onPressed: () {
              context.read<AuthService>().signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('ログアウト'),
          ),
          if (account.dataExists)
            FlatButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return EditAccount(account: account);
                    },
                  ),
                );
              },
              icon: Icon(Icons.edit),
              label: Text('編集'),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (account.dataExists) Text(account.name),
            if (!account.dataExists) ...[
              Text('No Data'),
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditAccount(account: account);
                      },
                    ),
                  );
                },
                child: Text('設定する'),
              )
            ],
            FirestoreAnimatedList(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              query: FirebaseFirestore.instance.collection('test'),
              itemBuilder: (
                BuildContext context,
                DocumentSnapshot snapshot,
                Animation<double> animation,
                int index,
              ) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      key: ValueKey(snapshot.reference.path),
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text(snapshot.data()['name'])),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
