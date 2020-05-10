import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justmeet_frontend/models/autocomplete_item.dart';
import 'package:justmeet_frontend/models/rich_suggestion.dart';
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/repositories/user_repository.dart';
import 'package:justmeet_frontend/screens/event_info_view.dart';
import 'package:justmeet_frontend/screens/profile_page.dart';

class HomeSearchInput extends StatefulWidget {
  final GlobalKey<HomeSearchInputState> key;
  final UserRepository userRepository;

  const HomeSearchInput({this.key, this.userRepository}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeSearchInputState();
  }
}

class HomeSearchInputState extends State<HomeSearchInput> {
  final LayerLink _layerLink = LayerLink();
  TextEditingController editController = TextEditingController();
  FocusNode textEditingFocus = FocusNode();

  Timer debouncer;

  bool hasSearchEntry = false;

  /// Overlay to display autocomplete suggestions
  OverlayEntry overlayEntry;

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  EventRepository eventRepository;
  UserRepository userRepository;

  HomeSearchInputState();

  @override
  void initState() {
    super.initState();
    eventRepository = EventRepository();
    userRepository = UserRepository(FirebaseAuth.instance, new GoogleSignIn());
    this.editController.addListener(this.onSearchInputChange);
  }

  @override
  void dispose() {
    this.editController.removeListener(this.onSearchInputChange);
    this.editController.dispose();
    this.overlayEntry?.remove();
    super.dispose();
  }

  void onSearchInputChange() {
    if (this.editController.text.isEmpty) {
      this.debouncer?.cancel();
      searchPlace(this.editController.text);
      return;
    }

    if (this.debouncer?.isActive ?? false) {
      this.debouncer.cancel();
    }

    this.debouncer = Timer(Duration(milliseconds: 500), () {
      searchPlace(this.editController.text);
    });
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
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  focusNode: textEditingFocus,
                  decoration: InputDecoration(
                    hintText: "Search event",
                    border: InputBorder.none,
                  ),
                  controller: this.editController,
                  onChanged: (value) {
                    setState(() {
                      this.hasSearchEntry = value.isNotEmpty;
                    });
                  },
                )),
          ),
          SizedBox(
            width: 8,
          ),
          this.hasSearchEntry
              ? GestureDetector(
                  child: Icon(
                    Icons.clear,
                  ),
                  onTap: () {
                    this.editController.clear();
                    setState(() {
                      this.hasSearchEntry = false;
                    });
                  },
                )
              : SizedBox(),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
    );
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final RenderBox renderBox = context.findRenderObject();
    Size size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    final RenderBox appBarBox = widget.key.currentContext.findRenderObject();

    clearOverlay();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
          width: size.width,
          top: appBarBox.size.height + offset.dy + 20.0,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height),
            child: Material(
              elevation: 1,
              child: Column(
                children: suggestions,
              ),
            ),
          )),
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
    var offset = renderBox.localToGlobal(Offset.zero);

    final RenderBox appBarBox = widget.key.currentContext.findRenderObject();

    this.overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox.size.height + offset.dy + 20.0,
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
    text = text.replaceAll(" ", "+");

    eventRepository.getEventPredictions(text).then((value) {
      List<dynamic> predictions = value;

      List<RichSuggestion> suggestions = [];

      if (predictions.isEmpty) {
        AutoCompleteItem aci = AutoCompleteItem();
        aci.text = "No result found";
        aci.offset = 0;
        aci.length = 0;

        suggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (dynamic t in predictions) {
          AutoCompleteItem aci = AutoCompleteItem();
          aci.id = t['id'];
          aci.text = t['text'];
          aci.autoCompleteItemType = t['type'].toString().compareTo('Event') == 0 ? AutoCompleteItemType.Event : AutoCompleteItemType.User;
          aci.offset = t['detail']['offset'];
          aci.length = t['detail']['length'];

          suggestions.add(RichSuggestion(aci, () {
            editController.clear();
            textEditingFocus.unfocus();
            switch(aci.autoCompleteItemType) {
              case AutoCompleteItemType.Event:
                eventRepository.getEvent(aci.id).then((event) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => EventInfoView(
                          event: event,
                        ),
                        fullscreenDialog: true),
                  );
                });
                break;
              case AutoCompleteItemType.User:
                userRepository.getUser(aci.id).then((user) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage(
                      isDisabled: true,
                      user: user,
                    )),
                  );
                });
                break;
            }
          }));
        }
      }
      displayAutoCompleteSuggestions(suggestions);
    }).catchError((error) {
      print(error);
    });
  }
}
