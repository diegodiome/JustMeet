import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justmeet_frontend/widgets/map/uuid.dart';
import 'package:location/location.dart';

enum MAP_STYLE { DARK, LIGHT, GREEN }

extension mapExtension on MAP_STYLE {
  String get resource {
    switch (this) {
      case MAP_STYLE.DARK:
        return 'assets/json_assets/dark_map.txt';
      case MAP_STYLE.LIGHT:
        return 'assets/json_assets/silver_map.txt';
      case MAP_STYLE.GREEN:
        return 'assets/json_assets/purple_map.txt';
      default:
        return null;
    }
  }
}

Future<LatLng> getCurrentPosition() async {
    LocationData currentLocation = await Location().getLocation();
    return new LatLng(currentLocation.latitude, currentLocation.longitude);
 }

/*
*  K = kilometers
*  N = nautical miles
*/
double eventDistanceCalculator(
    double lat1, double lon1, double lat2, double lon2, String unit) {
  double theta = lon1 - lon2;
  double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
  dist = acos(dist);
  dist = rad2deg(dist);
  dist = dist * 60 * 1.1515;
  if (unit == 'K') {
    dist = dist * 1.609344;
  } else if (unit == 'N') {
    dist = dist * 0.8684;
  }
  print(dist);
  return dist;//.toStringAsFixed(2);
}

double deg2rad(double deg) {
  return (deg * pi / 180.0);
}

double rad2deg(double rad) {
  return (rad * 180.0 / pi);
}

CameraPosition get initialCameraPosition => CameraPosition(
      target: LatLng(43.307161, 13.728369),
      zoom: 14.0000,
    );

// Load custom marker
Future<BitmapDescriptor> get markerIconAsset async =>
    await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(24, 24)), 'assets/images/marker.png');

// Generate map session code
String get mapSessionCode => Uuid().generateV4();

class MapLocationResult {
  String name;

  String locality;

  LatLng latLng;

  String formattedAddress;

  MapAddressComponent city;

  String placeId;

  MapLocationResult(
      {this.city,
      this.placeId,
      this.formattedAddress,
      this.latLng,
      this.locality,
      this.name});

  MapLocationResult.fromReverseGeocodeJson(Map<String, dynamic> json) {
    name = json['address_components'][0]['short_name'];
    locality = json['address_components'][1]['short_name'];
    formattedAddress = json['formatted_address'];
    placeId = json['place_id'];
    city = MapAddressComponent(
      json['address_components'][3]['long_name'],
      json['address_components'][3]['short_name'],
    );
  }
}

class MapAddressComponent {
  String name;
  String shortName;

  MapAddressComponent(
    this.name,
    this.shortName,
  );
}

class MapAutoCompleteItem {
  String id;

  String text;

  int offset;

  int length;
}
