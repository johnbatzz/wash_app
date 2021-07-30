import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wash_app/auth/login/login_bloc.dart';
import 'package:wash_app/auth/login/login_event.dart';

import '../auth_repository.dart';

class Login extends StatefulWidget {
	LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
	
	final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
  	return Scaffold(
		  body: BlocProvider(
			  create: (context) => LoginBloc(
				  authRepository: context.read<AuthRepository>()
			  ),
			  child: _loginForm(context)
		  )
	  );
  }
  
  Widget _loginForm(context) {
  	return BlocProvider(
		  create: (context) => LoginBloc(
			  authRepository: context.read<AuthRepository>()
		  ),
  	  child: Form(
		  key: _formKey,
		  child: Center(
			  child: Padding(
				  padding: EdgeInsets.symmetric(horizontal: 30.0),
				  child: Column(
					  mainAxisAlignment: MainAxisAlignment.center,
					  crossAxisAlignment: CrossAxisAlignment.center,
					  children: [
						  _userNameField(),
						  _passwordField(),
						  SizedBox(
							  height: 30,
						  ),
						  _loginButton(context),
						  SizedBox(
							  height: 100,
							  child: Center(
								  child: Text(
									  "OR"
								  ),
							  ),
						  ),
						  _facebookLoginButton(context),
						  SizedBox(
							  height: 30,
						  ),
						  _googleSigninButton(context)
					  ],
				  ),
			  ),
		  ),
	  ),
  	);
  }
  
  
  Widget _userNameField() {
  	return BlocBuilder<LoginBloc, LoginState>(
		  builder: (context, state) {
			  return  Padding(
				  padding: EdgeInsets.all(5.0),
					  child: TextFormField(
						  keyboardType: TextInputType.emailAddress,
						  decoration: InputDecoration(
							  hintText: "Email Address",
							  prefixIcon: Icon(
							    Icons.person
							  )
						  ),
						  validator: (value) => state.isValidUserName ? null : "Username is too short.",
						  onChanged: (value) => context.read<LoginBloc>().add(
							  LoginUsernameChanged(userName: value)
						  ),
					  ),
			  );
	    });
  }

  Widget _passwordField() {
	  return Padding(
		  padding: EdgeInsets.all(5.0),
		  child: TextFormField(
			  obscureText: true,
			  keyboardType: TextInputType.visiblePassword,
			  decoration: InputDecoration(
				  hintText: "Password",
				  prefixIcon: Icon(
					  Icons.security_outlined
				  )
			  ),
			  validator: (value) => null,
		  ),
	  );
  }

  Widget _loginButton(context) {
	  return MaterialButton(
		  color: Colors.blueAccent,
		  textColor: Colors.white,
		  elevation: 2,
		  minWidth: MediaQuery.of(context).size.width * 0.8,
		  height: 50.0,
		  child: Text(
			  'Login'
		  ),
		  onPressed: () => {},
	  );
  }
  
  Widget _facebookLoginButton(context) {
      return MaterialButton(
	      color: Colors.blueAccent,
	      textColor: Colors.white,
	      elevation: 2,
	      minWidth: MediaQuery.of(context).size.width * 0.8,
	      height: 50.0,
	      child: Row(
		      mainAxisAlignment: MainAxisAlignment.center,
		      children: [
			      new Icon(
				      MdiIcons.facebook
			      ),
			      SizedBox(
				      width: 20,
			      ),
			      Text(
				      'Signin with Facebook'
			      ),
		      ],
	      ),
	      onPressed: () => {},
      );
  }

  Widget _googleSigninButton(context) {
	  return MaterialButton(
		  color: Colors.white,
		  textColor: Colors.redAccent,
		  elevation: 2,
		  minWidth: MediaQuery.of(context).size.width * 0.8,
		  height: 50.0,
		  child: Row(
			  mainAxisAlignment: MainAxisAlignment.center,
			  children: [
			  	new Icon(
					  MdiIcons.google
				  ),
				  SizedBox(
					  width: 20,
				  ),
				  Text(
					  'Signin with Google'
				  ),
			  ],
		  ),
		  onPressed: () => {},
	  );
  }
	
  
  
}