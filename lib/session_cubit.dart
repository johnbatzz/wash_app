import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/data/model/user.dart';
import 'package:washapp/sesstion_state.dart';

import 'auth/auth_repository.dart';
import 'data/repositories/user_repository.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepo;
  final UserRepository userRepo;

  SessionCubit({this.authRepo, this.userRepo}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      User user = await authRepo.attemptAutoLogin();
      if (user != null) {
        user = await userRepo.getById(userId: user.userId);
        emit(Authenticated(user: user));
      } else {
        emit(Unauthenticated());
      }
    } on Exception {
      emit(Unauthenticated());
    }
  }

  void showAuth() => emit(Unauthenticated());

  void showSession(User credentials) {
    final user = credentials;
    emit(Authenticated(user: user));
  }

  void signOut() {
    authRepo.signOut();
    emit(Unauthenticated());
  }
}
