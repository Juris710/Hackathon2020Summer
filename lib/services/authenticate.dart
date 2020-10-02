import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static bool isFirstTime = true;
  final FirebaseAuth _auth;

  AuthService(this._auth);

  Stream<User> get userChanges {
    return _auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (AuthService.isFirstTime) {
        AuthService.isFirstTime = false;
        return false;
      }
      return true;
    });
  }

  Future<User> signIn({String email, String password}) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => value.user);
  }

  void signOut() {
    _auth.signOut();
  }
}
