import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  final String name;
  final PreferredSizeWidget appBar;
  final String submitButtonText;

  const EditAccount({Key key, this.name, this.appBar, this.submitButtonText})
      : super(key: key);

  @override
  _EditAccountState createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  final _formKey = GlobalKey<FormState>();
  String name;

  @override
  void initState() {
    super.initState();
    setState(() {
      name = widget.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('アカウント情報登録'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: textFieldDecoration.copyWith(
                    labelText: 'ユーザー名',
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
                ElevatedButton(
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    final user = FirebaseAuth.instance.currentUser;
                    if (name != null) {
                      await user.updateProfile(displayName: name);
                    }
                    await context.read<DatabaseService>().updateUserData(
                          user.uid,
                          name: name ?? user.displayName,
                        );
                  },
                  child: Text(widget.submitButtonText ?? ''),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
