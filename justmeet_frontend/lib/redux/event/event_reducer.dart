import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';
import 'package:redux/redux.dart';

final eventReducers = combineReducers<EventState>([
  TypedReducer<EventState, OnEventListUpdateSuccess>(_onEventListUpdateSuccess),
]);

EventState _onEventListUpdateSuccess(EventState state, OnEventListUpdateSuccess action) {
  return state.copyWith(
    eventsList: action.eventsList,
    eventsCount: action.eventCount
  );
}