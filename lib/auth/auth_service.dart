import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_credentials.dart';

class FirebaseAuthenticationService {
  FirebaseAuth _firebaseAuth;
  GoogleSignInAccount _googleSignIn;
  FirebaseAuthenticationService(this._firebaseAuth);

  Future<AuthCredentials> autoLogin() async {
    if (_firebaseAuth.currentUser != null) {
      return AuthCredentials(
        userName  : _firebaseAuth.currentUser.email,
        userId    : _firebaseAuth.currentUser.uid
      );
    }
    return null;
  }

  Future<bool> singUpWithPhoneNumber(String phoneNumber, String password) async {
    try {
      await _firebaseAuth.signInWithPhoneNumber(phoneNumber);
      return true;
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return false;
    }
  }

  Future<AuthCredentials> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return AuthCredentials(
        userName  : email,
        userId    : _firebaseAuth.currentUser.uid
      );
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return null;
    }
  }

  Future<AuthCredentials> signWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
      final currentUser = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      try {
        if (currentUser != null) {
          AuthCredentials user = AuthCredentials(
              userName : currentUser.user.email,
              userId   : currentUser.user.uid,
              photoUrl : currentUser.user.photoURL
          );
          return user;
        }
        return null;
      } on FirebaseAuthException catch(e) {
        print(e.message);
        return null;
      }
    }
    return null;
  }

  Future<AuthCredentials> signWithGoogle() async {
    _googleSignIn = await GoogleSignIn().signIn();
    if (_googleSignIn == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await _googleSignIn.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken : googleAuth.accessToken,
      idToken     : googleAuth.idToken
    );
    final currentUser = await FirebaseAuth.instance.signInWithCredential(credential);
    try {
      if (currentUser != null) {
        AuthCredentials user = AuthCredentials(
            userName : currentUser.user.email,
            userId   : currentUser.user.uid,
            photoUrl : currentUser.user.photoURL
        );
        return user;
      }
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return null;
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}