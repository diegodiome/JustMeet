import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/redux/event/event_state.dart';
import 'package:justmeet_frontend/widgets/home_event_list.dart';
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

  Future<void> getEventsList() async{
    OnEventListUpdate _onEventListUpdate = OnEventListUpdate();
    StoreProvider.of<AppState>(context).dispatch(_onEventListUpdate);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Get events...")));
  }

  @override
  Widget build(BuildContext context) {
    getEventsList().catchError((error) {
      Scaffold.of(context).hideCurrentSnackBar();
      return Container(
        child: Center(
          child: Text('Error: $error')
        ),
      );
    });
    return StoreConnector<AppState, EventState>(
      converter: (store) => store.state.eventState,
      builder: (BuildContext context, EventState eventState) {
        return RefreshIndicator(
          onRefresh: () {
            return getEventsList();
          },
          child: Container(
              color: ThemeProvider.themeOf(context).data.backgroundColor,
              child: HomeEventList(
                animationController: animationController,
                eventsList: eventState.eventsList,
              )),
        );
      },
    );
  }
}
