import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/text_input_dialog.dart';

class RegisterUniversityGroup extends StatelessWidget {
  final AccountModel account;

  RegisterUniversityGroup({this.account});

  @override
  Widget build(BuildContext context) {
    return Searcher<UniversityModel>(
      getSearchTargets: DatabaseService.universities.snapshots().map((event) =>
          event.docs.map((doc) => UniversityModel.fromFirestore(doc)).toList()),
      appBar: AppBar(
        title: Text('登録の管理'),
        actions: [
          FlatButton.icon(
            onPressed: () async {
              final String name = await showDialog(
                context: context,
                builder: (context) {
                  return TextInputDialog(
                    title: '追加',
                  );
                },
              );
              if (name?.isEmpty ?? true) {
                return;
              }
              DatabaseService.universities.add({'name': name});
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              '追加する',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      inputLabelText: '検索',
      notFoundWidget: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '0件です',
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      matches: (item, input) => item.name.contains(input),
      itemBuilder: (item) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(item);
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: Text(item.name)),
            ),
          ),
        );
      },
    );
  }
}

class _RegisterUniversityGroupDescendant extends StatelessWidget {
  final CollectionReference registeredCollection;
  final CollectionReference groupCollection;

  _RegisterUniversityGroupDescendant({
    this.groupCollection,
    this.registeredCollection,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RegisteredItemModel>>(
      stream: DatabaseService.getRegistered(registeredCollection),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoadingScaffold();
        }
        return Searcher<UniversityGroupModel>(
          getSearchTargets: groupCollection.snapshots().map((event) => event
              .docs
              .map((doc) => UniversityGroupModel.fromFirestore(doc))
              .toList()),
          matches: (item, input) => item.name.contains(input),
          appBar: AppBar(
            title: Text('登録の管理'),
          ),
        );
      },
    );
  }
}
