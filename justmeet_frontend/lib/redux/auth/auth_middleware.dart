
import 'package:flutter/cupertino.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_actions.dart';
import 'package:justmeet_frontend/repositories/user_repository.dart';
import 'package:redux/redux.dart';
import "package:flutter/services.dart";
import '../../routes.dart';

List<Middleware<AppState>> createAuthenticationMiddleware(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey
) {
  return [
    TypedMiddleware<AppState, VerifyAuthenticationState>(
      _verifyAuthState(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogOut>(
      _authLogOut(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogIn>(_authLogIn(userRepository, navigatorKey)),
    TypedMiddleware<AppState, LogInWithGoogle>(_authLogInWithGoogle(userRepository, navigatorKey)),
    TypedMiddleware<AppState, SignIn>(_signInWithEmailAndPassword(userRepository, navigatorKey))
  ];
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next
) _signInWithEmailAndPassword(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey
) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.createUserWithEmailAndPassword(action.email, action.password);
      await navigatorKey.currentState.pushReplacementNamed(Routes.login);
      action.completer.complete();
    }
    catch(e) {
      print('Login failed: $e');
      action.completer.completeError(e);
    }
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next
) _authLogInWithGoogle(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey
) {
  return (store, action, next) async {
    next(action);
    try {
      final user = await userRepository.signInWithGoogle();
      store.dispatch(OnAuthenticated(user: user));
      await navigatorKey.currentState.pushReplacementNamed(Routes.home);
    }
    on PlatformException catch(e) {
      print('Login failed: $e');
    }
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next
) _authLogIn(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey
) {
  return (store, action, next) async{
    next(action);
    try{
      final user = await userRepository.signInWithEmailAndPassword(action.email, action.password);
      store.dispatch(OnAuthenticated(user: user));
      await navigatorKey.currentState.pushReplacementNamed(Routes.home);
      action.completer.complete();
    }
     on PlatformException catch (e){
      print('Login failed: $e');
      action.completer.completeError(e);
    }
  };
}

void Function(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next
) _authLogOut(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey
) {
  return (store, action, next) async {
    next(action);
    try {
      await userRepository.signOut();
      store.dispatch(OnLogOutSuccess());
    }
    catch (e) {
      store.dispatch(OnLogOutFail(e));
    }
  };
}

void Function(
  Store<AppState> store,
  VerifyAuthenticationState action,
  NextDispatcher next
) _verifyAuthState(
  UserRepository userRepository,
  GlobalKey<NavigatorState> navigatorKey
) {
  return (store, action, next) {
    next(action);

    userRepository.getAuthenticationStateChange().listen((user) async{
      if(user == null) {
        await navigatorKey.currentState.pushReplacementNamed(Routes.login);
      }else {
        store.dispatch(OnAuthenticated(user: user));
        navigatorKey.currentState.pushReplacementNamed(Routes.home);
      }
    });
  };
}