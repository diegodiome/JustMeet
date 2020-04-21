import 'dart:async';

import 'package:justmeet_frontend/models/user.dart';

class ListenToUser {}

class OnUserStatusUpdate {
  final UserStatus status;

  OnUserStatusUpdate({this.status});
}

class OnLocalUserUpdateSuccess {
  final User userUpdated;

  OnLocalUserUpdateSuccess({this.userUpdated});
}

class OnLocalUserUpdate {
  int userId;
  Completer completer;

  OnLocalUserUpdate({this.userId, Completer completer})
      : completer = completer ?? Completer();
}
