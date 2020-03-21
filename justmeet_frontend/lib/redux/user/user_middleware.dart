import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/repositories/user_repository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUserMiddleware(
    UserRepository userRepository, GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, OnUserStatusUpdate>(
      _onUserStatusUpdate(userRepository)),
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