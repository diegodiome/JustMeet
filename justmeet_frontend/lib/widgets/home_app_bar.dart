import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeAppBar extends StatelessWidget {
  
  final Function userFunction;
  
  const HomeAppBar({
    @required this.userFunction
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeProvider.themeOf(context).data.primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Events',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: userFunction,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.account_circle, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        if (ThemeProvider.themeOf(context).id == 'light') {
                          ThemeProvider.controllerOf(context).setTheme('dark');
                        } else {
                          ThemeProvider.controllerOf(context).setTheme('light');
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ThemeProvider.themeOf(context).id == 'light'
                              ? Icon(
                                  Icons.brightness_3,
                                  color: Colors.white,
                                )
                              : Icon(Icons.brightness_7, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}