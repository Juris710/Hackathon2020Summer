import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';

class NewUniversity extends StatefulWidget {
  @override
  _NewUniversityState createState() => _NewUniversityState();
}

class _NewUniversityState extends State<NewUniversity> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String url = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('大学を追加する'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                    labelText: '大学名*',
                  ),
                  validator: (val) => val.isEmpty ? '必須項目です' : null,
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                SizedBox(height: 8.0),
                TextFormField(
                  decoration: textFieldDecoration.copyWith(
                    labelText: '大学のURL',
                  ),
                  onChanged: (val) {
                    setState(() {
                      url = val;
                    });
                  },
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                  child: Text(
                    '作成',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    DatabaseService.universities.add({
                      'name': name,
                      'url': url,
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
