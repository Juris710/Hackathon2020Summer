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
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: account.lectures.length,
            itemBuilder: (context, index) {
              return Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LazyText(
                      future: account.lectures[index].get(),
                      getString: (snapshot) => snapshot.data.data()['name'],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
