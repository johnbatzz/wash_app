import 'package:bloc/bloc.dart';
import 'package:wash_app/auth/FormSubmissionStatus.dart';
import 'package:wash_app/auth/auth_repository.dart';
import 'package:wash_app/auth/login/login_event.dart';
import 'package:wash_app/auth/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
	AuthRepository authRepository;
	LoginBloc({this.authRepository}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
    	yield state.copyWith(userName: event.userName);
    	
    } else if (event is LoginPasswordChanged) {
    	yield state.copyWith(password: event.password);
    	
    } else if (event is LoginSubmitted) {
    	yield state.copyWith(formStatus: FormSubmitting());
    	try {
    	  await authRepository.login();
    	  yield state.copyWith(formStatus: SubmissionSuccess());
	    } catch(e) {
		    yield state.copyWith(formStatus: SubmissionFailed());
	    }
    }
  }
}