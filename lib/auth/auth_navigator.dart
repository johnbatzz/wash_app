import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wash_app/auth/auth_cubit.dart';
import 'package:wash_app/auth/confirmation/confirm_signup_view.dart';
import 'package:wash_app/auth/signup/signup_view.dart';

import 'login/login_view.dart';

class AuthNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  	return BlocBuilder<AuthCubit, AuthState>(
		  
		  builder: (context, state) {
			  return Navigator(
				  pages: [
				  	if (state == AuthState.login) MaterialPage(child: LoginView()),
					  
					  if (state == AuthState.signUp ||
					      state == AuthState.confirmSignUp ) ...[
					      	MaterialPage(child: SignUpView()),
						  
						  if (state == AuthState.confirmSignUp) MaterialPage(child: ConfirmSignUpView())
					  ]
				  ],
				  onPopPage: (route, result) => route.didPop(result),
			  );
		  }
	  );
  }
	
}