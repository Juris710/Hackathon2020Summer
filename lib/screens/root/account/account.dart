import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/screens/root/user_data.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<Model.Account>(context);
    if (account == null) return Container();
    return UserData(account: account);
  }
}
