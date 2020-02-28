import 'package:flutter/material.dart';
import 'package:justmeet_frontend/view/event_info_view.dart';
import 'package:justmeet_frontend/view/event_list_view.dart';
import 'package:justmeet_frontend/view/filters_list_view.dart';
import 'package:justmeet_frontend/view/new_event_view.dart';
import 'package:justmeet_frontend/widget/filter_bar.dart';
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
    // reload
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
              getAppBarUI(),
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
                                getSearchBarUI(),
                              ],
                            );
                          }, childCount: 1),
                        ),
                        SliverPersistentHeader(
                          pinned: true,
                          floating: true,
                          delegate: ContestTabHeader(
                            FilterBar(
                              function: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                showFilterDialog(context: context);
                              }, 
                              eventCount: eventCount)
                          ),
                        ),
                      ];
                    },
                    body: FutureBuilder<List<EventListData>>(
                        future: _getEvents,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<EventListData>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
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
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .backgroundColor,
                                  child: ListView.builder(
                                    itemCount: eventList.length,
                                    padding: const EdgeInsets.only(top: 8),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final int count = eventList.length > 10
                                          ? 10
                                          : eventList.length;
                                      eventCount = count;
                                      final Animation<double> animation =
                                          Tween<double>(begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                                  parent: animationController,
                                                  curve: Interval(
                                                      (1 / count) * index, 1.0,
                                                      curve: Curves
                                                          .fastOutSlowIn)));
                                      animationController.forward();
                                      return EventListView(
                                        callback: () {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          Navigator.push<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                                builder:
                                                    (BuildContext context) =>
                                                        EventInfoView(
                                                          event:
                                                              eventList[index],
                                                          auth: widget.auth,
                                                          eventsController:
                                                              eventsController,
                                                        ),
                                                fullscreenDialog: true),
                                          );
                                        },
                                        eventData: eventList[index],
                                        animation: animation,
                                        animationController:
                                            animationController,
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                  onRefresh: () async { 
                                    refreshList(); 
                                    setState(() {
                                      eventCount = eventList.length;
                                    });
                                  },
                                  child: Center(
                                    child: Text("Error retriving data"),
                                  ));
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
                        })),
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
          FocusScope.of(context).requestFocus(FocusNode());
          Navigator.push<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => NewEventView(
                    auth: widget.auth, eventsController: eventsController),
                fullscreenDialog: true),
          );
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

  void showFilterDialog({BuildContext context}) {
    showDialog<dynamic>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => FiltersListView(),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).data.backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor:
                        ThemeProvider.themeOf(context).data.primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).data.primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search, size: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).data.primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Events',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.account_circle, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        if (ThemeProvider.themeOf(context).id == 'light') {
                          ThemeProvider.controllerOf(context).setTheme('dark');
                        } else {
                          ThemeProvider.controllerOf(context).setTheme('light');
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ThemeProvider.themeOf(context).id == 'light'
                              ? Icon(
                                  Icons.brightness_3,
                                  color: Colors.white,
                                )
                              : Icon(Icons.brightness_7, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
