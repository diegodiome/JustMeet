import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:justmeet_frontend/cloud_storage.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
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
  CloudStorage storage;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    storage = new CloudStorage();
    setImageUrl();
  }

  setImageUrl() async {
    storage.getImage(widget.event.eventImageUrl).then((url) {
      setState(() {
        imageUrl = url;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(30),
        child: Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.event.eventName,
                  style: TextStyle(
                    fontSize: 40.0,
                  ),
                ),
                Text(
                  DateFormat('dd - MM - yyyy   HH:mm')
                      .format(widget.event.eventDate),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: imageUrl == null
                      ? Image.asset(
                          'assets/images/hotel_3.png',
                          height: 50.0,
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                GestureDetector(
                  onTap: () {
                    StoreProvider.of<AppState>(context).dispatch(OnJoinEvent(
                        eventId: widget.event.eventId,
                        email: 'diomedi33@gmail.com'));
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
                          color: ThemeProvider.themeOf(context)
                              .data
                              .backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
