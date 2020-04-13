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
        this.eventPrivate
      });

  String eventId;
  String eventImageUrl;
  String eventName;
  String eventDescription;
  String eventCreator;
  List<double> eventRates;
  double eventLat;
  double eventLong;
  String eventCategory;
  DateTime eventDate;
  bool eventPrivate;

  factory Event.fromJson(Map<String, dynamic> json) {
    if (json['eventRates'] != null) {
      return Event(
          eventId: json['eventId'] as String,
          eventName: json['eventName'] as String,
          eventDescription: json['eventDescription'] as String,
          eventImageUrl: json['eventImageUrl'] as String,
          eventRates: List<double>.from(json['eventRates']),
          eventCreator: json['eventCreator'] as String,
          eventCategory: json['eventCategory'] as String,
          eventLat: json['eventLat'] as double,
          eventLong: json['eventLong'] as double,
          eventPrivate: json['eventPrivate'] as bool,
          eventDate: DateTime.tryParse(json['eventDate']));
    }
    return Event(
        eventId: json['eventId'] as String,
        eventName: json['eventName'] as String,
        eventDescription: json['eventDescription'] as String,
        eventImageUrl: json['eventImageUrl'] as String,
        eventCreator: json['eventCreator'] as String,
        eventCategory: json['eventCategory'] as String,
        eventLat: json['eventLat'] as double,
        eventLong: json['eventLong'] as double,
        eventPrivate: json['eventPrivate'] as bool,
        eventDate: DateTime.tryParse(json['eventDate']));
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
    });
  }
}
