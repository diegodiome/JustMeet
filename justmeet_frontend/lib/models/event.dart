import 'dart:convert';

class Event {
  Event(
      {
        this.eventId,
        this.eventImageUrl,
        this.eventName,
        this.eventDescription,
        this.eventRates,
        this.eventCreator,
        this.eventCategory,
        this.eventLat,
        this.eventLong,
        this.eventDate,
        this.eventPrivate,
        this.eventMaxParticipants,
        this.eventParticipants
      });

  String eventId;
  String eventImageUrl;
  String eventName;
  String eventDescription;
  String eventCreator;
  List<double> eventRates;
  List<String> eventParticipants;
  int eventMaxParticipants;
  double eventLat;
  double eventLong;
  String eventCategory;
  DateTime eventDate;
  bool eventPrivate;

  factory Event.fromJson(Map<String, dynamic> json) {
      return Event(
          eventId: json['eventId'] as String,
          eventName: json['eventName'] as String,
          eventDescription: json['eventDescription'] as String,
          eventImageUrl: json['eventImageUrl'] as String,
          eventRates: json['eventRates'] != null ? List<double>.from(json['eventRates']) : null,
          eventCreator: json['eventCreator'] as String,
          eventCategory: json['eventCategory'] as String,
          eventLat: json['eventLat'] as double,
          eventLong: json['eventLong'] as double,
          eventPrivate: json['eventPrivate'] as bool,
          eventDate: DateTime.tryParse(json['eventDate']),
          eventMaxParticipants: json['eventMaxParticipants'] as int,
          eventParticipants: List<String>.from(json['eventParticipants']));
  }

  String toJson() {
    return jsonEncode({
      "eventName": eventName,
      "eventDescription": eventDescription,
      "eventCreator": eventCreator,
      "eventCategory": eventCategory,
      "eventLat": eventLat,
      "eventLong": eventLong,
      "eventPrivate": eventPrivate,
      "eventImageUrl": eventImageUrl,
      "eventDate": eventDate.toString(),
      "eventMaxParticipants": eventMaxParticipants,
      "eventParticipants": eventParticipants
    });
  }
}
