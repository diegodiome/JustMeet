import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/autocomplete_item.dart';
import 'package:justmeet_frontend/models/rich_suggestion.dart';
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/widgets/home/home_search_input.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeSearchBar extends StatefulWidget {
  final Function function;

  HomeSearchBar({@required this.function});

  @override
  State<StatefulWidget> createState() {
    return HomeSearchBarState();
  }
}

class HomeSearchBarState extends State<HomeSearchBar> {

  GlobalKey<HomeSearchInputState> homeKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeProvider.themeOf(context).data.backgroundColor,
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
                    child: HomeSearchInput(key: homeKey,
                    )),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ThemeProvider.themeOf(context).data.primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: widget.function,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(Icons.search, size: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
