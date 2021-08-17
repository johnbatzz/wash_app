import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_credentials.dart';

class FirebaseAuthenticationService {
  FirebaseAuth _firebaseAuth;
  GoogleSignInAccount _googleSignIn;
  FirebaseAuthenticationService(this._firebaseAuth);

  //Auto Login
  Future<AuthCredentials> autoLogin() async {
    if (_firebaseAuth.currentUser != null) {
      return AuthCredentials(
          userName  : _firebaseAuth.currentUser.email,
          userId    : _firebaseAuth.currentUser.uid
      );
    }
    return null;
  }

  //SignUp Phone Number
  Future<bool> singUpWithPhoneNumber(String phoneNumber) async {
    try {
      await _firebaseAuth.signInWithPhoneNumber(phoneNumber);
      return true;
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return false;
    }
  }

  //SignUp Email and Password
  Future<bool> signUpWithEmailAndPassword(String email, String password, String phoneNumber) async {
    try {
      final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (currentUser == null) {
        return false;
      }
      final String uid = currentUser.user.uid;
      final Map<String, dynamic> userObject = {
        'userId'      : uid,
        'email'       : email,
        'phoneNumber' : phoneNumber
      };
      FirebaseFirestore.instance.collection('users')
      .add(userObject);
      return true;
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return false;
    }
  }

  //SignIn Email and password
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

  //SignIn or SignUp with Facebook
  Future<AuthCredentials> signWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      final facebookAuthCredential = FacebookAuthProvider.credential(result.accessToken.token);
      final currentUser = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      try {
        if (currentUser == null) return null;
          AuthCredentials user = AuthCredentials(
              userName    : currentUser.user.email,
              userId      : currentUser.user.uid,
              photoUrl    : currentUser.user.photoURL,
              phoneNumber : currentUser.user.phoneNumber
          );
          await FirebaseFirestore.instance.collection('users')
          .where('userId', isEqualTo: currentUser.user.uid)
          .get()
          .then((QuerySnapshot querySnapshot) async {
            if (querySnapshot.size > 0) {
              final u = querySnapshot.docs[0]['userId'];
              if (u != currentUser.user.uid) {
                this._saveUser(currentUser);
              } else {
                await this._updateToken(querySnapshot.docs[0].id, await FirebaseMessaging.instance.getToken());
              }
            } else {
              this._saveUser(currentUser);
            }
          });
          return user;
      } on FirebaseAuthException catch(e) {
        print(e.message);
        return null;
      }
    }
    return null;
  }

  //SignIn or SignUp with Google
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
            userName    : currentUser.user.email,
            userId      : currentUser.user.uid,
            photoUrl    : currentUser.user.photoURL,
            phoneNumber : currentUser.user.phoneNumber
        );
        await FirebaseFirestore.instance.collection('users')
            .where('userId', isEqualTo: currentUser.user.uid)
            .get()
            .then((QuerySnapshot querySnapshot) async {
          if (querySnapshot.size > 0) {
            final u = querySnapshot.docs[0]['userId'];
            if (u != currentUser.user.uid) {
              this._saveUser(currentUser);
            } else {
              await this._updateToken(querySnapshot.docs[0].id, await FirebaseMessaging.instance.getToken());
            }
          } else {
            this._saveUser(currentUser);
          }
        });
        return user;
      }
    } on FirebaseAuthException catch(e) {
      print(e.message);
      return null;
    }
    return null;
  }

  //Signout from Firebase Authentication
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  //Save User
  Future<void> _saveUser(currentUser) async {
    String token = await this._getToken();
    final Map<String, dynamic> userObject = {
      'userId'      : currentUser.user.uid,
      'email'       : currentUser.user.email,
      'phoneNumber' : currentUser.user.phoneNumber,
      'photoUrl'    : currentUser.user.photoURL,
      'token'       : token
    };
    FirebaseFirestore.instance.collection('users')
        .add(userObject);
  }

  //Get token
  Future<String> _getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Future<void> _updateToken(String id, String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }
}