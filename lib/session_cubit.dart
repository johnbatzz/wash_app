import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/auth/auth_cubit.dart';
import 'package:washapp/sesstion_state.dart';

import 'auth/auth_credentials.dart';
import 'auth/auth_repository.dart';
import 'data/model/user.dart';

class SessionCubit extends Cubit<SessionState> {
	final AuthRepository authRepo;
	
	SessionCubit({this.authRepo}) : super(UnknownSessionState()) {
		attemptAutoLogin();
	}
	
	void attemptAutoLogin() async {
		try {
			final userId = await authRepo.attemptAutoLogin();
			// final user = dataRepo.getUser(userId);
			final user = userId;
			emit(Authenticated(user: user));
		} on Exception {
			emit(Unauthenticated());
		}
	}
	
	void showAuth() => emit(Unauthenticated());
	
	void showSession(AuthCredentials credentials) {
		// final user = dataRepo.getUser(credentials.userId);
		final user = credentials.userName;
		emit(Authenticated(user: user));
	}
	
	void signOut() {
		authRepo.signOut();
		emit(Unauthenticated());
	}
}