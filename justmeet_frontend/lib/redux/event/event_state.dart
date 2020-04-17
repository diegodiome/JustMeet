
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';

@immutable
class EventState {

  final int eventsCount;
  final List<Event> eventsList;
  final List<Event> eventsFiltered;

  EventState({
    this.eventsList,
    this.eventsCount,
    this.eventsFiltered,
  });

  factory EventState.initial() {
    return new EventState(
      eventsList: new List<Event>(),
      eventsCount: 0,
      eventsFiltered: new List<Event>(),
    );
  }

  EventState copyWith({

    int eventsCount,
    List<Event> eventsList,
    List<Event> eventsFiltered,

  }) {
    return new EventState(
      eventsList: eventsList ?? this.eventsList,
      eventsCount: eventsCount ?? this.eventsCount,
      eventsFiltered: eventsFiltered ?? this.eventsFiltered,
    );
  }
}