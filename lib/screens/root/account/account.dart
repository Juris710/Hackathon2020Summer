import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/screens/root/account/register_university_group.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class Account extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountModel>(context);
    final myUniversity = Provider.of<UniversityModel>(context);
    final registered = Provider.of<List<RegisteredItemModel>>(context);
    if (account == null || myUniversity == null || registered == null) {
      return Loading();
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              account.name,
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 8.0),
            Text(myUniversity.name),
            SizedBox(height: 32.0),
            Card(
              child: Column(
                children: [
                  Container(
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            '質問グループ登録一覧',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterUniversityGroup(),
                                ),
                              );
                            },
                            icon: Icon(Icons.add, color: Colors.white),
                            label: Text(
                              '登録',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (registered.length == 0)
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child:
                            Text('質問グループが登録されていません。\n右上の「登録」ボタンを押すことで登録できます。'),
                      ),
                    ),
                  if (registered.length > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: registered.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<UniversityGroupModel>(
                          stream: DatabaseService.getUniversityGroup(
                              registered[index].group),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return LoadingSmall();
                            }
                            final group = snapshot.data;
                            final universityId =
                                RegExp(r'^universities/([^/]+)/.+$')
                                    .firstMatch(registered[index].group.path)
                                    .group(1);
                            return StreamBuilder<UniversityModel>(
                              stream: DatabaseService.getUniversity(
                                  DatabaseService.universities
                                      .doc(universityId)),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return LoadingSmall();
                                }
                                final university = snapshot.data;
                                var titleText = group.name;
                                if (myUniversity.reference !=
                                    university.reference) {
                                  titleText += '(${university.name})';
                                }
                                return ListTile(
                                  title: Text(titleText),
                                  trailing: GestureDetector(
                                    child: Icon(Icons.delete),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: Text('確認'),
                                            content: Text(
                                                '削除すると、登録内容が削除されます。再度追加した際は登録しなおす必要があります。\n削除してもよろしいですか？'),
                                            actions: [
                                              FlatButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: Text('キャンセル'),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  registered[index]
                                                      .reference
                                                      .delete();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('削除する'),
                                              ),
                                            ],
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
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
