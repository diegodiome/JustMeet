import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

class MapPage extends StatefulWidget {
  final MAP_STYLE mapStyle;
  final bool fixed;
  MapPage({@required this.mapStyle, @required this.fixed});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _mapController = Completer();
  String _mapStyle;

  @override
  void initState() {
    super.initState();
    rootBundle.loadString(widget.mapStyle.resource).then((string) {
      _mapStyle = string;
    });
  }

  final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(43.307161, 13.728369),
    zoom: 14.0000,
  );

  Widget buildMap() {
    switch (widget.fixed) {
      case true:
        return GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          initialCameraPosition: _initialCamera,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
            controller.setMapStyle(_mapStyle);
          },
        );
        break;
      case false:
        return GoogleMap(
          myLocationEnabled: true,
          mapType: MapType.normal,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          initialCameraPosition: _initialCamera,
          onMapCreated: (GoogleMapController controller) {
            _mapController.complete(controller);
            controller.setMapStyle(_mapStyle);
          },
        );
        break;
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          buildMap(),
        ],
      ),
    );
  }
}
