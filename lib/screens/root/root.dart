import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/screens/root/edit_account.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  Root({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Account>(
      stream: context.watch<AuthService>().account,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        final account = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(appName),
            actions: [
              FlatButton.icon(
                onPressed: () {
                  context.read<AuthService>().signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                      return Authenticate();
                    }),
                    (route) => false,
                  );
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
      },
    );
  }
}
