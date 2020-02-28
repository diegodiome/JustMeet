import 'package:flutter/material.dart';
import 'package:justmeet_frontend/view/event_info_view.dart';
import 'package:justmeet_frontend/view/event_list_view.dart';
import 'package:justmeet_frontend/view/filters_list_view.dart';
import 'package:justmeet_frontend/view/new_event_view.dart';
import 'package:justmeet_frontend/widgets/home_app_bar.dart';
import 'package:justmeet_frontend/widgets/home_contest_tab_header.dart';
import 'package:justmeet_frontend/widgets/home_filter_bar.dart';
import 'package:justmeet_frontend/widgets/home_search_bar.dart';
import 'package:theme_provider/theme_provider.dart';
import 'cloud_storage.dart';
import 'controller/base_auth.dart';
import 'controller/events_controller.dart';
import 'model/event_list_data.dart';

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.userId, this.logoutCallback});

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  CloudStorage storage;

  Future<List<EventListData>> _getEvents;
  final ScrollController _scrollController = ScrollController();

  int eventCount;
  List<EventListData> eventList;
  EventsController eventsController;

  Future<List<EventListData>> getEvents() async {
    return await eventsController.getAllEvents(widget.auth);
  }

  void refreshList() {
    setState(() {
      _getEvents = getEvents();
    });
  }

  @override
  void initState() {
    eventsController = new EventsController();
    eventList = new List<EventListData>();
    storage = new CloudStorage();

    _getEvents = getEvents();
    eventCount = eventList.length;

    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            onTap: () {},
            child: Column(children: <Widget>[
              HomeAppBar(userFunction: () {}),
              Expanded(
                child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                HomeSearchBar(function: () {}),
                              ],
                            );
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: HomeContestTabHeader(HomeFilterBar(
                              function: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                showFilterDialog(context: context);
                              },
                              eventCount: eventCount)),
                        ),
                      ];
                    },
                    body: getContentUi()),
              ),
            ]),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          showNewEventDialog(context: context);
        },
      ),
    );
  }

  Future<void> _logOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget getContentUi() {
    return FutureBuilder<List<EventListData>>(
        future: _getEvents,
        builder: (BuildContext context,
            AsyncSnapshot<List<EventListData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              eventList = snapshot.data;
              return RefreshIndicator(
                onRefresh: () async {
                  refreshList();
                  setState(() {
                    eventCount = eventList.length;
                  });
                },
                child: Container(
                    color: ThemeProvider.themeOf(context).data.backgroundColor,
                    child: getEventListUi()),
              );
            } else {
              return Container(
                  child: Center(
                      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.autorenew,
                        color: ThemeProvider.themeOf(context).data.primaryColor,
                        size: 40,
                      ),
                      onPressed: () async {
                        refreshList();
                        setState(() {
                          eventCount = eventList.length;
                        });
                      }),
                  Divider(height: 10),
                  Text('Data error')
                ],
              )));
            }
          } else {
            return Center(
              child: SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
            );
          }
        });
  }

  Widget getEventListUi() {
    return ListView.builder(
      itemCount: eventList.length,
      padding: const EdgeInsets.only(top: 8),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final int count = eventList.length > 10 ? 10 : eventList.length;
        eventCount = count;
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * index, 1.0,
                    curve: Curves.fastOutSlowIn)));
        animationController.forward();
        return EventListView(
          callback: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.push<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => EventInfoView(
                        event: eventList[index],
                        auth: widget.auth,
                        eventsController: eventsController,
                      ),
                  fullscreenDialog: true),
            );
          },
          eventData: eventList[index],
          animation: animation,
          animationController: animationController,
        );
      },
    );
  }

  void showNewEventDialog({BuildContext context}) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => NewEventView(
              auth: widget.auth, eventsController: eventsController),
          fullscreenDialog: true),
    );
  }

  void showFilterDialog({BuildContext context}) {
    showDialog<dynamic>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => FiltersListView(),
    );
  }
}
