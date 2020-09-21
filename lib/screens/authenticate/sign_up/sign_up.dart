import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/models/university/university.dart';
import 'package:hackathon_2020_summer/screens/authenticate/sign_up/university_searcher/university_searcher.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:hackathon_2020_summer/shared/widgets/loading.dart';

class SignUp extends StatefulWidget {
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
  String userName = '';
  University university;

  //error state
  String error;
  String errorEmail;
  String errorPassword;
  String errorPasswordConfirm;
  String errorUniversity;

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
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'メールアドレス*',
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
                      decoration: InputDecoration(
                        labelText: 'パスワード*',
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
                      decoration: InputDecoration(
                        labelText: 'パスワードの再入力*',
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
                    SizedBox(
                      height: 16.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ユーザー名*',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (val) => val.isEmpty ? '必須項目です' : null,
                      onChanged: (val) {
                        setState(() {
                          userName = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    OutlineButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UniversitySearcher(),
                          ),
                        );
                        if (result == null) {
                          return;
                        }
                        setState(() {
                          university = result;
                          errorUniversity = null;
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.school),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            (university == null) ? '大学を選択*' : university.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      errorUniversity ?? '',
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        bool isValid = true;
                        if (!_formKey.currentState.validate()) {
                          isValid = false;
                        }
                        if (university == null) {
                          isValid = false;
                          setState(() {
                            errorUniversity = '必須項目です';
                          });
                        }
                        if (!isValid) {
                          return;
                        }
                        setState(() {
                          loading = true;
                        });
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            )
                            .catchError(handleAuthError)
                            .then(
                              (value) => DatabaseService.createNewUser(
                                value.user.uid,
                                userName,
                                university.id,
                              ),
                            );
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
