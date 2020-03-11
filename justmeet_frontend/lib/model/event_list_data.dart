import 'dart:convert';

class EventListData {
  EventListData(
      {this.eventId,
      this.eventImageUrl,
      this.eventName,
      this.eventDescription,
      this.eventRates,
      this.eventAdmin,
      this.eventCategory,
      this.eventDate,
      this.eventLocation,
      this.isPrivate});

  String eventId;
  String eventImageUrl;
  String eventName;
  String eventDescription;
  String eventAdmin;
  List<double> eventRates;
  String eventLocation;
  String eventCategory;
  DateTime eventDate;
  bool isPrivate;

  factory EventListData.fromJson(Map<String, dynamic> json) {
    if (json['eventRates'] != null) {
      return EventListData(
          eventId: json['eventId'] as String,
          eventName: json['eventName'] as String,
          eventDescription: json['eventDescription'] as String,
          eventImageUrl: json['eventImageUrl'] as String,
          eventRates: List<double>.from(json['eventRates']),
          eventAdmin: json['eventAdmin'] as String,
          eventCategory: json['eventCategory'] as String,
          eventLocation: json['eventLocation'] as String,
          isPrivate: json['isPrivate'] as bool,
          eventDate: DateTime.tryParse(json['eventDate']));
    }
    return EventListData(
        eventId: json['eventId'] as String,
        eventName: json['eventName'] as String,
        eventDescription: json['eventDescription'] as String,
        eventImageUrl: json['eventImageUrl'] as String,
        eventAdmin: json['eventAdmin'] as String,
        eventCategory: json['eventCategory'] as String,
        eventLocation: json['eventLocation'] as String,
        isPrivate: json['eventPrivate'] as bool,
        eventDate: DateTime.tryParse(json['eventDate']));
  }

  String toJson() {
    return jsonEncode({
      "eventId": eventId,
      "eventName": eventName,
      "eventDescription": eventDescription,
      "eventAdmin": eventAdmin,
      "eventCategory": eventCategory,
      "eventLocation": eventLocation,
      "eventPrivate": isPrivate,
      "eventDate": eventDate.toString(),
    });
  }
}
