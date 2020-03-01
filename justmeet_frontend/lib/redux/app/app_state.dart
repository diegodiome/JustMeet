
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';

@immutable
class AppState {
  final AuthState authState;

  AppState({
    this.authState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial()
    );
  }

  AppState copyWith({
    AuthState authState
  }) {
    return AppState(
      authState: authState ?? this.authState
    );
  }
}
