class AuthRepository {
	Future<void> login() async {
		print("logging in...");
		await Future.delayed(Duration(seconds: 3));
		print("logged in!");
	}
}