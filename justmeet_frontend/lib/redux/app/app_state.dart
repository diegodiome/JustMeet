import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';
import 'package:justmeet_frontend/redux/comment/comment_state.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';
import 'package:justmeet_frontend/redux/filters/filters_state.dart';
import 'package:justmeet_frontend/redux/location/location_state.dart';
import 'package:justmeet_frontend/redux/menu/menu_state.dart';
import 'package:justmeet_frontend/redux/user/user_state.dart';

@immutable
class AppState {
  final AuthState authState;
  final EventState eventState;
  final CommentState commentState;
  final LocationState locationState;
  final FiltersState filtersState;
  final UserState userState;
  final MenuState menuState;

  AppState({
    this.authState,
    this.eventState,
    this.commentState,
    this.locationState,
    this.filtersState,
    this.userState,
    this.menuState
  });

  factory AppState.initial() {
    return AppState(
      authState: AuthState.initial(),
      eventState: EventState.initial(),
      commentState: CommentState.initial(),
      locationState: LocationState.initial(),
      filtersState: FiltersState.initial(),
      userState: UserState.initial(),
      menuState: MenuState.initial()
    );
  }

  AppState copyWith({
    AuthState authState,
    EventState eventState,
    LocationState locationState,
    CommentState commentState,
    FiltersState filtersState,
    UserState userState,
    MenuState menuState
  }) {
    return AppState(
      authState: authState ?? this.authState,
      eventState: eventState ?? this.eventState,
      commentState: commentState ?? this.commentState,
      locationState: locationState ?? this.locationState,
      filtersState: filtersState ?? this.filtersState,
      userState: userState ?? this.userState,
      menuState: menuState ?? this.menuState
    );
  }
}
