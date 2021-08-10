import 'package:washapp/auth/form_submission_status.dart';

class LoginState {
	final String userName;
	bool get isValidUserName => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(userName);
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