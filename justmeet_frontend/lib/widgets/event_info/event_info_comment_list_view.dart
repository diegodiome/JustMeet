import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/comment.dart';

class EventInfoCommentListView extends StatefulWidget {
  EventInfoCommentListView({this.callback, this.commentData});

  final VoidCallback callback;
  final Comment commentData;

  @override
  _EventInfoCommentListViewState createState() =>
      _EventInfoCommentListViewState();
}

class _EventInfoCommentListViewState extends State<EventInfoCommentListView> {
  final bool isOnline = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/hotel_3.png',
              ),
              radius: 25,
            ),

            Positioned(
              bottom: 0.0,
              left: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 11,
                width: 11,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isOnline
                          ?Colors.greenAccent
                          :Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 7,
                    width: 7,
                  ),
                ),
              ),
            ),

          ],
        ),
        contentPadding: EdgeInsets.all(0),
        title: Text(widget.commentData.commentCreator),
        subtitle: Text(widget.commentData.commentBody),
        trailing: Text(
          getTimeDifference(widget.commentData.commentDate),
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  String getTimeDifference(DateTime timeToCompare) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(timeToCompare);
    if (difference.inHours >= 24) {
      return difference.inDays.toString() + 'd';
    } else if (difference.inMinutes >= 60) {
      return difference.inHours.toString() + 'h';
    } else if (difference.inSeconds >= 60) {
      return difference.inMinutes.toString() + 'm';
    }
    return difference.inSeconds.toString() + 's';
  }
}
