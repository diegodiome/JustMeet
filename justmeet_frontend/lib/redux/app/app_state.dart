import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';
import 'package:justmeet_frontend/redux/comment/comment_state.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final EventState eventState;
  final CommentState commentState;

  AppState({
    this.authState,
    this.eventState,
    this.commentState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      eventState: EventState.initial(),
      commentState: CommentState.initial()
    );
  }

  AppState copyWith({
    AuthState authState,
    EventState eventState,
    CommentState commentState
  }) {
    return AppState(
      authState: authState ?? this.authState,
      eventState: eventState ?? this.eventState,
      commentState: commentState ?? this.commentState
    );
  }
}
