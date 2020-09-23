import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/group.dart' as Model;
import 'package:hackathon_2020_summer/models/university/question_target.dart'
    as Model;
import 'package:hackathon_2020_summer/models/user/account.dart' as Model;
import 'package:hackathon_2020_summer/models/user/registered_item.dart'
    as Model;
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class UniversityGroup extends StatelessWidget {
  final DocumentReference groupReference;
  final DocumentReference registeredItemReference;

  UniversityGroup({this.groupReference, this.registeredItemReference});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Model.RegisteredItem>(
      stream: DatabaseService.getRegisteredItem(registeredItemReference),
      builder: (context, registeredItemSnapshot) {
        if (!registeredItemSnapshot.hasData) {
          return LoadingScaffold();
        }
        final registeredItem = registeredItemSnapshot.data;
        return StreamBuilder<Model.UniversityGroup>(
          stream: DatabaseService.getUniversityGroup(groupReference),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingScaffold();
            }
            final group = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text(group?.name),
              ),
              body: StreamBuilder<QuerySnapshot>(
                stream: group.questionTargets.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Loading();
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data.docs[index];
                      final target = Model.QuestionTarget.fromFirestore(doc);
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
                              'question_targets': registeredItem.questionTargets
                            });
                          },
                        ),
                      );
                    },
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
  static Stream<List<Model.QuestionTarget>> getQuestionTargets(
      CollectionReference ref) {
    return ref.snapshots().transform(
      StreamTransformer<QuerySnapshot, List<Model.QuestionTarget>>.fromHandlers(
        handleData: (value, sink) {
          sink.add(value.docs
              .map((doc) => Model.QuestionTarget.fromFirestore(doc))
              .toList());
        },
      ),
    );
  }
*/
