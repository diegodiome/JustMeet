

import 'dart:convert';

class Comment {
  Comment({
    this.eventId,
    this.commentBody,
    this.commentCreator,
    this.commentDate
  });

  String eventId;
  String commentCreator;
  String commentBody;
  DateTime commentDate;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      eventId: json['eventId'] as String,
      commentBody: json['commentBody'] as String,
      commentCreator: json['commentCreator'] as String,
      commentDate: DateTime.tryParse(json['eventDate'])
    );
  }

  String toJson() {
    return jsonEncode({
      "eventId": eventId,
      "commentBody": commentBody,
      "commentCreator": commentCreator,
      "commentDate": commentDate.toString()
    });
  }
}