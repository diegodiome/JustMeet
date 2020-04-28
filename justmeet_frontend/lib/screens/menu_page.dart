import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_actions.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/screens/profile_page.dart';
import 'package:redux/redux.dart';

class MenuScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (store) =>
          store.dispatch(OnLocalUserUpdate(userId: store.state.authState.uid)),
      builder: (context, Store<AppState> store) {
        return GestureDetector(
          onPanUpdate: (details) {
            //on swiping left
            if (details.delta.dx < -6) {
              store.state.menuState.menuController.toggle();
            }
          },
          child: Container(
            padding: EdgeInsets.only(
                top: 62,
                left: 32,
                bottom: 8,
                right: MediaQuery.of(context).size.width / 2.9),
            color: Color(0xff454dff),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: store
                                    .state.userState.currentUser.userPhotoUrl !=
                                null
                            ? FirebaseImage(
                                store.state.userState.currentUser.userPhotoUrl)
                            : AssetImage('assets/images/hotel_3.png'),
                      ),
                    ),
                    Text(
                      store.state.userState.currentUser.userDisplayName != null
                          ? store.state.userState.currentUser.userDisplayName
                          : store.state.userState.currentUser.userEmail,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    ListTile(
                      onTap: () {
                        // TODO: edit profile
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage(
                            user: store.state.userState.currentUser,
                          )),
                        );
                      },
                      leading: Icon(
                        Icons.account_box,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: Text(
                        'Edit profile',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        // TODO: dysplay my events
                      },
                      leading: Icon(
                        Icons.event,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: Text(
                        'My events',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        store.dispatch(LogOut());
                      },
                      leading: Icon(
                        Icons.cancel,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: Text(
                        'Log out',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                Spacer(),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text('Settings',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(
                    Icons.headset_mic,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text('Support',
                      style: TextStyle(fontSize: 14, color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MenuItem {
  String title;
  IconData icon;
  Function tapFunction;

  MenuItem({this.icon, this.title, this.tapFunction});
}
