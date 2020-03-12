import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';

import 'base_auth.dart';

class EventsController {

  Future<List<EventListData>> getAllEvents(BaseAuth auth) async {
    try {
      final token = await auth.getFirebaseToken();
      Response response;
      String url = 'http://192.168.1.9:9000/api/v1/events/all';
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": '$token'
      };
      // make POST request
      response =
          await get(url, headers: headers).timeout(const Duration(seconds: 4));
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        Iterable<dynamic> l = json.decode(response.body);
        return l.map((model) => EventListData.fromJson(model)).toList();
      }
      print('Connection error : $statusCode');
      return null;
    } on SocketException catch (e) {
      print('Connection error: $e');
      return null;
    } on TimeoutException catch (e) {
      print('Connection error: $e');
      return null;
    }
  }

  Future<void> addNewEvent(BaseAuth auth, EventListData event) async {
    try {
      FirebaseUser user = await auth.getCurrentUser();
      final token = await auth.getFirebaseToken();

      // set up POST request arguments
      String url = 'http://192.168.1.9:9000/api/v1/events/add';
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": '$token'
      };
      // make POST request
      Response response = await post(url,
          headers: headers,
          body: jsonEncode({
            "eventId": event.eventId,
            "eventName": event.eventName,
            "eventAdmin": user.email,
            "eventDescription": event.eventDescription,
            "eventImageUrl": event.eventImageUrl,
            "eventCategory": event.eventCategory,
            "eventLocation": event.eventLocation,
            "isPrivate": event.isPrivate,
            "eventDate": event.eventDate.toString()
          }));
      if (response.statusCode == 200) {
        print('Event successfully created!');
      }
      else {
        print('Event creation failed!');
      }
    } on SocketException catch (e) {
      print('Connection error: $e');
      return null;
    } on TimeoutException catch (e) {
      print('Connection error: $e');
      return null;
    }
  }

  Future<void> joinEvent(BaseAuth auth, String eventId) async {
    try {
      FirebaseUser user = await auth.getCurrentUser();
      final displayName = user.displayName;
      final token = await auth.getFirebaseToken();
      // set up POST request arguments
      String url = 'http://192.168.1.9:9000/api/v1/events/join/id=$eventId&displayName=$displayName';
      Map<String, String> headers = {
        "Content-type": "application/json",
        "Authorization": '$token'
      };
      Response response = await post(url, headers: headers);
      if(response.statusCode == 200) {
        print('$displayName successfully joined in $eventId!');
      }
      else {
        print('Joined error!');
      }
    }
    on SocketException catch (e) {
      print('Connection error: $e');
      return null;
    } on TimeoutException catch (e) {
      print('Connection error: $e');
      return null;
    }
  }
}
