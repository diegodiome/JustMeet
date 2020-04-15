
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/filter_data.dart';

@immutable
class EventState {

  final int eventsCount;
  final List<Event> eventsList;
  final List<Event> eventsFiltered;
  final List<FilterData> filters;

  EventState({
    this.eventsList,
    this.eventsCount,
    this.eventsFiltered,
    this.filters
  });

  factory EventState.initial() {
    return new EventState(
      eventsList: new List<Event>(),
      eventsCount: 0,
      filters: FilterData.defaultCategoriesList,
      eventsFiltered: new List<Event>(),
    );
  }

  EventState copyWith({

    int eventsCount,
    List<Event> eventsList,
    List<Event> eventsFiltered,
    List<FilterData> filters

  }) {
    return new EventState(
      eventsList: eventsList ?? this.eventsList,
      eventsCount: eventsCount ?? this.eventsCount,
      filters: filters ?? this.filters,
      eventsFiltered: eventsFiltered ?? this.eventsFiltered
    );
  }
}