import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';
import 'package:justmeet_frontend/redux/comment/comment_state.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';
import 'package:justmeet_frontend/redux/filters/filters_state.dart';
import 'package:justmeet_frontend/redux/location/location_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final EventState eventState;
  final CommentState commentState;
  final LocationState locationState;
  final FiltersState filtersState;

  AppState({
    this.authState,
    this.eventState,
    this.commentState,
    this.locationState,
    this.filtersState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      eventState: EventState.initial(),
      commentState: CommentState.initial(),
      locationState: LocationState.initial(),
      filtersState: FiltersState.initial()
    );
  }

  AppState copyWith({
    AuthState authState,
    EventState eventState,
    LocationState locationState,
    CommentState commentState,
    FiltersState filtersState
  }) {
    return AppState(
      authState: authState ?? this.authState,
      eventState: eventState ?? this.eventState,
      commentState: commentState ?? this.commentState,
      locationState: locationState ?? this.locationState,
      filtersState: filtersState ?? this.filtersState
    );
  }
}
