import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_2020_summer/shared/constants.dart';
import 'package:hackathon_2020_summer/shared/loading.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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
          newErrorEmail = 'The email address is badly formatted.';
          break;
        case 'user-not-found':
          newErrorEmail = 'There is no such user.';
          break;
        case 'email-already-in-use':
          newErrorEmail = 'The email address is already in use.';
          break;
        case 'weak-password':
          newErrorPassword = 'Password should be at least 6 characters.';
          break;
        case 'wrong-password':
          newErrorPassword = 'The password is wrong.';
          break;
        default:
          newError = 'Unknown Auth Error\n${e.code}\n${e.message}';
      }
    } else {
      newError = 'Unknown Error\n${e.runtimeType}\n$e';
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
        title: Text(appName),
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
                      decoration: InputDecoration(
                        hintText: 'Email',
                        errorText: errorEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
                      decoration: InputDecoration(
                        hintText: 'Password',
                        errorText: errorPassword,
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (val) =>
                          val.isEmpty ? 'Enter a password' : null,
                      obscureText: true,
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
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    RaisedButton(
                      color: Colors.green,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (!_formKey.currentState.validate()) {
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
                            .catchError(handleAuthError);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
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
