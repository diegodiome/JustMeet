import 'dart:async';
import 'package:flutter/material.dart';

/// Custom Search input field, showing the search and clear icons.
class MapSearchInput extends StatefulWidget {
  final ValueChanged<String> onSearchInput;

  MapSearchInput(this.onSearchInput);

  @override
  State<StatefulWidget> createState() {
    return MapSearchInputState();
  }
}

class MapSearchInputState extends State<MapSearchInput> {
  TextEditingController editController = TextEditingController();

  Timer debouncer;

  bool hasSearchEntry = false;

  MapSearchInputState();

  @override
  void initState() {
    super.initState();
    this.editController.addListener(this.onSearchInputChange);
  }

  @override
  void dispose() {
    this.editController.removeListener(this.onSearchInputChange);
    this.editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (this.editController.text.isEmpty) {
      this.debouncer?.cancel();
      widget.onSearchInput(this.editController.text);
      return;
    }

    if (this.debouncer?.isActive ?? false) {
      this.debouncer.cancel();
    }

    this.debouncer = Timer(Duration(milliseconds: 500), () {
      widget.onSearchInput(this.editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            color: Theme.of(context).textTheme.body1.color,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search place",
                border: InputBorder.none,
              ),
              controller: this.editController,
              onChanged: (value) {
                setState(() {
                  this.hasSearchEntry = value.isNotEmpty;
                });
              },
            ),
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
        color: Theme.of(context).canvasColor,
      ),
    );
  }
}