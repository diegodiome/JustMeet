import 'package:flutter/cupertino.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/repository/event_repository.dart';
import "package:flutter/services.dart";
import 'package:redux/redux.dart';

List<Middleware<AppState>> createEventMiddleware(
    EventRepository eventRepository, GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, OnEventListUpdate>(
        _eventListUpdate(eventRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _eventListUpdate(
  EventRepository eventRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final List<EventListData> eventList =
          await eventRepository.getAllEvents();
      store.dispatch(OnEventListUpdateSuccess(
          eventsList: eventList, eventCount: eventList.length));
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}
