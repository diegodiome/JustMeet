import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:justmeet_frontend/controllers/map_helper.dart';
import 'package:justmeet_frontend/models/comment.dart';
import 'package:justmeet_frontend/models/event_list_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/comment/comment_action.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/widgets/map/map_page.dart';
import 'package:justmeet_frontend/widgets/event_info/event_info_comment_list_view.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class EventInfoContent extends StatefulWidget {
  EventInfoContent({this.event});
  final EventListData event;

  @override
  _EventInfoContentState createState() => _EventInfoContentState();
}

class _EventInfoContentState extends State<EventInfoContent> {
  final double infoHeight = 364.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> getCommentsList() async {
    OnCommentListUpdate _onCommentListUpdate =
        OnCommentListUpdate(eventId: widget.event.eventId);
    StoreProvider.of<AppState>(context).dispatch(_onCommentListUpdate);
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text("Get comments...")));
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
            gestureEnabled: false,
            searchInput: false,
            mapStyle: MAP_STYLE.GREEN,
          ),
        ),
      ),
    );
  }

  Widget commentSectionUi(List<Comment> commentsList, int commentsCount) {
    return ListView.separated(
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
    );
  }

  Widget joinButtonUi() {
    return GestureDetector(
        onTap: () {
          StoreProvider.of<AppState>(context).dispatch(OnJoinEvent(
              eventId: widget.event.eventId, email: 'diomedi33@gmail.com'));
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
                'Join Event',
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
          children: <Widget>[
            Text(
              widget.event.eventName,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(Icons.date_range),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(DateFormat('dd - MM - yyyy')
                        .format(widget.event.eventDate)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.watch_later),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      DateFormat('HH:mm').format(widget.event.eventDate),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.map),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Location',
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ),
                mapView()
              ],
            ),
          ],
        ));
  }
}
