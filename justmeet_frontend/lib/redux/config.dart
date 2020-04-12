const String protocol = 'http';
const String backendIp = '192.168.1.4';
const String backendPort = '9000';
const String mapApiKey = 'AIzaSyDA9Tu-nptJSl2CWJ-o_vH8fQr85wnqY5Y';

const String baseUrl = '$protocol://$backendIp:$backendPort';

const String apiUrl = '$baseUrl';

/* EVENT API */
const String eventApiUrl = '$apiUrl/event';
const String getAllEventsUrl = '$eventApiUrl/all';
const String postCreateEventUrl = '$eventApiUrl/add';

String getPostJoinEventUrl(String eventId, String email) {
  return '$eventApiUrl/join/id=$eventId&displayName=$email';
}

/* COMMENT API */
const String commentApiUrl = '$eventApiUrl/comments';

String getAllCommentByUrl(String eventId) {
  return '$commentApiUrl/eventId=$eventId/all';
}

/* USER API */
const String userApiUrl = '$apiUrl/user';
const String postCreateUserApiUrl = '$userApiUrl/signUp';
const String putUpdateUserApiUrl = '$userApiUrl/update';

String putUpdateUserStatus(String userUid, String status) {
  return '$userApiUrl/$userUid&$status/supdate';
}

String putUpdateUserToken(String userUid, String token) {
  return '$userApiUrl/$userUid&$token/tupdate';
}

/* GOOGLE MAP API*/
const String mapApiUrl = 'https://maps.googleapis.com/maps/api';

String getReverseGeocodeUrl(double latitude, double longitude) {
  return '$mapApiUrl' +
      '/geocode/json?' +
      'latlng=$latitude,$longitude&' +
      'key=$mapApiKey';
}

String getDecodeSelectPlaceUrl(String placeId) {
  return '$mapApiUrl' +
      '/place/details/json?key=$mapApiKey' +
      '&placeid=$placeId';
}

String getAutoCompleteSearchUrl(String place, String sessionToken) {
  return '$mapApiUrl' +
      '/place/autocomplete/json?' +
      'key=$mapApiKey&' +
      'input={$place}&sessiontoken=$sessionToken';
}
