import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/screens/edit_account.dart';

class NewAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return EditAccount(
      appBar: AppBar(
        title: Text('アカウント情報登録'),
      ),
      name: user.displayName,
      submitButtonText: '登録',
    );
/*
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
                  initialValue: user.displayName,
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
                    if (name != null) {
                      await user.updateProfile(displayName: name);
                    }
                    await context.read<DatabaseService>().updateUserData(
                          user.uid,
                          name: name ?? user.displayName,
                        );
                  },
                  child: Text(
                    '登録',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
*/
  }
}
