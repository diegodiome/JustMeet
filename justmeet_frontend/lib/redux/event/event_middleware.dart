import 'package:flutter/cupertino.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/filter_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import "package:flutter/services.dart";
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/routes.dart';
import 'package:justmeet_frontend/utils/map_helper.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createEventMiddleware(
    EventRepository eventRepository, GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, OnEventListUpdate>(
        _eventListUpdate(eventRepository)),
    TypedMiddleware<AppState, OnCreateEvent>(
        _onCreateEvent(navigatorKey, eventRepository)),
    TypedMiddleware<AppState, OnJoinEvent>(
        _onJoinEvent(navigatorKey, eventRepository)),
    TypedMiddleware<AppState, OnFilterEventUpdate>(
        _onFilterEventUpdate(navigatorKey)
    ),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onFilterEventUpdate(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);
    try {
      store.state.eventState.eventsFiltered.clear();
      DistanceFilterData distanceFilter = action.distanceFilter;
      store.state.eventState.eventsList.forEach((event) => {
        store.state.eventState.categoryfilters
            .where((filter) => filter.isSelected)
            .toList()
            .forEach((filter) => {
              if(filter.titleTxt.compareTo(event.eventCategory) == 0) {
                if(distanceFilter.fromPosition != null && distanceFilter.maxDistance > 0) {
                  if(eventDistanceCalculator(
                      distanceFilter.fromPosition.latitude,
                      distanceFilter.fromPosition.longitude,
                      event.eventLat,
                      event.eventLong,
                      'K') <= distanceFilter.maxDistance) {
                    store.state.eventState.eventsFiltered.add(event)
                  }
                } else {
                  store.state.eventState.eventsFiltered.add(event)
                }
              }
        })
      });
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onJoinEvent(
  GlobalKey<NavigatorState> navigatorKey,
  EventRepository eventRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      await eventRepository.joinEvent(action.eventId, action.email);
      await navigatorKey.currentState.pushReplacementNamed(Routes.home);
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onCreateEvent(
  GlobalKey<NavigatorState> navigatorKey,
  EventRepository eventRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      await eventRepository.createNewEvent(action.newEvent);
      await navigatorKey.currentState.pushReplacementNamed(Routes.home);
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _eventListUpdate(
  EventRepository eventRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final List<Event> eventList = await eventRepository.getAllEvents();
      store.dispatch(OnEventListUpdateSuccess(
          eventsList: eventList, eventCount: eventList.length));
      store.dispatch(OnFilterEventUpdate(
        filters: store.state.eventState.categoryfilters,
        distanceFilter: store.state.eventState.distanceFilter
      ));
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}
