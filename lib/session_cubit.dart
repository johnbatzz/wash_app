import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/sesstion_state.dart';

import 'auth/auth_credentials.dart';
import 'auth/auth_repository.dart';

class SessionCubit extends Cubit<SessionState> {
	final AuthRepository authRepo;
	
	SessionCubit({this.authRepo}) : super(UnknownSessionState()) {
		attemptAutoLogin();
	}
	
	void attemptAutoLogin() async {
		try {
			AuthCredentials user = await authRepo.attemptAutoLogin();
			if (user != null) {
				emit(Authenticated(user: user));
			}
			emit(Unauthenticated());
		} on Exception {
			emit(Unauthenticated());
		}
	}
	
	void showAuth() => emit(Unauthenticated());
	
	void showSession(AuthCredentials credentials) {
		final user = credentials;
		emit(Authenticated(user: user));
	}
	
	void signOut() {
		authRepo.signOut();
		emit(Unauthenticated());
	}
}