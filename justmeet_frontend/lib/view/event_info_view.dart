import 'package:flutter/material.dart';
import 'package:justmeet_frontend/cloud_storage.dart';
import 'package:justmeet_frontend/controller/base_auth.dart';
import 'package:justmeet_frontend/controller/events_controller.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
import 'package:intl/intl.dart';
import 'package:theme_provider/theme_provider.dart';

class EventInfoView extends StatefulWidget {
  final EventListData event;
  final EventsController eventsController;
  final BaseAuth auth;
  EventInfoView({@required this.event, @required this.eventsController, @required this.auth});

  @override
  _EventInfoViewState createState() => _EventInfoViewState();
}

class _EventInfoViewState extends State<EventInfoView> {
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
    return Container(
      color: ThemeProvider.themeOf(context).data.backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: Image.asset('assets/images/back_info.png'),
                ),
              ],
            ),
            Positioned(
                top: (MediaQuery.of(context).size.width / 1.4) - 24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(
                      color: ThemeProvider.themeOf(context).data.backgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(32.0),
                          topRight: Radius.circular(32.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            offset: const Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Padding(
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
                                    widget.eventsController.joinEvent(widget.auth, widget.event.eventId)
                                      .whenComplete((){
                                      Navigator.pop(context);
                                    });
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
                                            color:
                                                ThemeProvider.themeOf(context).data.primaryColor.withOpacity(0.5),
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
                                ),
                              ]),
                        )))),
            getAppBarUI(),
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ThemeProvider.themeOf(context).data.primaryColor,),
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
