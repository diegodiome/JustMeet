import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/utils/map_helper.dart';
import 'package:justmeet_frontend/models/comment.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/comment/comment_action.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/widgets/event_info/time_box.dart';
import 'package:justmeet_frontend/widgets/map/map_page.dart';
import 'package:justmeet_frontend/widgets/event_info/event_info_comment_list_view.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class EventInfoContent extends StatefulWidget {
  EventInfoContent({this.event});
  final Event event;

  @override
  _EventInfoContentState createState() => _EventInfoContentState();
}

class _EventInfoContentState extends State<EventInfoContent> {
  final double infoHeight = 364.0;
  final _commentTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
            child: Column(children: <Widget>[
          infoWidgetUi(),
          joinButtonUi(),
          Container(
              constraints: BoxConstraints(
                  minHeight: infoHeight,
                  maxHeight: tempHeight > infoHeight ? tempHeight : infoHeight),
              child: StoreBuilder(
                  onInit: (store) => store.dispatch(
                      OnCommentListUpdate(eventId: widget.event.eventId)),
                  builder: (context, Store<AppState> store) {
                    return RefreshIndicator(
                      onRefresh: () {
                        return store.dispatch(
                            OnCommentListUpdate(eventId: widget.event.eventId));
                      },
                      child: Container(
                          child: commentSectionUi(
                              store.state.commentState.commentsList,
                              store.state.commentState.commentsCount)),
                    );
                  })),
        ])));
  }

  Widget mapView() {
    return Container(
      height: 170,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
        child: Align(
          heightFactor: 0.3,
          widthFactor: 2.5,
          child: MapPage(
            gestureEnabled: true,
            searchInput: false,
            locationMarker: new Marker(
                markerId: MarkerId('locationMarker'),
                position:
                    new LatLng(widget.event.eventLat, widget.event.eventLong)),
            mapStyle: MAP_STYLE.GREEN,
          ),
        ),
      ),
    );
  }

  Widget commentSectionUi(List<Comment> commentsList, int commentsCount) {
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              separatorBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Divider(),
                  ),
                );
              },
              itemCount: commentsCount,
              itemBuilder: (BuildContext context, int index) {
                return EventInfoCommentListView(
                  callback: () {},
                  commentData: commentsList[index],
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                constraints: BoxConstraints(
                  maxHeight: 190,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            Icons.add,
                            color: ThemeProvider.themeOf(context).data.primaryColor,
                          ),
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(OnCommentCreation(
                              eventId: widget.event.eventId,
                              newComment: new Comment(
                                commentCreatorId: StoreProvider.of<AppState>(context).state.userState.currentUser.userUid,
                                commentBody: _commentTextEditingController.text,
                                commentDate: DateTime.now(),
                                eventId: widget.event.eventId
                              )
                            ));
                          },
                        ),
                        contentPadding: EdgeInsets.all(0),
                        title: TextField(
                          controller: _commentTextEditingController,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: ThemeProvider.themeOf(context).data.primaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            hintText: "Write your comment...",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: ThemeProvider.themeOf(context).data.primaryColor,
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget joinButtonUi() {
    return GestureDetector(
        onTap: () async {
          if(StoreProvider.of<AppState>(context).state.userState.currentUser.userUid.compareTo(widget.event.eventCreator) == 0) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Own event...")));
            return;
          }
          else if(widget.event.eventParticipants.contains(StoreProvider.of<AppState>(context).state.userState.currentUser.userUid)) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Already joined...")));
            return;
          }
          if(widget.event.eventPrivate) {
            await StoreProvider.of<AppState>(context).dispatch(OnUserRequestsListUpdate(userId: widget.event.eventCreator));
            if(StoreProvider.of<AppState>(context).state.userState.requests
                .where((request) => request.eventId == widget.event.eventId && request.userId == StoreProvider.of<AppState>(context).state.userState.currentUser.userUid)
                .toList()
                .length > 0) {
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Request already sended...")));
              return;
            }
            StoreProvider.of<AppState>(context).dispatch(OnAddRequest(
                eventId: widget.event.eventId, userId: StoreProvider.of<AppState>(context).state.userState.currentUser.userUid));
            return;
          }
          StoreProvider.of<AppState>(context).dispatch(OnJoinEvent(
              eventId: widget.event.eventId, userId: StoreProvider.of<AppState>(context).state.userState.currentUser.userUid));
          return;
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).data.primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(16.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .primaryColor
                        .withOpacity(0.5),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ],
            ),
            child: Center(
              child: Text(
                widget.event.eventPrivate ? 'Send Request' : 'Join Event',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 0.0,
                  color: ThemeProvider.themeOf(context).data.backgroundColor,
                ),
              ),
            ),
          ),
        ));
  }

  Widget infoWidgetUi() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                widget.event.eventName,
                style: TextStyle(fontSize: 30),
              )),
          SizedBox(height: 10),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 15,
                ),
              )),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                widget.event.eventDescription,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              )),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: <Widget>[
                TimeBox(
                    text1: DateFormat("dd, MMM").format(widget.event.eventDate),
                    text2: 'Date'),
                TimeBox(
                    text1: DateFormat('HH:MM').format(widget.event.eventDate),
                    text2: 'Time'),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Icon(Icons.map),
              Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 10),
                  child: Text(
                    'Location',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
          mapView()
        ],
      ),
    );
  }
}
