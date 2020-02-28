import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:theme_provider/theme_provider.dart';

import 'controller/auth.dart';
import 'root_page.dart';

class JustMeetApp extends StatefulWidget {
  JustMeetApp({Key key}) : super(key: key);

  @override
  _JustMeetAppState createState() => _JustMeetAppState();
}

class _JustMeetAppState extends State<JustMeetApp> {
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
    return ThemeProvider(
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
              backgroundColor: Colors.white
            ),
          ),
        ],
        child: ThemeConsumer(
          child: MaterialApp(
            title: 'Flutter Demo',
            home: RootPage(
              auth: new Auth(),
            ),
          ),
        ));
  }
}
