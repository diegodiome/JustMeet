const String protocol = 'http';
const String backendIp = '192.168.1.4';
const String backendPort = '9000';
const String mapApiKey = 'AIzaSyD2B72q-OlcROlnHi7DOQf3VCS6e9-OqdE';

const String baseUrl = '$protocol://$backendIp:$backendPort';

const String apiUrl = '$baseUrl/api/v1';

/* EVENT API */
const String eventApiUrl = '$apiUrl/events';
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
const String postUpdateUserApiUrl = '$apiUrl/user/update';

String postUpdateUserStatus(String userUid, String status) {
  return '$apiUrl/user/update/userUid=$userUid&status=$status';
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
