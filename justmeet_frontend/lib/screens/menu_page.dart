import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:redux/redux.dart';

class MenuScreen extends StatelessWidget {
  final List<MenuItem> options = [
    MenuItem(Icons.search, 'Search'),
    MenuItem(Icons.shopping_basket, 'Basket'),
    MenuItem(Icons.favorite, 'Discounts'),
    MenuItem(Icons.code, 'Prom-codes'),
    MenuItem(Icons.format_list_bulleted, 'Orders'),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (store) => store.dispatch(OnLocalUserUpdate(userId: store.state.authState.uid)),
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
                            ? NetworkImage(
                                store.state.userState.currentUser.userPhotoUrl)
                            : AssetImage('assets/images/hotel_3.png'),
                      ),
                    ),
                    Text(
                      store.state.userState.currentUser.userEmail,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                Spacer(),
                Column(
                  children: options.map((item) {
                    return ListTile(
                      leading: Icon(
                        item.icon,
                        color: Colors.white,
                        size: 20,
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    );
                  }).toList(),
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

  MenuItem(this.icon, this.title);
}
