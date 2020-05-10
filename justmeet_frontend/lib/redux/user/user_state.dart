import 'package:justmeet_frontend/models/event_request.dart';
import 'package:justmeet_frontend/models/user.dart';

class UserState {
  final User currentUser;
  final List<EventRequest> requests;

  UserState({this.currentUser, this.requests});

  factory UserState.initial() {
    return UserState(
        currentUser: new User(), requests: new List<EventRequest>());
  }

  UserState copyWith({User currentUser, List<EventRequest> requests}) {
    return UserState(
        currentUser: currentUser ?? this.currentUser,
        requests: requests ?? this.requests);
  }
}
