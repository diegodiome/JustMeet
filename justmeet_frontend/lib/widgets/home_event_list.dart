import 'package:flutter/material.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';
import 'package:justmeet_frontend/view/event_info_view.dart';
import 'package:justmeet_frontend/view/event_list_view.dart';

class HomeEventList extends StatefulWidget {
  HomeEventList({this.animationController, this.eventsList});

  final AnimationController animationController;
  final List<EventListData> eventsList;

  @override
  _HomeEventListState createState() => _HomeEventListState();
}

class _HomeEventListState extends State<HomeEventList> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
        return ListView.builder(
          itemCount: widget.eventsList.length,
          padding: const EdgeInsets.only(top: 8),
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            final int count =
                widget.eventsList.length > 10 ? 10 : widget.eventsList.length;
            //widget.eventsList.length = count;
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: widget.animationController,
                    curve: Interval((1 / count) * index, 1.0,
                        curve: Curves.fastOutSlowIn)));
            widget.animationController.forward();
            return EventListView(
              callback: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => EventInfoView(
                            event: widget.eventsList[index],
                          ),
                      fullscreenDialog: true),
                );
              },
              eventData: widget.eventsList[index],
              animation: animation,
              animationController: widget.animationController,
            );
          },
        );
  }
}
