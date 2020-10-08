import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/services/authenticate.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _obscureText = true;

  //state
  String email = '';
  String password = '';
  String passwordConfirm = '';

  //error state
  String error;
  String errorEmail;
  String errorPassword;
  String errorPasswordConfirm;

  void handleAuthError(Object e) {
    String newErrorEmail;
    String newErrorPassword;
    String newError;

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          newErrorEmail = '入力内容がメールアドレスではありません';
          break;
        case 'email-already-in-use':
          newErrorEmail = '既にユーザーが存在します';
          break;
        case 'weak-password':
          newErrorPassword = 'パスワードは6文字以上である必要があります';
          break;
        default:
          newError = '登録に失敗しました\n${e.code}\n${e.message}';
      }
    } else {
      newError = '登録に失敗しました\n${e.runtimeType}\n$e';
    }
    print(e);
    setState(() {
      errorEmail = newErrorEmail;
      errorPassword = newErrorPassword;
      error = newError;
    });
  }

  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = context.read<AuthService>().loading.listen((value) {
      setState(() {
        loading = value;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text('新しいアカウントの登録'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Row(
              children: [
                Text(
                  'ログイン',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
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
                        labelText: 'メールアドレス',
                        errorText: errorEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (val) => val.isEmpty ? '必須項目です' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                          errorEmail = null;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: textFieldDecoration.copyWith(
                        labelText: 'パスワード',
                        errorText: errorPassword,
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() => _obscureText = !_obscureText);
                          },
                          child: Icon(
                            (_obscureText)
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (val) => val.isEmpty ? '必須項目です' : null,
                      obscureText: _obscureText,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                          errorPassword = null;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: textFieldDecoration.copyWith(
                        labelText: 'パスワードの再入力',
                        errorText: errorPasswordConfirm,
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (val) {
                        if (val.isEmpty) {
                          return '必須項目です';
                        }
                        if (val != password) {
                          return 'パスワードが異なっています';
                        }
                        return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          passwordConfirm = val;
                          errorPasswordConfirm = null;
                        });
                      },
                    ),
                    RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        try {
                          await context.read<AuthService>().signUp(
                                email: email,
                                password: password,
                              );
                        } catch (e) {
                          handleAuthError(e);
                        }
                      },
                      child: Text(
                        '登録',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error ?? '',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (loading) Loading()
        ],
      ),
    );
  }
}
