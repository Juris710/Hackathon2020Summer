import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:hackathon_2020_summer/services/database.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  bool _isFirstTime = true;
  final FirebaseAuth _auth;
  final DatabaseService _databaseService;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final PublishSubject<bool> loading = PublishSubject<bool>();
  final PublishSubject<User> _userChangesSubject = PublishSubject<User>();
  final ReplaySubject<Account> accountSubject =
      ReplaySubject<Account>(maxSize: 1);

  Stream<Account> get account =>
      accountSubject.where((event) => !event.isNoUser && event.dataExists);

  AuthService(this._auth, this._databaseService) {
    _userChangesSubject.addStream(_auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (_isFirstTime) {
        _isFirstTime = false;
        return false;
      }
      if (user != null) {
        print('${user.metadata.creationTime} ${user.metadata.lastSignInTime}');
      }
      return true;
    }));
    accountSubject.addStream(_userChangesSubject.switchMap((u) {
      if (u != null) {
        return _databaseService.getAccount(u.uid);
      } else {
        return Stream.value(Account.noUser());
      }
    }));
  }

  void dispose() {
    loading.close();
    _userChangesSubject.close();
    accountSubject.close();
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
