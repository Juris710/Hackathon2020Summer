import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/screens/new_university.dart';
import 'package:hackathon_2020_summer/screens/searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:url_launcher/url_launcher.dart';

class UniversitySearcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Searcher<UniversityModel>(
      getSearchTargets: DatabaseService.universities.snapshots().map((event) =>
          event.docs.map((doc) => UniversityModel.fromFirestore(doc)).toList()),
      appBar: AppBar(
        title: Text('大学検索'),
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
              '大学を追加',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      inputLabelText: '大学名を入力してください',
      notFoundWidgets: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '大学が見つかりませんでした。',
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
