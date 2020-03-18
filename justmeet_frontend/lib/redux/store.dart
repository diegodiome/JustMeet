import 'package:flutter/cupertino.dart';
import 'package:justmeet_frontend/redux/app/app_reducer.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_middleware.dart';
import 'package:justmeet_frontend/redux/event/event_middleware.dart';
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/repositories/user_repository.dart';
import 'package:redux/redux.dart';

Store<AppState> createStore(
  UserRepository userRepository, 
  EventRepository eventRepository,
  GlobalKey<NavigatorState> navigatorKey) {
  return Store(
      appReducer,
      initialState: AppState.initial(),
      middleware: []
        ..addAll(createAuthenticationMiddleware(userRepository, navigatorKey))
        ..addAll(createEventMiddleware(eventRepository, navigatorKey))
  );
}