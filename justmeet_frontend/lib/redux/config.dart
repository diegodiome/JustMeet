
String protocol = 'http';
String backendIp = '192.168.1.9';
String backendPort = '9000';

String baseUrl = '$protocol://$backendIp:$backendPort'; 

String apiUrl = '$baseUrl/api/v1';

/* EVENT API */
String eventApiUrl = '$apiUrl/events';
String getAllEventsUrl = '$eventApiUrl/all';
