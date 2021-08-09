abstract class LoginEvent {}

class LoginUsernameChanged extends LoginEvent {
	final String userName;
	LoginUsernameChanged({this.userName});
}

class LoginPasswordChanged extends LoginEvent {
	final String password;
	LoginPasswordChanged({this.password});
}

class LoginSubmitted extends LoginEvent {}

class LoginWithFacebook extends LoginEvent{}

class LoginWithGoogle extends LoginEvent{}