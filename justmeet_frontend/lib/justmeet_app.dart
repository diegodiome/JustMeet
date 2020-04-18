import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/auth/auth_actions.dart';
import 'package:justmeet_frontend/redux/location/location_action.dart';
import 'package:justmeet_frontend/redux/store.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/repositories/comment_repository.dart';
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/repositories/map_repository.dart';
import 'package:justmeet_frontend/repositories/user_repository.dart';
import 'package:justmeet_frontend/routes.dart';
import 'package:justmeet_frontend/screens/home_page.dart';
import 'package:justmeet_frontend/screens/login_page.dart';
import 'package:justmeet_frontend/screens/registration_page.dart';
import 'package:justmeet_frontend/screens/splash_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class JustMeetApp extends StatefulWidget {
  JustMeetApp({Key key}) : super(key: key);

  @override
  _JustMeetAppState createState() => _JustMeetAppState();
}

class _JustMeetAppState extends State<JustMeetApp> with WidgetsBindingObserver {
  Store<AppState> store;
  static final _navigatorKey = GlobalKey<NavigatorState>();
  final userRepo = UserRepository(FirebaseAuth.instance, new GoogleSignIn());
  final eventRepo = EventRepository();
  final commentRepo = CommentRepository();
  final mapRepo = MapRepository();

  @override
  void initState() {
    super.initState();
    store = createStore(userRepo, eventRepo, commentRepo, mapRepo, _navigatorKey);
    store.dispatch(VerifyCurrentLocationState());
    store.dispatch(VerifyAuthenticationState());
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if(store.state.authState.isAuthenticated) {
        store.dispatch(OnUserStatusUpdate(
          status: UserStatus.ONLINE
        ));
      }
    }
    else if(state == AppLifecycleState.inactive) {
      if(store.state.authState.isAuthenticated) {
        store.dispatch(OnUserStatusUpdate(
          status: UserStatus.OFFLINE
        ));
      }
    }
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
                  Routes.splash: (context) {
                    return SplashPage();
                  },
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
                    return RegistrationPage(
                      navigatorKey: _navigatorKey
                    );
                  }
                },
              ),
            )
        )
    );
  }
}
