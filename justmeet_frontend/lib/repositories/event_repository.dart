import 'dart:convert';
import 'package:http/http.dart';
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

  Future<void> createNewEvent(Event newEvent) async {
    print(newEvent.toJson().toString());
    Response response;
    response = await post(postCreateEventUrl,
        headers: await RequestHeader().getBasicHeader(),
        body: newEvent.toJson());
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<void> joinEvent(String eventId, String email) async {
    Response response;
    response = await post(
      getPostJoinEventUrl(eventId, email),
      headers: await RequestHeader().getBasicHeader(),
    );
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<List<dynamic>> getEventPredictions(String eventName) async {
    Response response;
    response = await get(getEventNamePredictionsUrl(eventName),
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
