
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/attachment/attachment_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final EventState eventState;
  final AttachmentState attachmentState;

  AppState({
    this.authState,
    this.eventState,
    this.attachmentState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      eventState: EventState.initial(),
      attachmentState: AttachmentState.initial()
    );
  }

  AppState copyWith({
    AuthState authState,
    EventState eventState,
    AttachmentState attachmentState
  }) {
    return AppState(
      authState: authState ?? this.authState,
      eventState: eventState ?? this.eventState,
      attachmentState: attachmentState ?? this.attachmentState
    );
  }
}
