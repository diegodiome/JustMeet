import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/repositories/user_repository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUserMiddleware(
    UserRepository userRepository, GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, OnUserStatusUpdate>(
        _onUserStatusUpdate(userRepository)),
    TypedMiddleware<AppState, OnLocalUserUpdate>(
        _onLocalUserUpdate(userRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onUserStatusUpdate(
  UserRepository userRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.updateUserStatus(action.status);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onLocalUserUpdate(
  UserRepository userRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      User userUpdated = await userRepository.getUser(action.userId);
      store.dispatch(OnLocalUserUpdateSuccess(userUpdated: userUpdated));
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}
