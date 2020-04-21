
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/redux/user/user_state.dart';
import 'package:redux/redux.dart';

final userReducers = combineReducers<UserState>([
  TypedReducer<UserState, OnLocalUserUpdateSuccess>(_onLocalUserUpdateSuccess)
]);

UserState _onLocalUserUpdateSuccess(UserState state, OnLocalUserUpdateSuccess action) {
  return state.copyWith(
    currentUser: action.userUpdated
  );
}



