import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/auth/auth_cubit.dart';
import 'package:washapp/auth/auth_repository.dart';
import 'package:washapp/auth/confirmation/confirmation_event.dart';
import 'package:washapp/auth/confirmation/confirmation_state.dart';

import '../form_submission_status.dart';

class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
	AuthRepository authRepository;
	AuthCubit authCubit;

  ConfirmationBloc({this.authRepository, this.authCubit}) : super(ConfirmationState());

  @override
  Stream<ConfirmationState> mapEventToState(ConfirmationEvent event) async* {
    // Confirmation code updated
    if (event is ConfirmationCodeChanged) {
      yield state.copyWith(code: event.code);

      // Form submitted
    } else if (event is ConfirmationSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userId = await authRepository.confirmSignUp(
          userName: authCubit.credentials.userName,
          confirmationCode: state.code,
        );
        yield state.copyWith(formStatus: SubmissionSuccess());

        final credentials = authCubit.credentials;
        credentials.userId = userId;
        authCubit.launchSession(credentials);
      } catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}
