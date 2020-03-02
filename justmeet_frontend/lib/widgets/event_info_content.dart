import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/attachment/attachment_action.dart';
import 'package:justmeet_frontend/redux/attachment/attachment_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:theme_provider/theme_provider.dart';

class EventInfoContent extends StatelessWidget {

  EventInfoContent({this.eventData});

  final EventListData eventData;

  @override
  Widget build(BuildContext context) {

    OnImageStream _onImageStream =
        OnImageStream(localImageUrl: eventData.eventImageUrl);
    StoreProvider.of<AppState>(context).dispatch(_onImageStream);

    _onImageStream.completer.future.catchError((error) {
      print('Load image error: $error');
    });
    return StoreConnector<AppState, AttachmentState>(
        converter: (store) => store.state.attachmentState,
        builder: (BuildContext context, AttachmentState attachmentState) {
          return Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        eventData.eventName,
                        style: TextStyle(
                          fontSize: 40.0,
                        ),
                      ),
                      Text(
                        DateFormat('dd - MM - yyyy   HH:mm')
                            .format(eventData.eventDate),
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: attachmentState.storageImageUrl == null
                            ? Image.asset(
                                'assets/images/hotel_3.png',
                                height: 50.0,
                              )
                            : Image.network(
                                attachmentState.storageImageUrl,
                                fit: BoxFit.cover,
                              ),
                      ),
                      GestureDetector(
                        onTap: () {
                          StoreProvider.of<AppState>(context).dispatch(
                              OnJoinEvent(
                                  eventId: eventData.eventId,
                                  email: 'diomedi33@gmail.com'));
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: ThemeProvider.themeOf(context)
                                .data
                                .primaryColor,
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
        });
  }
}
