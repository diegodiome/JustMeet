import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/widgets/event_info/event_info_app_bar.dart';
import 'package:justmeet_frontend/widgets/event_info/event_info_content.dart';
import 'package:justmeet_frontend/widgets/event_info/event_rating_dialog.dart';
import 'package:theme_provider/theme_provider.dart';

class EventInfoView extends StatefulWidget {
  EventInfoView({@required this.event});
  final Event event;

  @override
  _EventInfoViewState createState() => _EventInfoViewState();
}

class _EventInfoViewState extends State<EventInfoView> {
  @override
  void initState() {
    super.initState();
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
                  child: widget.event.eventImageUrl != ''
                      ? Image(
                          image: FirebaseImage(widget.event.eventImageUrl),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/back_info.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ],
            ),
            Positioned(
                top: (MediaQuery.of(context).size.width / 1.4) - 24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                    child: Container(
                        decoration: BoxDecoration(
                          color: ThemeProvider.themeOf(context)
                              .data
                              .backgroundColor,
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
                        child: EventInfoContent(
                          event: widget.event,
                        )))),
            EventInfoAppBar()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog<dynamic>(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) => EventRatingDialog(
                eventId: widget.event.eventId,
              ),
            );
          },
          backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
          child: Icon(
            Icons.star,
          ),
        ),
      ),
    );
  }
}
