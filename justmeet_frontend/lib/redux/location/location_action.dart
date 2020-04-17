
import 'package:location/location.dart';

class VerifyCurrentLocationState {}

class OnLocationChanged {
  LocationData newLocation;

  OnLocationChanged({this.newLocation});
}