import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:justmeet_frontend/models/event_list_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:theme_provider/theme_provider.dart';

class EventInfoContent extends StatefulWidget {
  EventInfoContent({this.event});
  final EventListData event;

  @override
  _EventInfoContentState createState() => _EventInfoContentState();
}

class _EventInfoContentState extends State<EventInfoContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(30),
        child: Column(children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    infoWidgetUi(),
                  ]),
            ),
          ),
          joinButtonUi()
        ]));
  }

  Widget commentSectionUi() {
    
  }

  Widget joinButtonUi() {
    return GestureDetector(
      onTap: () {
        StoreProvider.of<AppState>(context).dispatch(OnJoinEvent(
            eventId: widget.event.eventId, email: 'diomedi33@gmail.com'));
      },
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
    );
  }

  Widget infoWidgetUi() {
    return Column(
      children: <Widget>[
        Text(
          widget.event.eventName,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(height: 20),
        Row(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(Icons.date_range),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(DateFormat('dd - MM - yyyy')
                      .format(widget.event.eventDate)),
                )
              ]),
              Row(children: <Widget>[
                Text(
                  DateFormat('HH:mm').format(widget.event.eventDate),
                  style: TextStyle(color: Colors.grey),
                ),
              ])
            ],
          )
        ])
      ],
    );
  }
}
