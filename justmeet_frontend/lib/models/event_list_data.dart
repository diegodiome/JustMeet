import 'dart:convert';

class EventListData {
  EventListData(
      {this.eventId,
      this.eventImageUrl,
      this.eventName,
      this.eventDescription,
      this.eventRates,
      this.eventCreator,
      this.eventCategory,
      this.eventDate,
      this.eventLocation,
      this.eventPrivate});

  String eventId;
  String eventImageUrl;
  String eventName;
  String eventDescription;
  String eventCreator;
  List<double> eventRates;
  String eventLocation;
  String eventCategory;
  DateTime eventDate;
  bool eventPrivate;

  factory EventListData.fromJson(Map<String, dynamic> json) {
    if (json['eventRates'] != null) {
      return EventListData(
          eventId: json['eventId'] as String,
          eventName: json['eventName'] as String,
          eventDescription: json['eventDescription'] as String,
          eventImageUrl: json['eventImageUrl'] as String,
          eventRates: List<double>.from(json['eventRates']),
          eventCreator: json['eventCreator'] as String,
          eventCategory: json['eventCategory'] as String,
          eventLocation: json['eventLocation'] as String,
          eventPrivate: json['eventPrivate'] as bool,
          eventDate: DateTime.tryParse(json['eventDate']));
    }
    return EventListData(
        eventId: json['eventId'] as String,
        eventName: json['eventName'] as String,
        eventDescription: json['eventDescription'] as String,
        eventImageUrl: json['eventImageUrl'] as String,
        eventCreator: json['eventCreator'] as String,
        eventCategory: json['eventCategory'] as String,
        eventLocation: json['eventLocation'] as String,
        eventPrivate: json['eventPrivate'] as bool,
        eventDate: DateTime.tryParse(json['eventDate']));
  }

  String toJson() {
    return jsonEncode({
      "eventId": eventId,
      "eventName": eventName,
      "eventDescription": eventDescription,
      "eventCreator": eventCreator,
      "eventCategory": eventCategory,
      "eventLocation": eventLocation,
      "eventPrivate": eventPrivate,
      "eventImageUrl": eventImageUrl,
      "eventDate": eventDate.toString(),
    });
  }
}
