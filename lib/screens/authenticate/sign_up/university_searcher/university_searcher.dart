import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/screens/searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';

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
            onPressed: () {},
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Text(
              '新しく大学を登録',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      inputLabelText: '大学名を入力してください',
      notFoundWidget: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '大学が見つかりませんでした',
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
