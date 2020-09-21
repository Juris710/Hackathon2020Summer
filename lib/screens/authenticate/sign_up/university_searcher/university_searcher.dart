import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class UniversitySearcher extends StatefulWidget {
  @override
  _UniversitySearcherState createState() => _UniversitySearcherState();
}

class _UniversitySearcherState extends State<UniversitySearcher> {
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: '大学名を入力してください',
              ),
              onChanged: (val) {
                setState(() {
                  inputText = val;
                });
              },
            ),
            FutureBuilder(
              future: DatabaseService.universities.get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Loading();
                }
                final List<QueryDocumentSnapshot> universitiesSnapshot =
                    snapshot.data.docs
                        .where((doc) =>
                            doc.data()['name'].contains(inputText) as bool)
                        .toList();
                if (universitiesSnapshot.length == 0) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '大学が見つかりませんでした',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: universitiesSnapshot.length,
                  itemBuilder: (context, index) {
                    final universitySnapshot = universitiesSnapshot[index];
                    final university =
                        University.fromFirestore(universitySnapshot);
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(university);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: Text(university.name)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
