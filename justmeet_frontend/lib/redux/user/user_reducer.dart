
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/redux/user/user_state.dart';
import 'package:redux/redux.dart';

final userReducers = combineReducers<UserState>([
  TypedReducer<UserState, OnLocalUserUpdateSuccess>(_onLocalUserUpdateSuccess),
  TypedReducer<UserState, OnUserReuqestsListUpdateSuccess>(_onUserReuqestsListUpdateSuccess)
]);

UserState _onLocalUserUpdateSuccess(UserState state, OnLocalUserUpdateSuccess action) {
  return state.copyWith(
    currentUser: action.userUpdated
  );
}

UserState _onUserReuqestsListUpdateSuccess(UserState state, OnUserReuqestsListUpdateSuccess action) {
  return state.copyWith(
      requests: action.requestsUpdate
  );
}



