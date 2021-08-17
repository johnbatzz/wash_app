import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/auth/auth_credentials.dart';
import 'package:washapp/session_cubit.dart';


class SessionView extends StatelessWidget {
	final AuthCredentials user;

	SessionView({Key key, this.user}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					children: [
						Text('Hello ${user.userName}'),
						TextButton(
							child: Text('sign out'),
							onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
						)
					],
				),
			),
		);
	}
}