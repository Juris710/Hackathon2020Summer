import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hackathon_2020_summer/models/user/account.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  bool _isFirstTime = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db =
      FirebaseFirestore.instance; //Database for account
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Stream<User> user;
  Stream<Account> account;

  AuthService() {
    user = _auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (_isFirstTime) {
        _isFirstTime = false;
        return false;
      }
      return true;
    });
    account = user.switchMap((u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((doc) => Account.fromFirestore(doc));
      } else {
        return Stream.value(null);
      }
    });
  }

  Stream<User> get userChanges {
    return _auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (_isFirstTime) {
        _isFirstTime = false;
        return false;
      }
      print('DEBUG_PRINT UserChanges:${user != null}');
      return true;
    });
  }

  Future<User> signUp({String email, String password}) {
    return _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => value.user);
  }

  Future<User> signIn({String email, String password}) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => value.user);
  }

  Future<Map<String, dynamic>> googleSignIn() async {
    return _googleSignIn
        .signIn()
        .then((googleUser) => googleUser.authentication)
        .then((googleAuth) => GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken))
        .then((credential) => _auth.signInWithCredential(credential))
        .then((userCredential) => {
              'user': userCredential.user,
              'isNewUser': userCredential.additionalUserInfo.isNewUser
            });
  }

  void signOut() {
    _auth.signOut();
  }
}
