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
  StreamSubscription _userChangesSubscription;
  StreamSubscription _userSnapshotSubscription;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final StreamController<Account> account = StreamController<Account>();
  final StreamController<AuthStatus> authStatus =
      StreamController<AuthStatus>();
  final PublishSubject<bool> loading = PublishSubject<bool>();

  AuthService(this._auth, this._db) {
    _userChangesSubscription = _auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (_isFirstTime) {
        _isFirstTime = false;
        return false;
      }
      return true;
    }).listen((user) {
      _userSnapshotSubscription?.cancel();
      if (user != null) {
        _userSnapshotSubscription = _db
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .map((doc) => Account.fromFirestore(doc, user))
            .listen((account) {
          this.account.sink.add(account);
          this.authStatus.sink.add(getAuthStatus(account));
        });
      } else {
        _userSnapshotSubscription = null;
        this.authStatus.sink.add(AuthStatus.NO_USER);
      }
    });
  }

  void dispose() {
    loading.close();
    account.close();
    authStatus.close();
    _userChangesSubscription?.cancel();
    _userSnapshotSubscription?.cancel();
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
