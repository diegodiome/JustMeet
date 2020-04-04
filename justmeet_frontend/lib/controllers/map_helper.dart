import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justmeet_frontend/widgets/map/uuid.dart';

enum MAP_STYLE { DARK, LIGHT, GREEN }

extension mapExtension on MAP_STYLE {
  String get resource {
    switch (this) {
      case MAP_STYLE.DARK:
        return 'assets/json_assets/dark_map.txt';
      case MAP_STYLE.LIGHT:
        return 'assets/json_assets/silver_map.txt';
      case MAP_STYLE.GREEN:
        return 'assets/json_assets/green_map.txt';
      default:
        return null;
    }
  }
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
