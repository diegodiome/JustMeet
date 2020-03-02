import 'dart:convert';
import 'package:http/http.dart';
import 'package:justmeet_frontend/controller/request_header.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
import 'package:justmeet_frontend/redux/config.dart';

class EventRepository {

  Future<List<EventListData>> getAllEvents() async{
    try {
      Response response;
      response = await get(
        getAllEventsUrl,
        headers: await RequestHeader().getBasicHeader()
      ).timeout(new Duration(seconds: 4));
      int statusCode = response.statusCode;
      if(statusCode == 200) {
        Iterable<dynamic> l = json.decode(response.body);
        return l.map((model) => EventListData.fromJson(model)).toList();
      }
      print('Connection error: $statusCode');
    }
    catch(e) {
      print('Error: $e');
    }
    return Future.value(null);
  }
}