import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/user_account.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<UserAccount>(context);
    if (account == null) return Container();
    return Container(
      child: Column(
        children: [
          Text('HOME'),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: account.lectures.length,
            itemBuilder: (context, index) {
              return Card(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(account.lectures[index].name),
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
