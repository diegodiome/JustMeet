import 'dart:convert';
import 'package:http/http.dart';
import 'package:justmeet_frontend/controller/request_header.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
import 'package:justmeet_frontend/redux/config.dart';

class EventRepository {
  Future<List<EventListData>> getAllEvents() async {
    Response response;
    response = await get(getAllEventsUrl,
        headers: await RequestHeader().getBasicHeader());
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      Iterable<dynamic> l = json.decode(response.body);
      return l.map((model) => EventListData.fromJson(model)).toList();
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }

  Future<void> createNewEvent(EventListData newEvent) async {
    Response response;
    response = await post(
      postCreateEventUrl,
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
    if(statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }
}
