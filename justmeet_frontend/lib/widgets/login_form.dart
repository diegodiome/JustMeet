import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_actions.dart';
import 'package:justmeet_frontend/widgets/login_auth_button.dart';

class LoginForm extends StatefulWidget {
  LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final submitCallback = () {
      if (_formKey.currentState.validate()) {
        final loginAction = LogIn(
            email: _emailTextEditingController.text,
            password: _passwordTextEditingController.text);
        StoreProvider.of<AppState>(context).dispatch(loginAction);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Logging you in...")));

        loginAction.completer.future.catchError((error) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('$error') ));
        });
      }
    };

    final _passwordTextField = TextFormField(
      obscureText: true,
      decoration:
          const InputDecoration(
            border: InputBorder.none,
            labelText: "Password", 
            icon: Icon(Icons.lock)),
      controller: _passwordTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your password";
        }
        else if(value.length < 6) {
          return "Password too short, minimum 6 characters";
        }
        return null;
      },
    );

    final _emailTextField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration:
          const InputDecoration(
            border: InputBorder.none,
            labelText: "Email", 
            icon: Icon(Icons.email)),
      controller: _emailTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      },
    );

    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16, top: 8, bottom: 8, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 4, bottom: 4),
                        child: _emailTextField
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16, top: 8, bottom: 8, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 4, bottom: 4),
                        child: _passwordTextField
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.0
            ),
            LoginAuthButton(
              function: submitCallback,
            )
          ],
        ));
  }
}
