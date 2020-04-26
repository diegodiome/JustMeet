import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/menu/menu_action.dart';
import 'package:justmeet_frontend/screens/filters_list_view.dart';
import 'package:justmeet_frontend/screens/menu_page.dart';
import 'package:justmeet_frontend/screens/new_event_view.dart';
import 'package:justmeet_frontend/widgets/home/home_app_bar.dart';
import 'package:justmeet_frontend/widgets/home/home_content.dart';
import 'package:justmeet_frontend/widgets/home/home_contest_tab_header.dart';
import 'package:justmeet_frontend/widgets/home/home_filter_bar.dart';
import 'package:justmeet_frontend/widgets/home/home_search_bar.dart';
import 'package:justmeet_frontend/widgets/home/menu_scaffold.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class HomePage extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  HomePage({this.navigatorKey});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  MenuController menuController;

  int eventCount;

  @override
  void initState() {
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (store) => store.dispatch(OnMenuControllerUpdate(menuController: menuController)),
      builder: (context, Store<AppState> store) {
        return ZoomScaffold(
          menuScreen: MenuScreen(),
          contentScreen: Layout(
            contentBuilder: (cc) => Scaffold(
              body: Stack(
                children: <Widget>[
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {},
                    child: Column(children: <Widget>[
                      HomeAppBar(
                        function: store.state.menuState.menuController.toggle,
                      ),
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
                                          HomeSearchBar(
                                            function: () {},
                                          ),
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
            )
          ),
        );
      }
    );
  }

  void showNewEventDialog({BuildContext context}) {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => NewEventView(),
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
