import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:washapp/auth/form_submission_status.dart';
import 'package:washapp/auth/auth_cubit.dart';
import 'package:washapp/auth/login/login_bloc.dart';
import 'package:washapp/auth/login/login_event.dart';
import 'package:washapp/widget/custom_spacer.dart';
import 'package:washapp/widget/logo.dart';

import '../auth_repository.dart';
import 'login_state.dart';

class LoginView extends StatefulWidget {
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _offsetAnimation.isDismissed;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset.fromDirection(1, 2),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: SlideTransition(
          position: _offsetAnimation,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [
                          0.1,
                          0.2,
                          0.4,
                        ],
                        colors: [
                          Colors.indigoAccent,
                          Colors.lightBlueAccent,
                          Colors.white,
                        ])),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // CustomAnimatedBackground(),
                    _loginForm(),
                    _showSignUpButton(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(
                context, "Login failed. Email and Password does not match!");
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Logo(),
                CustomSpacer(
                  height: 40,
                ),
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
                _loginWithSocialMediaAccount()
              ],
            ),
          ),
        ));
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
                borderSide: BorderSide(width: 2, color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(width: 2, color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 3, color: Colors.black12)),
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
                  borderSide: BorderSide(width: 2, color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 2, color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 3, color: Colors.black12),
                ),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.0)),
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

  Widget _otherLogin() {
    return Text(
      'Or SignIn With',
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }

  Widget _loginWithSocialMediaAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _facebookLoginButton(),
        CustomSpacer(
          width: 20,
        ),
        _googleSigninButton()
      ],
    );
  }

  Widget _facebookLoginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is FacebookSubmitting
          ? MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 2,
              height: 50.0,
              minWidth: 20.0,
              disabledColor: Colors.blueAccent,
              disabledTextColor: Colors.white,
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              onPressed: null,
            )
          : MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 5,
              height: 50.0,
              minWidth: 20.0,
              child: Icon(
                MdiIcons.facebook,
                size: 18,
              ),
              onPressed: () =>
                  {context.read<LoginBloc>().add(LoginWithFacebook())},
            );
    });
  }

  Widget _googleSigninButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state.formStatus is GoogleSubmitting
          ? MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 2,
              height: 50.0,
              minWidth: 20.0,
              disabledColor: Colors.blueAccent,
              disabledTextColor: Colors.white,
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.redAccent,
                  strokeWidth: 2,
                ),
              ),
              onPressed: null,
            )
          : MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0)),
              color: Colors.white,
              textColor: Colors.redAccent,
              elevation: 5,
              height: 50.0,
              minWidth: 20.0,
              child: Icon(
                MdiIcons.google,
                size: 18,
              ),
              onPressed: () =>
                  {context.read<LoginBloc>().add(LoginWithGoogle())},
            );
    });
  }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text(
          'Don\'t have an account? Sign up.',
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => context.read<AuthCubit>().showSignUp(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
