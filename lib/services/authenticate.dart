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
  Stream<User> _user;
  Stream<Account> account;
  final PublishSubject<bool> loading = PublishSubject<bool>();

  AuthService() {
    _user = _auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (_isFirstTime) {
        _isFirstTime = false;
        return false;
      }
      return true;
    }).asBroadcastStream();
    account = _user.switchMap((u) {
      if (u != null) {
        return _db
            .collection('users')
            .doc(u.uid)
            .snapshots()
            .map((doc) => Account.fromFirestore(doc));
      } else {
        return Stream.value(Account.noUser());
      }
    }).asBroadcastStream();
  }

  void dispose() {
    loading.close();
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
