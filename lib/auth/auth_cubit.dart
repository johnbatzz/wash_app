import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/data/model/user.dart';

import '../session_cubit.dart';

enum AuthState { login, signUp, confirmSignUp }

class AuthCubit extends Cubit<AuthState> {
  final SessionCubit sessionCubit;
  AuthCubit({this.sessionCubit}) : super(AuthState.login);

  User credentials;

  void showLogin() => emit(AuthState.login);

  void showSignUp() => emit(AuthState.signUp);

  void showConfirmSignUp({
    String userName,
    String phoneNumber,
    String password,
  }) {
    credentials = User(
      userName: userName,
      phoneNumber: phoneNumber,
      password: password,
    );
    emit(AuthState.confirmSignUp);
  }

  void launchSession(User credentials) => sessionCubit.showSession(credentials);
}
