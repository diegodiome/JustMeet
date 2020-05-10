import 'package:flutter/material.dart';
import 'package:justmeet_frontend/routes.dart';
import 'package:justmeet_frontend/widgets/registration/registration_form.dart';
import 'package:theme_provider/theme_provider.dart';

class RegistrationPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  RegistrationPage({this.navigatorKey});

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
                getReturnArrow(context),
                Text('Sign up'),
                SizedBox(height: 50),
                RegistrationForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getReturnArrow(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: AppBar().preferredSize.height + 40,
      height: AppBar().preferredSize.height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(32.0),
          ),
          onTap: () {
            navigatorKey.currentState.pushReplacementNamed(Routes.login);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: ThemeProvider.themeOf(context).data.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
