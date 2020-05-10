
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/user.dart';

class EventRequest {

  String eventId;
  Event event;
  String userId;
  User user;

  EventRequest({this.user, this.eventId, this.userId, this.event});

  factory EventRequest.fromJson(Map<String, dynamic> json) {
    return EventRequest(
      eventId: json['eventId'],
      userId: json['userId'],
      event: Event.fromJson(json['event']),
      user: User.fromJson(json['user'])
    );
  }

}