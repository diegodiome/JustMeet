import 'package:justmeet_frontend/models/user.dart';

class UserState {
  final User currentUser;

  UserState({this.currentUser});

  factory UserState.initial() {
    return UserState(currentUser: new User());
  }

  UserState copyWith({User currentUser}) {
    return UserState(currentUser: currentUser ?? this.currentUser);
  }
}
