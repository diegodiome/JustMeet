import 'dart:convert';
import 'package:http/http.dart';
import 'package:justmeet_frontend/models/event_reporting.dart';
import 'package:justmeet_frontend/utils/request_header.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/redux/config.dart';

class EventRepository {
  Future<List<Event>> getAllEvents() async {
    Response response;
    response = await get(getAllEventsUrl,
        headers: await RequestHeader().getBasicHeader());
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Iterable<dynamic> l = json.decode(response.body);
      return l.map((model) => Event.fromJson(model)).toList();
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }

  Future<Event> getEvent(String eventId) async {
    Response response;
    response = await get(
        getEventUrl(eventId),
        headers: await RequestHeader().getBasicHeader());
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }

  Future<void> createNewEvent(Event newEvent) async {
    Response response;
    response = await post(postCreateEventUrl,
        headers: await RequestHeader().getBasicHeader(),
        body: newEvent.toJson());
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<void> addRequest(String userId, String eventId) async {
    Response response;
    response = await put(
        putAddRequestUrl(eventId, userId),
        headers: await RequestHeader().getBasicHeader());
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<void> addReporting(EventReporting reporting) async {
    Response response;
    response = await post(
        postCreateEventReportingUrl,
        headers: await RequestHeader().getBasicHeader(),
        body: reporting.toJson());
    int statusCode = response.statusCode;
    if (statusCode != 200) {
    print('Connection error: $statusCode');
    }
  }

  Future<void> joinEvent(String eventId, String userId) async {
    Response response;
    response = await put(
      postJoinEventUrl(eventId, userId),
      headers: await RequestHeader().getBasicHeader(),
    );
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<List<Event>> getUserEvents(String userId) async {
    Response response;
    response = await get(
        getUserEventsUrl(userId),
        headers: await RequestHeader().getBasicHeader()
    );
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      Iterable<dynamic> l = json.decode(response.body);
      return l.map((model) => Event.fromJson(model)).toList();
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }

  Future<List<dynamic>> getEventPredictions(String text) async {
    Response response;
    response = await get(getPredictionsUrl(text),
        headers: await RequestHeader().getBasicHeader());
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data["predictions"];
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }
}
