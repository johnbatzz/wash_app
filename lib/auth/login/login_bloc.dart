import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_submission_status.dart';
import '../auth_credentials.dart';
import '../auth_cubit.dart';
import '../auth_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
	final AuthRepository authRepo;
	final AuthCubit authCubit;
	
	LoginBloc({this.authRepo, this.authCubit}) : super(LoginState());
	
	@override
	Stream<LoginState> mapEventToState(LoginEvent event) async* {
		// Username updated
		if (event is LoginUsernameChanged) {
			yield state.copyWith(userName: event.userName);
			
			// Password updated
		} else if (event is LoginPasswordChanged) {
			yield state.copyWith(password: event.password);
			
			// Form submitted
		} else if (event is LoginSubmitted) {
			yield state.copyWith(formStatus: FormSubmitting());
			try {
				AuthCredentials user = await authRepo.login(
						userName: state.userName,
						password: state.password
				);
				if (user == null) {
					yield state.copyWith(formStatus: SubmissionFailed(null));
				} else {
					yield state.copyWith(formStatus: SubmissionSuccess());

					authCubit.launchSession(user);
				}
			} on Exception catch (e) {
				yield state.copyWith(formStatus: SubmissionFailed(e));
			}
		} else if (event is LoginWithFacebook) {
			yield state.copyWith(formStatus: FacebookSubmitting());
			try {
				AuthCredentials user = await authRepo.loginWithFacebook();
				if (user == null) {
					yield state.copyWith(formStatus: SubmissionFailed(null));
				} else {
					yield state.copyWith(formStatus: SubmissionSuccess());

					authCubit.launchSession(user);
				}
			} on Exception catch (e) {
				yield state.copyWith(formStatus: SubmissionFailed(e));
			}
		} else if (event is LoginWithGoogle) {
			yield state.copyWith(formStatus: GoogleSubmitting());
			try {
				AuthCredentials user = await authRepo.loginWithGoogle();
				if (user == null) {
					yield state.copyWith(formStatus: SubmissionFailed(null));
				} else {
					yield state.copyWith(formStatus: SubmissionSuccess());

					authCubit.launchSession(user);
				}
			} on Exception catch (e) {
				yield state.copyWith(formStatus: SubmissionFailed(e));
			}
		}
	}
}
