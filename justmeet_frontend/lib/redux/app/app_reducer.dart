import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_reducer.dart';
import 'package:justmeet_frontend/redux/event/event_reducer.dart';

AppState appReducer(state, action) {
  return new AppState(
    authState: authReducers(state.authState , action),
    eventState: eventReducers(state.eventState, action)
  );
}