import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:justmeet_frontend/controllers/map_helper.dart';
import 'package:justmeet_frontend/redux/config.dart';

class MapRepository {
  Future<MapLocationResult> getReverseGeocodeLatLng(
      double latitude, double longitude) async {
    Response response;
    response = await get(
      getReverseGeocodeUrl(latitude, longitude),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      final result = responseJson['results'][0];
      MapLocationResult locationResult =
          MapLocationResult.fromReverseGeocodeJson(result);
      locationResult.latLng = new LatLng(latitude, longitude);
      return locationResult;
    }
    return Future.value(null);
  }

  Future<LatLng> getDecodeSelectPlace(String placeId) async {
    Response response;
    response = await get(getDecodeSelectPlaceUrl(placeId));
    if (response.statusCode == 200) {
      Map<String, dynamic> location =
          jsonDecode(response.body)['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    }
    return Future.value(null);
  }

  Future<List<dynamic>> getAutoCompleteSearch(String place, String sessionToken,
      {String optionalString}) async {
    Response response;
    response = await get(
        getAutoCompleteSearchUrl(place, sessionToken) + optionalString);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['predictions'];
    }
    return Future.value(null);
  }
}
