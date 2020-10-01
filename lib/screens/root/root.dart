import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/root/edit_account.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
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
      body: Column(
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
        ],
      ),
    );
  }
}
