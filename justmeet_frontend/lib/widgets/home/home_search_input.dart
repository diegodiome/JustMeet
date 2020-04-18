import 'dart:async';

import 'package:flutter/material.dart';

class HomeSearchInput extends StatefulWidget {
  final ValueChanged<String> onSearchInput;

  const HomeSearchInput(this.onSearchInput, {GlobalKey key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeSearchInputState();
  }
}

class HomeSearchInputState extends State<HomeSearchInput> {
  TextEditingController editController = TextEditingController();

  Timer debouncer;

  bool hasSearchEntry = false;

  HomeSearchInputState();

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
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
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
        color: Colors.white,
      ),
    );
  }
}
