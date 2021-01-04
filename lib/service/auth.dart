import 'package:expire_item/service/Database/user_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  //auth change user Stream
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  // sign in with Email & Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with google
  Future<User> signInWithGoogle() async {
    final dynamic googleSigninAccount = await _googleSignIn.signIn();
    if (googleSigninAccount == null) {
      print('User enter back button');
      return null;
    } else {
      final gsa = await googleSigninAccount.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: gsa.accessToken, idToken: gsa.idToken);
      User user = (await _auth.signInWithCredential(credential)).user;
      await UserDbService(uid: user.uid).addUserData(
          user.email, user.displayName, 'Password', 'Mobile No', 'Address');
      return user;
    }
  }

  // register with Email & Password
  Future registerWithEmailAndPassword(
      String email, String password, String mobileno, String userName) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await UserDbService(uid: user.uid)
          .addUserData(email, userName, password, mobileno, "Address");
      return user;
    } catch (e) {
      print(e.toString());
      print('*******************Signup Error*************************');
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      } else {
        await _auth.signOut();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
