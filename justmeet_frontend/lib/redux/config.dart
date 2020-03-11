
const String protocol = 'http';
const String backendIp = '192.168.1.9';
const String backendPort = '9000';

const String baseUrl = '$protocol://$backendIp:$backendPort'; 

const String apiUrl = '$baseUrl/api/v1';

/* EVENT API */
const String eventApiUrl = '$apiUrl/events';
const String getAllEventsUrl = '$eventApiUrl/all';
const String postCreateEventUrl = '$eventApiUrl/add';

String getPostJoinEventUrl(String eventId, String email) {
  return '$eventApiUrl/join/id=$eventId&displayName=$email';
}
