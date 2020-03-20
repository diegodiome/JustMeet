import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event_list_data.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:theme_provider/theme_provider.dart';

class EventListView extends StatefulWidget {
  EventListView(
      {Key key,
      this.eventData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final EventListData eventData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  _EventListViewState createState() => _EventListViewState();
}

class _EventListViewState extends State<EventListView> {

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  widget.callback();
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
                                child: widget.eventData.eventImageUrl != ''
                                    ? Image(
                                        image: FirebaseImage(
                                          widget.eventData.eventImageUrl,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/hotel_3.png',
                                        height: 50.0,
                                      )),
                            Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.eventData.eventName,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.eventData
                                                      .eventDescription,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Icon(
                                                  Icons.map,
                                                  size: 12,
                                                  color: ThemeProvider.themeOf(
                                                          context)
                                                      .data
                                                      .primaryColor,
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.0),
                                                  child: Text(
                                                    '${widget.eventData.eventCategory}',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.grey
                                                            .withOpacity(0.8)),
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
                                                    rating: averageRating(widget
                                                        .eventData.eventRates),
                                                    size: 20,
                                                    color:
                                                        ThemeProvider.themeOf(
                                                                context)
                                                            .data
                                                            .primaryColor,
                                                    borderColor:
                                                        ThemeProvider.themeOf(
                                                                context)
                                                            .data
                                                            .primaryColor,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 30),
                                                      child: widget.eventData
                                                              .isPrivate
                                                          ? Icon(
                                                              Icons
                                                                  .lock_outline,
                                                              color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .data
                                                                  .primaryColor,
                                                            )
                                                          : Icon(
                                                              Icons.lock_open,
                                                              color: ThemeProvider
                                                                      .themeOf(
                                                                          context)
                                                                  .data
                                                                  .primaryColor,
                                                            ))
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
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .accentColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double averageRating(List<double> rates) {
    if (rates != null) {
      double sum = 0;
      for (double num in rates) {
        sum += num;
      }
      return sum / rates.length;
    }
    return 0.0;
  }
}
