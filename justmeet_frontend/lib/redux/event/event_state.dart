
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/filter_data.dart';
import 'package:justmeet_frontend/utils/map_helper.dart';

@immutable
class EventState {

  final int eventsCount;
  final List<Event> eventsList;
  final List<Event> eventsFiltered;
  final List<CategoryFilterData> categoryfilters;
  final DistanceFilterData distanceFilter;

  EventState({
    this.eventsList,
    this.eventsCount,
    this.eventsFiltered,
    this.categoryfilters,
    this.distanceFilter
  });

  factory EventState.initial() {
    return new EventState(
      eventsList: new List<Event>(),
      eventsCount: 0,
      categoryfilters: CategoryFilterData.defaultCategoriesList,
      eventsFiltered: new List<Event>(),
      distanceFilter: new DistanceFilterData(maxDistance: 0,)
    );
  }

  EventState copyWith({

    int eventsCount,
    List<Event> eventsList,
    List<Event> eventsFiltered,
    List<CategoryFilterData> filters,
    DistanceFilterData distanceFilter

  }) {
    return new EventState(
      eventsList: eventsList ?? this.eventsList,
      eventsCount: eventsCount ?? this.eventsCount,
      categoryfilters: filters ?? this.categoryfilters,
      eventsFiltered: eventsFiltered ?? this.eventsFiltered,
      distanceFilter: distanceFilter ?? this.distanceFilter
    );
  }
}