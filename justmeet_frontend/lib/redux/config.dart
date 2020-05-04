
const String protocol = 'http';
const String backendIp = '192.168.1.4';
const String backendPort = '9000';
const String mapApiKey = 'AIzaSyDA9Tu-nptJSl2CWJ-o_vH8fQr85wnqY5Y';

const String baseUrl = '$protocol://$backendIp:$backendPort';

const String apiUrl = '$baseUrl';

/* EVENT API */
const String eventApiUrl = '$apiUrl/event';
const String getAllEventsUrl = '$eventApiUrl/all';
const String postCreateEventUrl = '$eventApiUrl/create';
const String postCreateEventReportingUrl = '$eventApiUrl/reporting';

String putAddRateUrl(String eventId, double rate) {
  return '$eventApiUrl/$eventId/$rate/rate';
}

String putAddRequestUrl(String userId, String eventId) {
  return '$eventApiUrl/$eventId/$userId/request';
}

String postJoinEventUrl(String eventId, String userId) {
  return '$eventApiUrl/$eventId/$userId/join';
}

String getEventUrl(String eventId) {
  return '$eventApiUrl/$eventId';
}

String getPredictionsUrl(String text) {
  return '$apiUrl/app/$text/predictions';
}

/* COMMENT API */
const String commentApiUrl = '$eventApiUrl/comments';

String getAllCommentByUrl(String eventId) {
  return '$eventApiUrl/$eventId/comments';
}

String postCreateCommentUrl(String eventId) {
  return '$eventApiUrl/$eventId/comment';
}

/* USER API */
const String userApiUrl = '$apiUrl/user';
const String postCreateUserApiUrl = '$userApiUrl/signUp';
const String putUpdateUserApiUrl = '$userApiUrl/update';
const String postAddUserReportingUrl = '$userApiUrl/reporting';

String getRequestsUrl(String userId) {
  return '$userApiUrl/$userId/requests';
}

String putUpdateUserStatusUrl(String userUid, String status) {
  return '$userApiUrl/$userUid&$status/supdate';
}

String putUpdateUserTokenUrl(String userUid, String token) {
  return '$userApiUrl/$userUid&$token/tupdate';
}

String getUserUrl(String userId) {
  return '$userApiUrl/$userId';
}

String getUserEventsUrl(String userId) {
  return '$userApiUrl/$userId/events';
}

String putAcceptRequestUrl(String userId, String eventId) {
  return '$userApiUrl/$eventId/$userId/accept';
}

String putUpdateFcmToken(String userId, String fcmToken) {
  return '$userApiUrl/$userId/$fcmToken';
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
