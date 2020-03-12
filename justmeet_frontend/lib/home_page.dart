import 'package:flutter/material.dart';
import 'package:justmeet_frontend/view/filters_list_view.dart';
import 'package:justmeet_frontend/view/new_event_view.dart';
import 'package:justmeet_frontend/view/profile_page.dart';
import 'package:justmeet_frontend/widgets/home_app_bar.dart';
import 'package:justmeet_frontend/widgets/home_content.dart';
import 'package:justmeet_frontend/widgets/home_contest_tab_header.dart';
import 'package:justmeet_frontend/widgets/home_filter_bar.dart';
import 'package:justmeet_frontend/widgets/home_search_bar.dart';
import 'package:theme_provider/theme_provider.dart';
import 'cloud_storage.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  CloudStorage storage;
  final ScrollController _scrollController = ScrollController();

  int eventCount;

  @override
  void initState() {
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
              HomeAppBar(userFunction: () {
                showProfileDialog(context: context);
              }),
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
                              FocusScope.of(context).requestFocus(FocusNode());
                              showFilterDialog(context: context);
                            },
                            eventCount: 0)),
                      ),
                    ];
                  },
                  body: HomeContent(),
                ),
              )
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

  void showNewEventDialog({BuildContext context}) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => NewEventView(
          ),fullscreenDialog: true),
    );
  }

  void showProfileDialog({BuildContext context}) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => ProfilePage(
          ),fullscreenDialog: true),
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
