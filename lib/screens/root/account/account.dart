import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';
import 'package:hackathon_2020_summer/shared/widgets/lazy_text.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<UserAccount>(context);
    if (account == null) return Container();
    return Container(
      child: Column(
        children: [
          Text(
            account.name,
            style: Theme.of(context).textTheme.headline4,
          ),
          LazyText(
            future: account.university.get(),
            getString: (snapshot) => snapshot.data.data()['name'],
          ),
          SizedBox(height: 32.0),
          Text('授業一覧'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: account.lectures.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(account.lectures[index].name),
              );
            },
          ),
        ],
      ),
    );
  }
}
