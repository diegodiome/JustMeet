import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:justmeet_frontend/models/autocomplete_item.dart';
import 'package:justmeet_frontend/utils/map_helper.dart';
import 'package:justmeet_frontend/repositories/map_repository.dart';
import 'package:justmeet_frontend/widgets/map/map_search_input.dart';
import 'package:location/location.dart';
import '../../models/rich_suggestion.dart';

class MapPage extends StatefulWidget {
  final MAP_STYLE mapStyle;
  final bool gestureEnabled;
  final bool searchInput;
  final Marker locationMarker;

  const MapPage({this.mapStyle, this.searchInput, this.gestureEnabled, this.locationMarker});

  @override
  State<StatefulWidget> createState() {
    return MapPageState();
  }
}

/// Place picker state
class MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> mapController = Completer();

  MapRepository mapRepository;

  /// Indicator for the selected location
  final Set<Marker> markers = Set();

  BitmapDescriptor markerIcon;

  /// Result returned after user completes selection
  MapLocationResult locationResult;

  /// Overlay to display autocomplete suggestions
  OverlayEntry overlayEntry;

  /// Session token required for autocomplete API call
  String sessionToken = mapSessionCode;

  GlobalKey searchBarKey = GlobalKey();

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  String _mapStyle;

  // constructor
  MapPageState();

  void onMapCreated(GoogleMapController controller) {
    this.mapController.complete(controller);
    controller.setMapStyle(_mapStyle);
    if(widget.locationMarker != null) {
      moveToLocation(widget.locationMarker.position);
      return;
    }
    moveToCurrentUserLocation();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    mapRepository = new MapRepository();
    // hide status bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    rootBundle.loadString(widget.mapStyle.resource).then((string) {
      _mapStyle = string;
    });
    markerIconAsset.then((value) {
      markerIcon = value;
    });
  }

  @override
  void dispose() {
    this.overlayEntry?.remove();
    // bring back status bar
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  Widget searchOverlay() {
    return MapSearchInput((it) {
      searchPlace(it);
    }, key: searchBarKey);
  }

  Widget locationResultUi() {
    if (widget.searchInput) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          SelectPlaceAction(getLocationName(), () {
            Navigator.of(context).pop(this.locationResult);
          })
        ],
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              zoomGesturesEnabled: widget.gestureEnabled,
              scrollGesturesEnabled: widget.gestureEnabled,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              onMapCreated: onMapCreated,
              onTap: (latLng) {
                clearOverlay();
                moveToLocation(latLng);
              },
              markers: markers,
            ),
          ),
          locationResultUi()
        ],
      ),
        widget.searchInput == true ? searchOverlay() : Container()
    ]));
  }

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (this.overlayEntry != null) {
      this.overlayEntry.remove();
      this.overlayEntry = null;
    }
  }

  void searchPlace(String place) {
    if (place == this.previousSearchTerm) {
      return;
    } else {
      previousSearchTerm = place;
    }

    if (context == null) {
      return;
    }

    clearOverlay();

    setState(() {
      hasSearchTerm = place.length > 0;
    });

    if (place.length < 1) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox =
        this.searchBarKey.currentContext.findRenderObject();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox.size.height,
        width: size.width,
        child: Material(
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Text(
                    "Finding place...",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(this.overlayEntry);
    autoCompleteSearch(place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String place) {
    place = place.replaceAll(" ", "+");
    String additionalString = '';

    if (this.locationResult != null) {
      additionalString += "&location=${this.locationResult.latLng.latitude}," +
          "${this.locationResult.latLng.longitude}";
    }

    mapRepository
        .getAutoCompleteSearch(place, sessionToken,
            optionalString: additionalString)
        .then((value) {
      List<dynamic> predictions = value;

      List<RichSuggestion> suggestions = [];

      if (predictions.isEmpty) {
        AutoCompleteItem aci = AutoCompleteItem();
        aci.text = "No result found";
        aci.offset = 0;
        aci.length = 0;

        suggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (dynamic t in predictions) {
          AutoCompleteItem aci = AutoCompleteItem();

          aci.id = t['place_id'];
          aci.text = t['description'];
          aci.offset = t['matched_substrings'][0]['offset'];
          aci.length = t['matched_substrings'][0]['length'];

          suggestions.add(RichSuggestion(aci, () {
            FocusScope.of(context).requestFocus(FocusNode());
            decodeAndSelectPlace(aci.id);
          }));
        }
      }

      displayAutoCompleteSuggestions(suggestions);
    }).catchError((error) {
      print(error);
    });
  }

  /// To navigate to the selected place from the autocomplete list to the map,
  /// the lat,lng is required. This method fetches the lat,lng of the place and
  /// proceeds to moving the map to that location.
  Future<void> decodeAndSelectPlace(String placeId) async {
    clearOverlay();
    moveToLocation(await mapRepository.getDecodeSelectPlace(placeId));
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox =
        this.searchBarKey.currentContext.findRenderObject();

    clearOverlay();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        top: appBarBox.size.height,
        child: Material(
          elevation: 1,
          child: Column(
            children: suggestions,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(this.overlayEntry);
  }

  String getLocationName() {
    if (this.locationResult == null) {
      return "Unnamed location";
    }

    return "${this.locationResult.name}, ${this.locationResult.locality}";
  }

  /// Moves the marker to the indicated lat,lng
  void setMarker(LatLng latLng) {
    // markers.clear();
    setState(() {
      markers.clear();
      markers.add(
        Marker(
            markerId: MarkerId("selected-location"),
            position: latLng,
            icon: markerIcon),
      );
    });
  }

  /// This method gets the human readable name of the location. Mostly appears
  /// to be the road name and the locality.
  void reverseGeocodeLatLng(LatLng latLng) {
    mapRepository
        .getReverseGeocodeLatLng(latLng.latitude, latLng.longitude)
        .then((value) {
      setState(() {
        this.locationResult = value;
      });
    });
  }

  /// Moves the camera to the provided location and updates other UI features to
  /// match the location.
  void moveToLocation(LatLng latLng) {
    this.mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 16.0,
          ),
        ),
      );
    });

    setMarker(latLng);

    reverseGeocodeLatLng(latLng);
  }

  void moveToCurrentUserLocation() {
    var location = Location();
    location.getLocation().then((locationData) {
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      moveToLocation(target);
    }).catchError((error) {
      print(error);
    });
  }
}

class SelectPlaceAction extends StatelessWidget {
  final String locationName;
  final VoidCallback onTap;

  SelectPlaceAction(this.locationName, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          this.onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      locationName,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Tap to select this location",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward,
              )
            ],
          ),
        ),
      ),
    );
  }
}
