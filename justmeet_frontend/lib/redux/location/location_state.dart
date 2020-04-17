import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
class LocationState {
  final LatLng currentLocation;

  LocationState({this.currentLocation});

  factory LocationState.initial() {
    return new LocationState(currentLocation: new LatLng(0.0, 0.0));
  }

  LocationState copyWith({LatLng currentLocation}) {
    return new LocationState(
        currentLocation: currentLocation ?? this.currentLocation);
  }
}
