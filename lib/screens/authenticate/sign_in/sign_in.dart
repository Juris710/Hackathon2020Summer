import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/screens/authenticate/sign_up/sign_up.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _obscureText = true;

  //text field state
  String email;
  String password;

  String error;
  String errorEmail;
  String errorPassword;

  void handleAuthError(Object e) {
    String newErrorEmail;
    String newErrorPassword;
    String newError;

    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-email':
          newErrorEmail = '入力内容がメールアドレスではありません';
          break;
        case 'user-not-found':
          newErrorEmail = '存在しないユーザーです';
          break;
        case 'wrong-password':
          newErrorPassword = 'パスワードが誤っています';
          break;
        default:
          newError = 'ログインに失敗しました\n${e.code}\n${e.message}';
      }
    } else {
      newError = 'ログインに失敗しました\n${e.runtimeType}\n$e';
    }
    print(e);
    setState(() {
      loading = false;
      errorEmail = newErrorEmail;
      errorPassword = newErrorPassword;
      error = newError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('ログイン'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: textFieldDecoration.copyWith(
                        labelText: 'メールアドレス',
                        errorText: errorEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'メールアドレスを入力してください' : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                          errorEmail = null;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
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
                      validator: (val) => val.isEmpty ? 'パスワードを入力してください' : null,
                      obscureText: _obscureText,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                          errorPassword = null;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        setState(() {
                          loading = true;
                        });
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            )
                            .catchError(handleAuthError);
                      },
                      child: Text(
                        'ログイン',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: Text(
                          '新しいアカウントを登録する',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      error ?? '',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    )
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
