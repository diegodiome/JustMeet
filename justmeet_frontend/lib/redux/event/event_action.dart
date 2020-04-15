import 'dart:async';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/filter_data.dart';

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
  final List<FilterData> filters;
  Completer completer;

  OnFilterEventUpdate({
    this.filters,
    Completer completer
  }) : completer = completer ?? Completer();
}

class OnJoinEvent {
  Completer completer;
  String email;
  String eventId;

  OnJoinEvent({
    this.email,
    this.eventId,
    Completer completer
  }) : completer = completer ?? Completer();
}

class OnCreateEvent {
  Completer completer;
  Event newEvent;

  OnCreateEvent({
    this.newEvent,
    Completer completer}) : completer = completer ?? Completer();
}