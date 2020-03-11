
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';

@immutable
class EventState {

  final int eventsCount;
  final List<EventListData> eventsList;

  EventState({
    this.eventsList,
    this.eventsCount
  });

  factory EventState.initial() {
    return new EventState(
      eventsList: new List<EventListData>(),
      eventsCount: 0
    );
  }

  EventState copyWith({
    int eventsCount,
    List<EventListData> eventsList
  }) {
    return new EventState(
      eventsList: eventsList ?? this.eventsList,
      eventsCount: eventsCount ?? this.eventsCount
    );
  }
}