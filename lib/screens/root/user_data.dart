//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/models/user/registered_item.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class UserData extends StatelessWidget {
  final AccountModel account;

  UserData({this.account});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UniversityModel>(
      stream: DatabaseService.getUniversity(account.university),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Loading();
        }
        final university = snapshot.data;
        return StreamBuilder<List<RegisteredItemModel>>(
          stream: DatabaseService.getRegistered(account.registered),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            }
            final registered = snapshot.data;
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    account.name,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    university.name,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  SizedBox(height: 32.0),
                  Card(
                    child: Column(
                      children: [
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: Center(
                            child: Padding(
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
                          ),
                        ),
                        if (registered.length == 0)
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                '質問グループが登録されていません。',
                              ),
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
                                    return CircularProgressIndicator();
                                  }
                                  final group = snapshot.data;
                                  final universityId = RegExp(
                                          r'^universities/([^/]+)/.+$')
                                      .firstMatch(registered[index].group.path)
                                      .group(1);
                                  return StreamBuilder<UniversityModel>(
                                    stream: DatabaseService.getUniversity(
                                        DatabaseService.universities
                                            .doc(universityId)),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      final university = snapshot.data;
                                      var titleText = group.name;
                                      titleText += '(${university.name})';
                                      return ListTile(
                                        title: Text(titleText),
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
            );
          },
        );
      },
    );
  }
}
