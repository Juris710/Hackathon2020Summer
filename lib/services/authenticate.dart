import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon_2020_summer/main.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/shared/authenticate_status.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  bool _isFirstTime = true;
  final FirebaseAuth _auth;
  final FirebaseFirestore _db; //Database for account
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final PublishSubject<bool> loading = PublishSubject<bool>();
  final PublishSubject<User> _userChangesSubject = PublishSubject<User>();
  final PublishSubject<Account> _accountSubject = PublishSubject<Account>();
  final PublishSubject<AuthStatus> _authStatusSubject =
      PublishSubject<AuthStatus>();

  Stream<Account> get account => _accountSubject.stream
      .where((event) => getAuthStatus(event) != AuthStatus.NO_USER);

  Stream<AuthStatus> get authStatus => _authStatusSubject.stream.distinct();

  AuthService(this._auth, this._db) {
    _userChangesSubject.addStream(_auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (_isFirstTime) {
        _isFirstTime = false;
        return false;
      }
      return true;
    }));
    _accountSubject.addStream(_userChangesSubject.switchMap((u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((doc) => Account.fromFirestore(doc, u));
      } else {
        return Stream.value(Account.noUser());
      }
    }));
    _authStatusSubject
        .addStream(_accountSubject.map((event) => getAuthStatus(event)));
  }

  void dispose() {
    loading.close();
    _userChangesSubject.close();
    _accountSubject.close();
    _authStatusSubject.close();
  }

  Future<User> signUp({String email, String password}) async {
    loading.add(true);
    UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
    loading.add(false);
    return credential?.user;
  }

  Future<User> signIn({String email, String password}) async {
    loading.add(true);
    UserCredential credential;
    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
    loading.add(false);
    return credential?.user;
  }

  Future<UserCredential> googleSignIn() async {
    loading.add(true);
    UserCredential credential;
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    credential = await _auth.signInWithCredential(googleCredential);
    loading.add(false);
    return credential;
  }

  void signOut() {
    _auth.signOut();
  }
}
