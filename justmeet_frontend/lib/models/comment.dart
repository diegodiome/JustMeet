

import 'dart:convert';

import 'package:justmeet_frontend/models/user.dart';

class Comment {
  Comment({
    this.eventId,
    this.commentBody,
    this.commentCreator,
    this.commentDate,
    this.commentCreatorId
  });

  String eventId;
  User commentCreator;
  String commentBody;
  String commentCreatorId;
  DateTime commentDate;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      eventId: json['eventId'] as String,
      commentBody: json['commentBody'] as String,
      commentCreatorId: json['commentCratorId'] as String,
      commentDate: DateTime.tryParse(json['commentDate'])
    );
  }

  factory Comment.fromListCommentsJson(Map<String, dynamic> json) {
    return Comment(
        eventId: json['eventId'] as String,
        commentBody: json['commentBody'] as String,
        commentCreator: User.fromJson(json['commentCreator']),
        commentCreatorId: json['commentCratorId'] as String,
        commentDate: DateTime.tryParse(json['commentDate'])
    );
  }

  String toJson() {
    return jsonEncode({
      "eventId": eventId,
      "commentBody": commentBody,
      "commentCreatorId": commentCreatorId,
      "commentDate": commentDate.toString()
    });
  }
}