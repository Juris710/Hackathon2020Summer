import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/models/user/registered_item.dart'
    as Model;
import 'package:hackathon_2020_summer/screens/root/home/question_target/question_target.dart';
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
    final account = Provider.of<Model.Account>(context);
    final registered = Provider.of<List<Model.RegisteredItem>>(context);
    if (account == null || registered == null) return Loading();

    return Container(
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
    );
  }
}

class RegisteredCardHome extends StatelessWidget {
  final Model.RegisteredItem registeredItem;

  RegisteredCardHome({this.registeredItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream:
                      DatabaseService.getUniversityGroup(registeredItem.group),
                  builder: (context, snapshot) {
                    final str = snapshot.hasData ? snapshot.data.name : '';
                    return Text(
                      str,
                      style: Theme.of(context).textTheme.headline6,
                    );
                  },
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: registeredItem.questionTargets.length,
              itemBuilder: (context, index) {
                final reference = registeredItem.questionTargets[index];
                return StreamBuilder(
                  stream: DatabaseService.getQuestionTarget(reference),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final Model.QuestionTarget target = snapshot.data;
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
                      trailing: StreamBuilder(
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
