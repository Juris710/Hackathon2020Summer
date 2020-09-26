import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/utils.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:hackathon_2020_summer/shared/widgets/never_show_again_dialog.dart';
import 'package:hackathon_2020_summer/shared/widgets/text_input_dialog.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../new_university.dart';

class RegisterUniversityGroup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Searcher<UniversityModel>(
      getSearchTargets: DatabaseService.universities.snapshots().map((event) =>
          event.docs.map((doc) => UniversityModel.fromFirestore(doc)).toList()),
      appBar: AppBar(
        title: Text('大学の選択'),
        actions: [
          FlatButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewUniversity(),
                ),
              );
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
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: SelectableText(item.name),
                  content: (item.url?.isNotEmpty ?? false)
                      ? GestureDetector(
                          onTap: () async {
                            final url = item.url;
                            if (await canLaunch(url)) {
                              await launch(item.url);
                            }
                          },
                          child: Text(
                            item.url,
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : Container(),
                  actions: [
                    FlatButton(
                      textColor: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('閉じる'),
                    )
                  ],
                );
              },
            );
          },
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return _RegisterUniversityGroupDescendant(
                  groupCollection: item.groups,
                  parentName: item.name,
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
  final String parentName;

  _RegisterUniversityGroupDescendant({
    this.groupCollection,
    this.parentName,
  });

  void register(
      BuildContext context, AccountModel account, UniversityGroupModel group) {
    account.registered.add({
      'group': group.reference,
    });
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('質問グループ「${group.name}」を登録しました。')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final registered = Provider.of<List<RegisteredItemModel>>(context);
    if (account == null || registered == null) {
      return LoadingScaffold();
    }
    return StreamBuilder<Map<String, dynamic>>(
      stream: DatabaseService.getConfigs(account.configs),
      builder: (context, snapshot) {
        final configs = snapshot.data;
        return Searcher<UniversityGroupModel>(
          getSearchTargets: groupCollection.snapshots().map((event) => event
              .docs
              .map((doc) => UniversityGroupModel.fromFirestore(doc))
              .toList()),
          matches: (item, input) => item.name.contains(input),
          appBar: AppBar(
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "質問グループ登録",
                  style: TextStyle(fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(
                      text: '\n「$parentName」内',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ]),
            ),
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
                  '追加',
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
          searchTargetsEmptyWidgets: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '「$parentName」には質問グループがありません。',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    '右上の「追加」ボタンを押すことで「$parentName」に質問グループを追加することができます。',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
            )
          ],
          itemBuilder: (item) {
            final hasRegistered =
                registered.any((element) => element.group == item.reference);
            return Builder(
              builder: (context) {
                return ListTile(
                  title: Text(item.name),
                  leading: GestureDetector(
                    onTap: () async {
                      if (hasRegistered) {
                        return;
                      }
                      final neverShowAgain = configs[UserSettings
                              .KEY_NEVER_SHOW_AGAIN_CONFIRM_REGISTER_UNIVERSITY_GROUP] ??
                          false;
                      if (neverShowAgain) {
                        register(context, account, item);
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (_) {
                          return NeverShowAgainDialog(
                            title: Text('確認'),
                            content: Text(
                              '${item.name}を登録しますか？\n登録した場合、アカウント画面で外すことができます。',
                            ),
                            actions: (neverShowAgain) => [
                              FlatButton(
                                textColor: Colors.blue,
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
                                          '次回以降、チェックマークをタップすると自動で登録します。\nよろしいですか？'),
                                      actions: [
                                        FlatButton(
                                          textColor: Colors.blue,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('次回以降も表示する'),
                                        ),
                                        FlatButton(
                                          textColor: Colors.blue,
                                          onPressed: () {
                                            editUserConfigs(
                                              account,
                                              UserSettings
                                                  .KEY_NEVER_SHOW_AGAIN_CONFIRM_REGISTER_UNIVERSITY_GROUP,
                                              true,
                                            );
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
                                textColor: Colors.blue,
                                onPressed: () {
                                  register(context, account, item);
                                  if (neverShowAgain) {
                                    editUserConfigs(
                                      account,
                                      UserSettings
                                          .KEY_NEVER_SHOW_AGAIN_CONFIRM_REGISTER_UNIVERSITY_GROUP,
                                      true,
                                    );
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
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return _RegisterUniversityGroupDescendant(
                            groupCollection: item.children,
                            parentName: item.name,
                          );
                        },
                      ),
                    );
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
