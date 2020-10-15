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

class _RootState extends State<Root> {
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
          if (!account.isNewUser)
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
            if (!account.isNewUser) Text(account.name),
            if (account.isNewUser) ...[
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
          ],
        ),
      ),
    );
  }
}
