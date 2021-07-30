import 'package:wash_app/auth/FormSubmissionStatus.dart';

class LoginState {
	final String userName;
	bool get isValidUserName => userName.length > 3;
	final String password;
	bool get isValidPassword => password.length > 6;
	final FormSubmissionStatus formStatus;
	
	LoginState({
		this.userName   = '',
		this.password   = '',
		this.formStatus = const InitialFormStatus(),
	});
	
	LoginState copyWith({
		String userName,
		String password,
		FormSubmissionStatus formStatus
	}) {
		return LoginState(
			userName    : userName    ?? this.userName,
			password    : password    ?? this.password,
			formStatus  : formStatus  ?? this.formStatus,
		);
	}
}