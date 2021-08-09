import '../form_submission_status.dart';

class SignUpState {
	final String userName;
	bool get isValidUserName => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(userName);
	final String password;
	bool get isValidPassword => password.length > 6;
	final FormSubmissionStatus formStatus;
	final String phoneNumber;
	bool get isValidPhoneNumber => phoneNumber.length == 11;
	
	SignUpState({
		this.userName     = '',
		this.password     = '',
		this.phoneNumber  = '',
		this.formStatus   = const InitialFormStatus(),
	});
	
	SignUpState copyWith({
		String userName,
		String password,
		String phoneNumber,
		FormSubmissionStatus formStatus
	}) {
		return SignUpState(
			userName    : userName    ?? this.userName,
			password    : password    ?? this.password,
			phoneNumber : phoneNumber ?? this.phoneNumber,
			formStatus  : formStatus  ?? this.formStatus,
		);
	}
}