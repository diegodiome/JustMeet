

import 'dart:async';
import 'package:justmeet_frontend/model/event_list_data.dart';

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