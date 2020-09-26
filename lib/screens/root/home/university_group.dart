import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/root/home/new_question_target.dart';
import 'package:hackathon_2020_summer/screens/searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class UniversityGroup extends StatelessWidget {
  final DocumentReference groupReference;
  final DocumentReference registeredItemReference;

  UniversityGroup({this.groupReference, this.registeredItemReference});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RegisteredItemModel>(
      stream: DatabaseService.getRegisteredItem(registeredItemReference),
      builder: (context, registeredItemSnapshot) {
        if (!registeredItemSnapshot.hasData) {
          return LoadingScaffold();
        }
        final registeredItem = registeredItemSnapshot.data;
        return StreamBuilder<UniversityGroupModel>(
          stream: DatabaseService.getUniversityGroup(groupReference),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingScaffold();
            }
            final group = snapshot.data;
            return Searcher<QuestionTargetModel>(
              getSearchTargets: group.questionTargets.snapshots().map((event) =>
                  event.docs
                      .map((doc) => QuestionTargetModel.fromFirestore(doc))
                      .toList()),
              appBar: AppBar(
                title: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "質問リスト登録",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      children: <TextSpan>[
                        if (group?.name != null)
                          TextSpan(
                            text: '\n${group?.name}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                      ]),
                ),
                actions: [
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewQuestionTarget(
                            universityGroupReference: groupReference,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text('追加', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              notFoundWidgets: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0件です',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ],
                  ),
                )
              ],
              searchTargetsEmptyWidgets: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '質問リストが存在しません。',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text('右上の「追加」ボタンを押すことで追加できます。'),
                      ],
                    ),
                  ),
                ),
              ],
              inputLabelText: '検索',
              matches: (item, input) => item.name.contains(input),
              itemBuilder: (item) {
                final contains =
                    registeredItem.questionTargets.contains(item.reference);
                return CheckboxListTile(
                  title: Text(item.name),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: contains,
                  onChanged: (value) {
                    if (contains) {
                      registeredItem.questionTargets.remove(item.reference);
                    } else {
                      registeredItem.questionTargets.add(item.reference);
                    }
                    registeredItemReference.update(
                        {'question_targets': registeredItem.questionTargets});
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
