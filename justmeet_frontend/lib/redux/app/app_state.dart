import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final EventState eventState;

  AppState({
    this.authState,
    this.eventState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      eventState: EventState.initial()
    );
  }

  AppState copyWith({
    AuthState authState,
    EventState eventState,
  }) {
    return AppState(
      authState: authState ?? this.authState,
      eventState: eventState ?? this.eventState
    );
  }
}
