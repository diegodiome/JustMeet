import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class RequestPage extends StatefulWidget {
  final User user;

  const RequestPage({Key key, this.user}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Request'),
          backgroundColor: ThemeProvider.themeOf(context).data.primaryColor,
        ),
        body: StoreBuilder(
          onInit: (store) => store
              .dispatch(OnUserRequestsListUpdate(userId: widget.user.userUid)),
          builder: (context, Store<AppState> store) {
            return ListView.separated(
              padding: EdgeInsets.all(10),
              separatorBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 0.5,
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Divider(),
                  ),
                );
              },
              itemCount: store.state.userState.requests.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FirebaseImage(store
                            .state.userState.requests[index].user.userPhotoUrl),
                        radius: 25,
                      ),
                      contentPadding: EdgeInsets.all(0),
                      title: Text(store.state.userState.requests[index].user
                          .userDisplayName),
                      subtitle: Text(store
                          .state.userState.requests[index].event.eventName),
                      trailing: FlatButton(
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: ThemeProvider.themeOf(context).data.primaryColor,
                        onPressed: () {
                          store.dispatch(
                            OnUserAcceptRequest(
                                eventId: store
                                    .state.userState.requests[index].eventId,
                                userId: store
                                    .state.userState.requests[index].userId),
                          );
                        },
                      )),
                );
              },
            );
          },
        ));
  }
}
