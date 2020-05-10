import 'package:justmeet_frontend/redux/comment/comment_action.dart';
import 'package:justmeet_frontend/redux/comment/comment_state.dart';
import 'package:redux/redux.dart';

final commentsReducers = combineReducers<CommentState>([
  TypedReducer<CommentState, OnCommentListUpdateSuccess>(_onCommentListUpdateSuccess),
]);

CommentState _onCommentListUpdateSuccess(CommentState state, OnCommentListUpdateSuccess action) {
  return state.copyWith(
    commentsCount: action.commentsCount,
    commentsList: action.commentsList
  );
}
