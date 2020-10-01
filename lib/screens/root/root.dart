import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
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
    if (!account.dataExists) {
      // Navigator.of(context).push(
      //
      // );
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
          )
        ],
      ),
      body: Text(account.name),
    );
  }
}
