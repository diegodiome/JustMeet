import 'dart:async';
import 'package:justmeet_frontend/models/event_list_data.dart';

class AddNewEvent {
  final EventListData event;
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
  final List<EventListData> eventsList;
  final int eventCount;

  OnEventListUpdateSuccess({
    this.eventsList,
    this.eventCount
  });
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
  EventListData newEvent;

  OnCreateEvent({
    this.newEvent,
    Completer completer}) : completer = completer ?? Completer();
}