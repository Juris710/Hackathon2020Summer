import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/question_target.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/root/home/new_question_target.dart';
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
            return Scaffold(
              appBar: AppBar(
                title: Text(group?.name),
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
              body: StreamBuilder<QuerySnapshot>(
                stream: group.questionTargets.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Loading();
                  }
                  if (snapshot.data.docs.isEmpty) {
                    return Center(
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
                    );
                  }
                  return SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data.docs[index];
                        final target = QuestionTargetModel.fromFirestore(doc);
                        final contains = registeredItem.questionTargets
                            .contains(target.reference);
                        return ListTile(
                          title: Text(target.name),
                          leading: Checkbox(
                            value: contains,
                            onChanged: (value) {
                              if (contains) {
                                registeredItem.questionTargets
                                    .remove(target.reference);
                              } else {
                                registeredItem.questionTargets
                                    .add(target.reference);
                              }
                              registeredItemReference.update({
                                'question_targets':
                                    registeredItem.questionTargets
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

/*
  static Stream<List<QuestionTarget>> getQuestionTargets(
      CollectionReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<QuerySnapshot, List<QuestionTarget>>.fromHandlers(
        handleData: (value, sink) {
          sink.add(value.docs
              .map((doc) => QuestionTarget.fromFirestore(doc))
              .toList());
        },
      ),
    );
  }
*/
