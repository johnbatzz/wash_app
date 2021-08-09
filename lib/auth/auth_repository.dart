import 'package:flutter/cupertino.dart';

class AuthRepository {
	Future<String> attemptAutoLogin() async {
		await Future.delayed(Duration(seconds: 3));
		throw Exception('not signed in');
	}
	
	Future<String> login({
		@required String userName,
		@required String password,
	}) async {
		print('attempting login');
		await Future.delayed(Duration(seconds: 3));
		return 'abc';
	}
	
	Future<void> signUp({
		@required String userName,
		@required String phoneNumber,
		@required String password,
	}) async {
		await Future.delayed(Duration(seconds: 2));
	}
	
	Future<String> confirmSignUp({
		@required String userName,
		@required String confirmationCode,
	}) async {
		await Future.delayed(Duration(seconds: 2));
		return 'abc';
	}
	
	Future<void> signOut() async {
		await Future.delayed(Duration(seconds: 2));
	}
}
