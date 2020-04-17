import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_reducer.dart';
import 'package:justmeet_frontend/redux/comment/comment_reducer.dart';
import 'package:justmeet_frontend/redux/event/event_reducer.dart';
import 'package:justmeet_frontend/redux/filters/filters_reducer.dart';
import 'package:justmeet_frontend/redux/location/location_reducer.dart';

AppState appReducer(state, action) {
  return new AppState(
    authState: authReducers(state.authState , action),
    eventState: eventReducers(state.eventState, action),
    commentState: commentsReducers(state.commentState, action),
    locationState: locationReducers(state.locationState, action),
    filtersState: filtersReducers(state.filtersState, action)
  );
}