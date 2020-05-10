
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justmeet_frontend/redux/location/location_action.dart';
import 'package:redux/redux.dart';
import 'location_state.dart';

final locationReducers = combineReducers<LocationState>([
  TypedReducer<LocationState, OnLocationChanged>(_onLocationChanged)
]);

LocationState _onLocationChanged(LocationState state, OnLocationChanged action) {
  return state.copyWith(
    currentLocation: new LatLng(action.newLocation.latitude, action.newLocation.longitude)
  );
}