import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:washapp/main.dart';
import 'package:washapp/session_cubit.dart';
import 'package:washapp/session_view.dart';
import 'package:washapp/sesstion_state.dart';

import 'auth/auth_cubit.dart';
import 'auth/auth_navigator.dart';
import 'loading_view.dart';

class AppNavigator extends StatefulWidget {
	_AppNavigator createState() => _AppNavigator();
}

class _AppNavigator extends State<AppNavigator> {

	@override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    	RemoteNotification notification = message.notification;
    	AndroidNotification android = message.notification?.android;
    	if (notification != null && android != null) {
    		flutterLocalNotificationsPlugin.show(
					notification.hashCode,
					notification.title,
					notification.body,
					NotificationDetails(
						android: AndroidNotificationDetails(
							channel.id,
							channel.name,
							channel.description,
							color: Colors.blueAccent,
							importance: Importance.high,
							playSound: true,
							icon: '@mipmap/ic_launcher'
						)
					)
				);
			}
		});
		FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
			RemoteNotification notification = message.notification;
			AndroidNotification android = message.notification?.android;
			if (notification != null && android != null) {
				showDialog(
					context: context,
					builder: (_) {
						return AlertDialog(
							title: Text(notification.title),
							content: SingleChildScrollView(
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(notification.body)
									],
								)
							)
						);
					}
				);
			}
		});
  }

	@override
	Widget build(BuildContext context) {
		return BlocBuilder<SessionCubit, SessionState>(builder: (context, state) {
			return Navigator(
				pages: [
					// Show loading screen
					if (state is UnknownSessionState) MaterialPage(child: LoadingView()),
					
					// Show auth flow
					if (state is Unauthenticated)
						MaterialPage(
							child: BlocProvider(
								create: (context) =>
									AuthCubit(sessionCubit: context.read<SessionCubit>()),
								child: AuthNavigator(),
							),
						),
					
					// Show session flow
					if (state is Authenticated) MaterialPage(
							child: SessionView(
								user: state.user,
							)
					)
				],
				onPopPage: (route, result) => route.didPop(result),
			);
		});
	}
}