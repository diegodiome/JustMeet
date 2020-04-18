
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/widgets/splash/splash_loader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theme_provider/theme_provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeProvider.themeOf(context).data.backgroundColor,
      child: Center(
        child: SplashLoader(
          color1: ThemeProvider.themeOf(context).data.primaryColor,
          color2: ThemeProvider.themeOf(context).data.accentColor,
          color3: ThemeProvider.themeOf(context).data.primaryColor,
        )
      ),
    );
  }
}