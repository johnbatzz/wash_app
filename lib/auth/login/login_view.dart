import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:washapp/auth/form_submission_status.dart';
import 'package:washapp/auth/auth_cubit.dart';
import 'package:washapp/auth/login/login_bloc.dart';
import 'package:washapp/auth/login/login_event.dart';
import 'package:washapp/widget/custom_spacer.dart';

import '../auth_repository.dart';
import 'login_state.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _loginForm(),
            _showSignUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _userNameField(),
                CustomSpacer(
                  height: 10,
                ),
                _passwordField(),
                CustomSpacer(
                  height: 20,
                ),
                _loginButton(),
                CustomSpacer(
                  height: 20,
                ),
                _otherLogin(),
                CustomSpacer(
                  height: 20,
                ),
                _facebookLoginButton(),
                CustomSpacer(height: 20),
                _googleSigninButton()
              ],
            ),
          ),
        ));
  }

  Widget _otherLogin() {
    return Text('Or Signin with');
  }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Don\'t have an account? Sign up.'),
        onPressed: () => context.read<AuthCubit>().showSignUp(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _userNameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.all(0.0),
        child: MediaQuery(
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email Address",
              prefixIcon: Icon(Icons.person),
              border: new OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(width: 1, color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(width: 1, color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 1, color: Colors.black)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: .5, color: Colors.black12)),
            ),
            validator: (value) => state.isValidUserName
                ? null
                : value.isEmpty
                    ? "Email is required."
                    : "Invalid email address.",
            onChanged: (value) => context
                .read<LoginBloc>()
                .add(LoginUsernameChanged(userName: value)),
          ),
          data: MediaQuery.of(context).copyWith(textScaleFactor: .8),
        ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Padding(
        padding: EdgeInsets.all(0.0),
        child: MediaQuery(
          child: TextFormField(
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.security_outlined),
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(width: 1, color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 1, color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: 1, color: Colors.black)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(width: .5, color: Colors.black12)),
              ),
              validator: (value) => state.isValidPassword
                  ? null
                  : value.isEmpty
                      ? "Password is required."
                      : "Password must atleast 6 characters.",
              onChanged: (value) => context
                  .read<LoginBloc>()
                  .add(LoginPasswordChanged(password: value))),
          data: MediaQuery.of(context).copyWith(textScaleFactor: .8),
        ),
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? MaterialButton(
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(20.0) ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 2,
              height: 50.0,
              disabledColor: Colors.blueAccent,
              disabledTextColor: Colors.white,
              minWidth: MediaQuery.of(context).size.width * 0.90,
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
                color: Colors.white,
                strokeWidth: 2,
              ),
              onPressed: null,
            )
          : MaterialButton(
              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 2,
              height: 50.0,
              minWidth: MediaQuery.of(context).size.width * 0.90,
              child: Text('Login'),
              onPressed: () => {
                if (_formKey.currentState.validate())
                  {context.read<LoginBloc>().add(LoginSubmitted())}
              },
            );
    });
  }

  Widget _facebookLoginButton() {
    return MaterialButton(
      color: Colors.blueAccent,
      textColor: Colors.white,
      elevation: 2,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(MdiIcons.facebook),
          SizedBox(
            width: 20,
          ),
          Text('Signin with Facebook'),
        ],
      ),
      onPressed: () => {},
    );
  }

  Widget _googleSigninButton() {
    return MaterialButton(
      color: Colors.white,
      textColor: Colors.redAccent,
      elevation: 2,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Icon(MdiIcons.google),
          SizedBox(
            width: 20,
          ),
          Text('Signin with Google'),
        ],
      ),
      onPressed: () => {},
    );
  }
}
