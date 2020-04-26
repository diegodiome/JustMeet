

import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/utils/event_helper.dart';
import 'package:justmeet_frontend/widgets/event/info_box.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:theme_provider/theme_provider.dart';

class EventCard extends StatelessWidget {
  final Event eventData;
  final VoidCallback callback;

  EventCard({@required this.eventData, this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          callback();
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                          aspectRatio: 2,
                          child: eventData.eventImageUrl != ''
                              ? Image(image: FirebaseImage(eventData.eventImageUrl,), fit: BoxFit.cover,)
                              : Image.asset('assets/images/hotel_3.png', height: 50.0,)
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        eventData.eventName,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            eventData.eventDescription,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.withOpacity(0.8)),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            Icons.map,
                                            size: 12,
                                            color: ThemeProvider.themeOf(context).data.primaryColor,
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 5.0),
                                                child: Text(
                                                  '${eventData.eventCategory}',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey.withOpacity(0.8)),
                                                ),
                                              )),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(top: 4),
                                        child: Row(
                                          children: <Widget>[
                                            SmoothStarRating(
                                              allowHalfRating: true,
                                              starCount: 5,
                                              rating: averageRating(eventData.eventRates),
                                              size: 20,
                                              color: ThemeProvider.themeOf(context).data.primaryColor,
                                              borderColor: ThemeProvider.themeOf(context).data.primaryColor,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(left: 30),
                                                child: eventData.eventPrivate
                                                    ? Icon(Icons.lock_outline, color: ThemeProvider.themeOf(context).data.primaryColor,)
                                                    : Icon(Icons.lock_open, color: ThemeProvider.themeOf(context).data.primaryColor,
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(left: 30),
                                                child: InfoBox(text1: eventData.eventParticipants.length.toString(), text2: eventData.eventMaxParticipants.toString(),)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
