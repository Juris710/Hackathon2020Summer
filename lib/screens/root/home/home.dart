import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/root/home/question_target/question_target.dart';
import 'package:hackathon_2020_summer/screens/root/home/university_group.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final registered = Provider.of<List<RegisteredItemModel>>(context);
    if (account == null || registered == null) return Loading();
    if (registered.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '質問グループが登録されていません。',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            '「アカウント」画面から登録することができます。',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: registered.length,
              itemBuilder: (context, index) => RegisteredCardHome(
                registeredItem: registered[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisteredCardHome extends StatelessWidget {
  final RegisteredItemModel registeredItem;

  RegisteredCardHome({this.registeredItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: StreamBuilder<UniversityGroupModel>(
                        stream: DatabaseService.getUniversityGroup(
                          registeredItem.group,
                        ),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.hasData ? snapshot.data.name : '',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.clip,
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UniversityGroup(
                              groupReference: registeredItem.group,
                              registeredItemReference: registeredItem.reference,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        '編集',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (registeredItem.questionTargets.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('質問リストが登録されていません。'),
                    Text('右上の「編集」ボタンを押すと登録できます。'),
                  ],
                ),
              ),
            if (registeredItem.questionTargets.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: registeredItem.questionTargets.length,
                itemBuilder: (context, index) {
                  final reference = registeredItem.questionTargets[index];
                  return StreamBuilder<QuestionTargetModel>(
                    stream: DatabaseService.getQuestionTarget(reference),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      final QuestionTargetModel target = snapshot.data;
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionTarget(targetReference: reference),
                            ),
                          );
                        },
                        title: Text(target.name),
                        trailing: StreamBuilder<QuerySnapshot>(
                          stream: target.questions.snapshots(),
                          builder: (context, snapshot) {
                            return Text(
                              (snapshot.hasData)
                                  ? '${snapshot.data.docs.length}個の質問'
                                  : '',
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
