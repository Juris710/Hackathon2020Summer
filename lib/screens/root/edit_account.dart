import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  final Account account;

  EditAccount({Key key, this.account}) : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _formKey = GlobalKey<FormState>();

  String name = '';

  @override
  void initState() {
    super.initState();
    if (!widget.account.isNewUser) {
      setState(() {
        name = widget.account.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<Account>();
    if (account == null) {
      return LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('ユーザー情報の設定'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: textFieldDecoration.copyWith(
                        labelText: '名前*',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (val) => val.isEmpty ? '必須項目です' : null,
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        if (widget.account.isNewUser) {
                          widget.account.reference.set({'name': name});
                        } else {
                          widget.account.reference.update({'name': name});
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        '設定する',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
