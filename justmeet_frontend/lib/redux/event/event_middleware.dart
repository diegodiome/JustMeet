import 'package:flutter/cupertino.dart';
import 'package:justmeet_frontend/models/event.dart';
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
        _onFilterEventUpdate(navigatorKey)),
    TypedMiddleware<AppState, OnEventReporting>(
        _onReportingEvent(navigatorKey, eventRepository)
    ),
    TypedMiddleware<AppState, OnAddRequest>(
        _onAddRequest(eventRepository)
    ),
    TypedMiddleware<AppState, OnAddRate>(
        _onAddRate(eventRepository)
    ),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onAddRate(
    EventRepository eventRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await eventRepository.addRate(action.eventId, action.rate);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onAddRequest(
    EventRepository eventRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await eventRepository.addRequest(action.eventId, action.userId);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onFilterEventUpdate(
  GlobalKey<NavigatorState> navigatorKey,
) {
  return (store, action, next) async {
    next(action);
    try {
      store.state.eventState.eventsFiltered.clear();
      store.state.eventState.eventsList.forEach((event) => {
        store.state.filtersState.categoriesFilter
            .where((filter) => filter.isSelected)
            .toList()
            .forEach((filter) => {
              if(filter.titleTxt.compareTo(event.eventCategory) == 0) {
                if(event.eventDate.isAfter(store.state.filtersState.dateFilterData.startDate) && event.eventDate.isBefore(store.state.filtersState.dateFilterData.endDate.add(Duration(days: 1)))) {
                  if(eventDistanceCalculator(
                      store.state.locationState.currentLocation.latitude,
                      store.state.locationState.currentLocation.longitude,
                      event.eventLat,
                      event.eventLong,
                      'K') <= store.state.filtersState.distanceFilter.maxDistance / 10) {
                    store.state.eventState.eventsFiltered.add(event)
                  }
                  else if(store.state.locationState.currentLocation.latitude == 0 && store.state.locationState.currentLocation.longitude == 0) {
                    store.state.eventState.eventsFiltered.add(event)
                  }
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
_onReportingEvent(
    GlobalKey<NavigatorState> navigatorKey,
    EventRepository eventRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await eventRepository.addReporting(action.reporting);
    } on PlatformException catch (e) {
      print('Error: $e');
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
      await eventRepository.joinEvent(action.eventId, action.userId);
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
      store.dispatch(OnFilterEventUpdate());
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}
