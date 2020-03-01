
import 'package:flutter/cupertino.dart';
import 'package:justmeet_frontend/redux/app/app_reducer.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_middleware.dart';
import 'package:justmeet_frontend/repository/user_repository.dart';
import 'package:redux/redux.dart';

Store<AppState> createStore(UserRepository userRepository, GlobalKey<NavigatorState> navigatorKey) {
  return Store(
      appReducer,
      initialState: AppState.initial(),
      middleware: []
        ..addAll(createAuthenticationMiddleware(userRepository, navigatorKey))
  );
}