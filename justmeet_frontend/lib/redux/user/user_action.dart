import 'dart:async';

import 'package:justmeet_frontend/models/event_request.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/models/user_reporting.dart';

class ListenToUser {}

class OnUserStatusUpdate {
  final UserStatus status;

  OnUserStatusUpdate({this.status});
}

class OnUserRequestsListUpdate {
  final String userId;

  OnUserRequestsListUpdate({this.userId});
}

class OnUserReuqestsListUpdateSuccess {
  final List<EventRequest> requestsUpdate;

  OnUserReuqestsListUpdateSuccess({this.requestsUpdate});
}

class OnUserAcceptRequest {
  final String userId;
  final String eventId;

  OnUserAcceptRequest({this.userId, this.eventId});
}

class OnLocalUserUpdateSuccess {
  final User userUpdated;

  OnLocalUserUpdateSuccess({this.userUpdated});
}

class OnUpdateUser {
  User userUpdated;

  OnUpdateUser({this.userUpdated});
}

class OnUserReporting {
  UserReporting userReporting;

  OnUserReporting({this.userReporting});
}

class OnLocalUserUpdate {
  String userId;
  Completer completer;

  OnLocalUserUpdate({this.userId, Completer completer})
      : completer = completer ?? Completer();
}
