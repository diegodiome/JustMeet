import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/comment.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/comment/comment_action.dart';
import 'package:justmeet_frontend/repositories/comment_repository.dart';
import 'package:redux/redux.dart';
import "package:flutter/services.dart";

List<Middleware<AppState>> createCommentMiddleware(
    CommentRepository commentRepository, GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, OnCommentListUpdate>(_commentsListUpdate(commentRepository)),
    TypedMiddleware<AppState, OnCommentCreation>(_onCommentCreate(commentRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
_onCommentCreate(
    CommentRepository commentRepository,
    ) {
  return (store, action, next) async {
    next(action);
    try {
      await commentRepository.createComment(action.eventId, action.newComment);
      store.dispatch(OnCommentListUpdate(
        eventId: action.eventId
      ));
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _commentsListUpdate(
  CommentRepository commentRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final List<Comment> commentsList =
          await commentRepository.getComments(action.eventId);
      store.dispatch(OnCommentListUpdateSuccess(
          commentsList: commentsList, commentsCount: commentsList.length));
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}