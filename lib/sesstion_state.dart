import 'package:flutter/foundation.dart';

abstract class SessionState {
	const SessionState();
}

class UnknownSessionState extends SessionState {
	const UnknownSessionState();
}

class Unauthenticated extends SessionState {
	const Unauthenticated();
}

class Authenticated extends SessionState {
	final dynamic user;
	Authenticated({@required this.user});
}