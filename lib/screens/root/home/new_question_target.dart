import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university_group.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class NewQuestionTarget extends StatefulWidget {
  final DocumentReference universityGroupReference;

  NewQuestionTarget({this.universityGroupReference});

  @override
  _NewQuestionTargetState createState() => _NewQuestionTargetState();
}

class _NewQuestionTargetState extends State<NewQuestionTarget> {
  final _formKey = GlobalKey<FormState>();
  String name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UniversityGroupModel>(
        stream: widget.universityGroupReference
            .snapshots()
            .map((doc) => UniversityGroupModel.fromFirestore(doc)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoadingScaffold();
          }
          final universityGroup = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              title: Text('${universityGroup.name}に追加する'),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: textFieldDecoration.copyWith(
                          labelText: '名前*',
                          prefixIcon: Icon(Icons.school),
                        ),
                        validator: (val) => val.isEmpty ? '必須項目です' : null,
                        onChanged: (val) {
                          setState(() {
                            name = val;
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
                          widget.universityGroupReference
                              .collection('question_targets')
                              .add({'name': name});
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
