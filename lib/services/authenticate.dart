import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static bool _isFirstTime = true;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService(this._auth);

  Stream<User> get userChanges {
    return _auth.userChanges().where((user) {
      /*
      起動時にuserChanges() (authStateChanges(), idTokenChanges()も同様)が2回呼ばれる問題の対策
      1回目だけ無視する
      */
      if (AuthService._isFirstTime) {
        AuthService._isFirstTime = false;
        return false;
      }
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

  Future<User> googleSignIn() async {
    final googleUser = await _googleSignIn.signIn();
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  void signOut() {
    _auth.signOut();
  }
}
