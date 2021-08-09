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
				final userId = await authRepo.login(
					userName: state.userName,
					password: state.password,
				);
				yield state.copyWith(formStatus: SubmissionSuccess());
				
				authCubit.launchSession(AuthCredentials(
					userName: state.userName,
					userId: userId,
				));
			} catch (e) {
				yield state.copyWith(formStatus: SubmissionFailed(e));
			}
		} else if (event is LoginWithFacebook) {
		
		} else if (event is LoginWithGoogle) {
		
		}
	}
}
