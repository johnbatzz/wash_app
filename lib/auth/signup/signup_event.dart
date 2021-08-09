abstract class SignUpEvent {}

class SignUpUserNameChanged extends SignUpEvent {
	final String userName;
	SignUpUserNameChanged({this.userName});
}

class SignUpPasswordChanged extends SignUpEvent {
	final String password;
	SignUpPasswordChanged({this.password});
}

class PhoneNumberChanged extends SignUpEvent {
	final String phoneNumber;
	PhoneNumberChanged({this.phoneNumber});
}

class SignUpSubmitted extends SignUpEvent {

}