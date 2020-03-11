import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justmeet_frontend/cloud_storage.dart';
import 'package:justmeet_frontend/home_page.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_actions.dart';
import 'package:justmeet_frontend/redux/store.dart';
import 'package:justmeet_frontend/repository/attachment_repository.dart';
import 'package:justmeet_frontend/repository/event_repository.dart';
import 'package:justmeet_frontend/repository/user_repository.dart';
import 'package:justmeet_frontend/routes.dart';
import 'package:justmeet_frontend/view/login_page.dart';
import 'package:justmeet_frontend/view/registration_page.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class JustMeetApp extends StatefulWidget {
  JustMeetApp({Key key}) : super(key: key);

  @override
  _JustMeetAppState createState() => _JustMeetAppState();
}

class _JustMeetAppState extends State<JustMeetApp> {
  Store<AppState> store;
  static final _navigatorKey = GlobalKey<NavigatorState>();
  final userRepo = UserRepository(FirebaseAuth.instance, new GoogleSignIn());
  final eventRepo = EventRepository();
  final attachmentRepo = AttachmentRepository(new CloudStorage());

  @override
  void initState() {
    super.initState();
    store = createStore(userRepo, eventRepo, attachmentRepo, _navigatorKey);
    store.dispatch(VerifyAuthenticationState());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return StoreProvider(
        store: store,
        child: ThemeProvider(
            saveThemesOnChange: true,
            loadThemeOnInit: true,
            themes: [
              AppTheme(
                id: "light",
                description: "Default",
                data: ThemeData(
                  primaryColor: Colors.purple,
                  accentColor: Colors.purple,
                  backgroundColor: Colors.white,
                ),
              ),
              AppTheme(
                id: "dark",
                description: "Dark",
                data: ThemeData(
                    primaryColor: Colors.black,
                    accentColor: Colors.white,
                    backgroundColor: Colors.white),
              ),
            ],
            child: ThemeConsumer(
              child: MaterialApp(
                title: 'Flutter Demo',
                navigatorKey: _navigatorKey,
                routes: {
                  Routes.login: (context) {
                    return LoginPage(
                      navigatorKey: _navigatorKey,
                    );
                  },
                  Routes.home: (context) {
                    return HomePage(
                      navigatorKey: _navigatorKey,
                    );
                  },
                  Routes.registration: (context) {
                    return RegistrationPage();
                  }
                },
              ),
            )
        )
    );
  }
}
