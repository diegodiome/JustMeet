import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/comment.dart';

@immutable
class CommentState {

  final int commentsCount;
  final List<Comment> commentsList;

  CommentState({
    this.commentsCount,
    this.commentsList
  });

  factory CommentState.initial() {
    return new CommentState(
      commentsList: new List<Comment>(),
      commentsCount: 0
    );
  }

  CommentState copyWith({
    int commentsCount,
    List<Comment> commentsList
  }) {
    return new CommentState(
      commentsCount: commentsCount ?? this.commentsCount,
      commentsList: commentsList ?? this.commentsList
    );
  }
}