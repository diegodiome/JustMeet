import 'dart:async';

import 'package:justmeet_frontend/models/comment.dart';

class OnCommentListUpdate {
  Completer completer;
  String eventId;

  OnCommentListUpdate({
    this.eventId,
    Completer completer
  }) : completer = completer ?? Completer(); 
}

class OnCommentListUpdateSuccess {
  final List<Comment> commentsList;
  final int commentsCount;

  OnCommentListUpdateSuccess({
    this.commentsCount,
    this.commentsList
  });
}