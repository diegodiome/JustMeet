import 'dart:async';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/event_reporting.dart';

class AddNewEvent {
  final Event event;
  final Completer completer;

  AddNewEvent({
    this.event,
    Completer completer
  }) : completer = completer ?? Completer();
}

class OnEventListUpdate {
  Completer completer;

  OnEventListUpdate({Completer completer}) : completer = completer ?? Completer();
}

class OnEventListUpdateSuccess {
  final List<Event> eventsList;
  final int eventCount;

  OnEventListUpdateSuccess({
    this.eventsList,
    this.eventCount
  });
}

class OnFilterEventUpdate {
  Completer completer;

  OnFilterEventUpdate({
    Completer completer
  }) : completer = completer ?? Completer();
}

class OnAddRequest {
  String userId;
  String eventId;

  OnAddRequest({
    this.userId,
    this.eventId,
  });
}

class OnJoinEvent {
  Completer completer;
  String userId;
  String eventId;

  OnJoinEvent({
    this.userId,
    this.eventId,
    Completer completer
  }) : completer = completer ?? Completer();
}

class OnEventReporting {
  EventReporting reporting;

  OnEventReporting({this.reporting});
}

class OnCreateEvent {
  Completer completer;
  Event newEvent;

  OnCreateEvent({
    this.newEvent,
    Completer completer}) : completer = completer ?? Completer();
}