
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/widgets/event_info_app_bar.dart';
import 'package:justmeet_frontend/widgets/registration_form.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key key}) : super(key: key);

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
                EventInfoAppBar(),
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
}