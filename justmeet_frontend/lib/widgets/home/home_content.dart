import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/widgets/home/home_event_list.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (store) => store.dispatch(OnEventListUpdate()),
      builder: (context, Store<AppState> store) {
        return RefreshIndicator(
          onRefresh: () {
            return store.dispatch(OnEventListUpdate());
          },
          child: Container(
              color: ThemeProvider.themeOf(context).data.backgroundColor,
              child: HomeEventList(
                animationController: animationController,
                eventsList: store.state.eventState.eventsFiltered,
              )),
        );
      },
    );
  }
}
