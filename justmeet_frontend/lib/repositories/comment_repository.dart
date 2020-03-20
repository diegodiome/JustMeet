import 'dart:convert';

import 'package:http/http.dart';
import 'package:justmeet_frontend/controllers/request_header.dart';
import 'package:justmeet_frontend/models/comment.dart';
import 'package:justmeet_frontend/redux/config.dart';

class CommentRepository {
  Future<List<Comment>> getComments(String eventId) async {
    Response response;
    response = await get(getAllCommentByUrl(eventId),
        headers: await RequestHeader().getBasicHeader());
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      Iterable<dynamic> l = json.decode(response.body);
      return l.map((model) => Comment.fromJson(model)).toList();
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }
}
