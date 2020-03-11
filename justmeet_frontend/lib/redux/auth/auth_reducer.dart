import 'package:justmeet_frontend/redux/auth/auth_actions.dart';
import 'package:justmeet_frontend/redux/auth/auth_state.dart';
import 'package:redux/redux.dart';

final authReducers = combineReducers<AuthState>([
  TypedReducer<AuthState, OnAuthenticated>(_onAuthenticated),
  TypedReducer<AuthState, OnLogOutSuccess>(_onLogout)
]);

AuthState _onAuthenticated(AuthState state, OnAuthenticated action) {
  return state.copyWith(
    isAuthenticated: action.user != null,
    uid: action.user.uid
  );
}

AuthState _onLogout(AuthState state, OnLogOutSuccess action) {
  return state.copyWith(
    isAuthenticated: false,
    uid: ''
  );
}