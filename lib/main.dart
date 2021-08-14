import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:washapp/session_cubit.dart';

import 'app_navigator.dart';
import 'auth/auth_repository.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wash App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.white
      ),
      home: RepositoryProvider(
	      create: (context) => AuthRepository(),
	      child:  BlocProvider(
		      create: (context) => SessionCubit(authRepo: context.read<AuthRepository>()),
		      child: AnimatedSwitcher(
            duration: Duration(seconds: 1),
              child: AppNavigator()
          ),
	      ),
      ),
    );
  }
}
