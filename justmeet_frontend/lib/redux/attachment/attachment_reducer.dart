import 'package:justmeet_frontend/redux/attachment/attachment_action.dart';
import 'package:justmeet_frontend/redux/attachment/attachment_state.dart';
import 'package:redux/redux.dart';

final attachmentReducers = combineReducers<AttachmentState>([
  TypedReducer<AttachmentState, OnImageStramSuccess>(_onImageStreamSuccess),
]);

AttachmentState _onImageStreamSuccess(AttachmentState state, OnImageStramSuccess action) {
  return state.copyWith(
    storageImageUrl: action.storageImageUrl
  );
}