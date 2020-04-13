
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';

@immutable
class EventState {

  final int eventsCount;
  final List<Event> eventsList;

  EventState({
    this.eventsList,
    this.eventsCount
  });

  factory EventState.initial() {
    return new EventState(
      eventsList: new List<Event>(),
      eventsCount: 0
    );
  }

  EventState copyWith({
    int eventsCount,
    List<Event> eventsList
  }) {
    return new EventState(
      eventsList: eventsList ?? this.eventsList,
      eventsCount: eventsCount ?? this.eventsCount
    );
  }
}