

import 'package:flutter/material.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/attachment/attachment_action.dart';
import 'package:justmeet_frontend/repository/attachment_repository.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAttachmentMiddleware(
    AttachmentRepository attachmentRepository, GlobalKey<NavigatorState> navigatorKey) {
  return [
    TypedMiddleware<AppState, OnImageStream>(
      _onImageStream(navigatorKey, attachmentRepository)),
  ];
}

void Function(Store<AppState> store, dynamic action, NextDispatcher next)
    _onImageStream(
  GlobalKey<NavigatorState> navigatorKey,
  AttachmentRepository attachmentRepository,
) {
  return (store, action, next) async {
    next(action);
    try {
      final imageUrl = await attachmentRepository.getStorageImageUrl(action.localImageUrl);
      await store.dispatch(OnImageStramSuccess(imageUrl));
      action.completer.complete();
    } on PlatformException catch (e) {
      print('Error: $e');
      action.completer.completeError(e);
    }
  };
}