import 'package:flutter/material.dart';
import 'package:justmeet_frontend/models/autocomplete_item.dart';
import 'package:justmeet_frontend/models/rich_suggestion.dart';
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/widgets/home/home_search_input.dart';
import 'package:theme_provider/theme_provider.dart';

class HomeSearchBar extends StatefulWidget {
  final Function function;
  final GlobalKey homeKey;

  HomeSearchBar({
    @required this.function,
    this.homeKey
  });

  @override
  State<StatefulWidget> createState() {
    return HomeSearchBarState();
  }
}

class HomeSearchBarState extends State<HomeSearchBar> {

  /// Overlay to display autocomplete suggestions
  OverlayEntry overlayEntry;

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  EventRepository eventRepository;

  @override
  void initState() {
    eventRepository = EventRepository();
    super.initState();
  }

  @override
  void dispose() {
    this.overlayEntry?.remove();
    super.dispose();
  }

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (this.overlayEntry != null) {
      this.overlayEntry.remove();
      this.overlayEntry = null;
    }
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
                  child: HomeSearchInput((it) {
                    searchPlace(it);
                  }, key: widget.homeKey,)
                ),
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

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox =
    this.widget.homeKey.currentContext.findRenderObject();

    clearOverlay();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        top: appBarBox.size.height,
        child: Material(
          elevation: 1,
          child: Column(
            children: suggestions,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(this.overlayEntry);
  }

  void searchPlace(String place) {
    if (place == this.previousSearchTerm) {
      return;
    } else {
      previousSearchTerm = place;
    }

    if (context == null) {
      return;
    }

    clearOverlay();

    setState(() {
      hasSearchTerm = place.length > 0;
    });

    if (place.length < 1) {
      return;
    }

    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;

    final RenderBox appBarBox =
    this.widget.homeKey.currentContext.findRenderObject();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox.size.height,
        width: size.width,
        child: Material(
          elevation: 1,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: Text(
                    "Finding event...",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(this.overlayEntry);
    autoCompleteSearch(place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(String text) {
    //text = text.replaceAll(" ", "+");

    eventRepository
        .getEventPredictions(text)
        .then((value) {
      List<dynamic> predictions = value;

      List<RichSuggestion> suggestions = [];

      if (predictions.isEmpty) {
        print('Arrivato');
        AutoCompleteItem aci = AutoCompleteItem();
        aci.text = "No result found";
        aci.offset = 0;
        aci.length = 0;

        suggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (dynamic t in predictions) {
          AutoCompleteItem aci = AutoCompleteItem();
          aci.text = t['text'];
          aci.offset = t['detail'][0]['offset'];
          aci.length = t['detail'][0]['length'];

          suggestions.add(RichSuggestion(aci, () {
            //azione da fare cliccato il testo
          }));
        }
      }

      displayAutoCompleteSuggestions(suggestions);
    }).catchError((error) {
      print(error);
    });
  }
}