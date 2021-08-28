import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:washapp/data/model/user.dart';

import 'auth_service.dart';

class AuthRepository {
  Future<User> attemptAutoLogin() async {
    return await FirebaseAuthenticationService(FirebaseAuth.instance)
        .autoLogin();
  }

  Future<User> login({
    @required String userName,
    @required String password,
  }) async {
    return await FirebaseAuthenticationService(FirebaseAuth.instance)
        .signInWithEmailAndPassword(userName, password);
  }

  Future<void> signUp({
    @required String userName,
    @required String phoneNumber,
    @required String password,
  }) async {
    await FirebaseAuthenticationService(FirebaseAuth.instance)
        .signUpWithEmailAndPassword(userName, password, phoneNumber);
  }

  Future<String> confirmSignUp({
    @required String userName,
    @required String confirmationCode,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return 'abc';
  }

  Future<User> loginWithFacebook() async {
    return await FirebaseAuthenticationService(FirebaseAuth.instance)
        .signWithFacebook();
  }

  Future<User> loginWithGoogle() async {
    return await FirebaseAuthenticationService(FirebaseAuth.instance)
        .signWithGoogle();
  }

  Future<void> signOut() async {
    await FirebaseAuthenticationService(FirebaseAuth.instance).signOut();
  }
}
