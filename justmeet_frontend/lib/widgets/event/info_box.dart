

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class InfoBox extends StatelessWidget {

  static const Color nearlyWhite = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF3A5160);


  final String text1, text2;

  InfoBox({@required this.text1, @required this.text2});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: ThemeProvider.themeOf(context).data.primaryColor,
                ),
              ),
              Text(
                '/$text2',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}