import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/edit_account.dart';
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
  void navigateToEditAccountScreen(BuildContext context, Account account) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return EditAccount(
            appBar: AppBar(
              title: Text('ユーザー情報の設定'),
            ),
            name: account.name,
            submitButtonText: '設定',
          );
        },
      ),
    );
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
            if (!account.isNewUser)
              ListTile(
                title: Text('アカウントの編集'),
                leading: Icon(
                  Icons.edit,
                ),
                onTap: () => navigateToEditAccountScreen(context, account),
              ),
            ListTile(
              title: Text('ログアウト'),
              leading: Icon(
                Icons.logout,
                //color: Colors.white,
              ),
              onTap: () => context.read<AuthService>().signOut(),
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (!account.isNewUser) Text(account.name),
            if (account.isNewUser) ...[
              Text('No Data'),
              ElevatedButton(
                onPressed: () => navigateToEditAccountScreen(context, account),
                child: Text('設定する'),
              )
            ],
          ],
        ),
      ),
    );
  }
}
