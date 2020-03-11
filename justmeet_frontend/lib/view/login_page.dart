import 'package:flutter/material.dart';
import 'package:justmeet_frontend/routes.dart';
import 'package:justmeet_frontend/widgets/login_form.dart';
import 'package:justmeet_frontend/widgets/login_google_button.dart';

class LoginPage extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey;

  LoginPage({this.navigatorKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/images/justmeet_logo.png"),
                        height: 50.0),
                    Text('Just Meet')
                  ],
                ),
                SizedBox(height: 50),
                LoginForm(),
                SizedBox(height: 30),
                Text(
                  'OR',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: LoginGoogleButton(),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () async{
                    await navigatorKey.currentState.pushReplacementNamed(Routes.registration);
                  },
                  child: Text('Create account'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
