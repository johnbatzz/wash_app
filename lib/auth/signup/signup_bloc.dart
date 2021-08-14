import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/auth/auth_cubit.dart';
import 'package:washapp/auth/signup/signup_event.dart';
import 'package:washapp/auth/signup/signup_state.dart';

import '../form_submission_status.dart';
import '../auth_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
	AuthRepository authRepo;
	AuthCubit authCubit;
	SignUpBloc({this.authRepo, this.authCubit}) : super(SignUpState());
	
	@override
	Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
		if (event is SignUpUserNameChanged) {
			yield state.copyWith(userName: event.userName);
			
		} else if (event is SignUpPasswordChanged) {
			yield state.copyWith(password: event.password);
			
		} else if (event is PhoneNumberChanged) {
			yield state.copyWith(phoneNumber: event.phoneNumber);

		} else if (event is SignUpSubmitted) {
			yield state.copyWith(formStatus: FormSubmitting());
			
			// authCubit.showConfirmSignUp(
			// 	userName		: state.userName,
			// 	password		: state.password,
			// 	phoneNumber	: state.phoneNumber
			// );
			
			try {
				await authRepo.signUp(
						userName		: state.userName,
						phoneNumber	: state.phoneNumber,
						password		: state.password
				);
				yield state.copyWith(formStatus: SubmissionSuccess());
			} catch(e) {
				yield state.copyWith(formStatus: SubmissionFailed(e));
			}
		}
	}
}