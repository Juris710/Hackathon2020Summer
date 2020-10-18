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
  }
}
