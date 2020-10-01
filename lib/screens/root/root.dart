import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/screens/authenticate/authenticate.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountModel>().value;
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
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) {
                    return Authenticate();
                  },
                ),
                (_) => false,
              );
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
