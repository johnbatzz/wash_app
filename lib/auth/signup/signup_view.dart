import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/auth/signup/signup_bloc.dart';
import 'package:washapp/auth/signup/signup_state.dart';
import 'package:washapp/widget/custom_spacer.dart';

import '../form_submission_status.dart';
import '../auth_cubit.dart';
import '../auth_repository.dart';
import 'signup_event.dart';

class SignUpView extends StatefulWidget {
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> with SingleTickerProviderStateMixin {
  final _signUpFormKey = GlobalKey<FormState>();

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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: Offset.fromDirection(0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignUpBloc(
          authRepo: context.read<AuthRepository>(),
          authCubit: context.read<AuthCubit>(),
        ),
        child: SlideTransition(
          position: _offsetAnimation,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _signUpForm(),
              _showLoginButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Form(
          key: _signUpFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(),
                CustomSpacer(),
                _phoneNumberField(),
                CustomSpacer(),
                _passwordField(),
                CustomSpacer(height: 50),
                _signUpButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.person),
          hintText: 'Email',
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
                ? "Field required."
                : 'Invalid email.',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpUserNameChanged(userName: value),
            ),
      );
    });
  }

  Widget _phoneNumberField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mobile_friendly),
          hintText: 'Phone Number',
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
        validator: (value) => state.isValidPhoneNumber
            ? null
            : value.isEmpty
                ? 'Field required.'
                : 'Invalid Phone Number.',
        onChanged: (value) => context.read<SignUpBloc>().add(
					PhoneNumberChanged(phoneNumber: value),
            ),
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.security),
          hintText: 'Password',
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
                ? 'Field required.'
                : 'Password is too short',
        onChanged: (value) => context.read<SignUpBloc>().add(
              SignUpPasswordChanged(password: value),
            ),
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return state.formStatus is FormSubmitting
          ? MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 2,
              height: 50.0,
              child: CircularProgressIndicator(),
            )
          : MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Colors.blueAccent,
              textColor: Colors.white,
              elevation: 2,
              height: 50.0,
              minWidth: MediaQuery.of(context).size.width * 0.8,
              child: Text('Sign Up'),
              onPressed: () => {
                if (_signUpFormKey.currentState.validate())
                  {context.read<SignUpBloc>().add(SignUpSubmitted())}
              },
            );
    });
  }

  Widget _showLoginButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Already have an account? Sign in.'),
        onPressed: () => context.read<AuthCubit>().showLogin(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
