import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/never_show_again_dialog.dart';
import 'package:hackathon_2020_summer/shared/widgets/text_input_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUniversityGroup extends StatelessWidget {
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
      matches: (item, input) => item.name.contains(input),
      itemBuilder: (item) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return _RegisterUniversityGroupDescendant(
                  groupCollection: item.groups,
                );
              }),
            );
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
  final CollectionReference groupCollection;

  _RegisterUniversityGroupDescendant({
    this.groupCollection,
  });

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final registered = Provider.of<List<RegisteredItemModel>>(context);
    if (account == null || registered == null) {
      return LoadingScaffold();
    }
    return Searcher<UniversityGroupModel>(
      getSearchTargets: groupCollection.snapshots().map((event) => event.docs
          .map((doc) => UniversityGroupModel.fromFirestore(doc))
          .toList()),
      matches: (item, input) => item.name.contains(input),
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
              groupCollection.add({'name': name});
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
      itemBuilder: (item) {
        final hasRegistered =
            registered.any((element) => element.group == item.reference);
        return ListTile(
          title: Text(item.name),
          leading: GestureDetector(
            onTap: () async {
              if (hasRegistered) {
                return;
              }
              final prefs = await SharedPreferences.getInstance();
              final showsConfirm = prefs.getBool(
                      'show_confirm_on_registering_university_group') ??
                  true;
              if (!showsConfirm) {
                account.registered.add({
                  'group': item.reference,
                });
                return;
              }
              showDialog(
                context: context,
                builder: (_) {
                  return NeverShowAgainDialog(
                    title: Text('確認'),
                    content: Text(
                      '${item.name}を追加しますか？\n追加した場合、アカウント画面で外すことができます。',
                    ),
                    actions: (neverShowAgain) => [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (!neverShowAgain) {
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text('注意'),
                              content: Text(
                                  '次回以降、チェックマークをタップすると自動で追加します。\nよろしいですか？'),
                              actions: [
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('次回以降も表示する'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    prefs.setBool(
                                        'show_confirm_on_registering_university_group',
                                        false);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text('キャンセル'),
                      ),
                      FlatButton(
                        onPressed: () {
                          account.registered.add({
                            'group': item.reference,
                          });
                          if (neverShowAgain) {
                            prefs.setBool(
                                'show_confirm_on_registering_university_group',
                                false);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Text('追加する'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(
              Icons.check_circle,
              color: hasRegistered ? Colors.lightGreen : Colors.grey,
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return _RegisterUniversityGroupDescendant(
                      groupCollection: item.children,
                    );
                  },
                ),
              );
            },
            child: Icon(Icons.open_in_new),
          ),
        );
      },
    );
  }
}
