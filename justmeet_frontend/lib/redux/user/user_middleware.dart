import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event_request.dart';
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
    TypedMiddleware<AppState, OnUpdateUser>(
        _onUserUpdate(userRepository)),
    TypedMiddleware<AppState, OnUserReporting>(
        _onReportingUser(userRepository)),
    TypedMiddleware<AppState, OnUserRequestsListUpdate>(
        _onUserRequestsListUpdate(userRepository)),
    TypedMiddleware<AppState, OnUserAcceptRequest>(
        _onUserAcceptRequest(userRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onUserAcceptRequest(
    UserRepository userRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.acceptRequest(action.userId, action.eventId);
      await store.dispatch(OnUserRequestsListUpdate(userId: store.state.userState.currentUser.userUid));
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onUserUpdate(
    UserRepository userRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.updateUser(action.userUpdated);
      await store.dispatch(OnLocalUserUpdate(userId: store.state.userState.currentUser.userUid));
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onUserRequestsListUpdate(
    UserRepository userRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      List<EventRequest> requests =  await userRepository.getRequests(action.userId);
      await store.dispatch(OnUserReuqestsListUpdateSuccess(requestsUpdate: requests));
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onReportingUser(
    UserRepository userRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.addUserReporting(action.userReporting);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
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
      await store.dispatch(OnLocalUserUpdateSuccess(userUpdated: userUpdated));
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}
