import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/widgets/event/event_card.dart';

class EventListView extends StatefulWidget {
  EventListView(
      {Key key,
      this.eventData,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Event eventData;
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
            child: EventCard(
              eventData: widget.eventData,
              callback: widget.callback,
            )
          ),
        );
      },
    );
  }
}
