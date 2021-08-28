import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:washapp/data/model/user.dart';
import 'package:washapp/widget/custom_animated_background.dart';

import '../session_cubit.dart';

class HomeView extends StatefulWidget {
  final User user;

  const HomeView({Key key, this.user}) : super(key: key);
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
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
      begin: Offset.fromDirection(2, 2),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlideTransition(
      position: _offsetAnimation,
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
            CustomAnimatedBackground(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Text('sign out'),
                  onPressed: () =>
                      BlocProvider.of<SessionCubit>(context).signOut(),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
