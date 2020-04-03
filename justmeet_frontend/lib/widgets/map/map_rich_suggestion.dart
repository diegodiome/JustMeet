import 'package:flutter/material.dart';
import 'package:justmeet_frontend/controllers/map_helper.dart';

class MapRichSuggestion extends StatelessWidget {
  final VoidCallback onTap;
  final MapAutoCompleteItem autoCompleteItem;

  MapRichSuggestion(this.autoCompleteItem, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RichText(
                    text: TextSpan(children: getStyledTexts(context)),
                  ),
                )
              ],
            )),
        onTap: this.onTap,
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final List<TextSpan> result = [];

    String startText =
    this.autoCompleteItem.text.substring(0, this.autoCompleteItem.offset);
    if (startText.isNotEmpty) {
      result.add(
        TextSpan(
          text: startText,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      );
    }

    String boldText = this.autoCompleteItem.text.substring(
        this.autoCompleteItem.offset,
        this.autoCompleteItem.offset + this.autoCompleteItem.length);

    result.add(TextSpan(
      text: boldText,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).textTheme.body1.color,
      ),
    ));

    String remainingText = this
        .autoCompleteItem
        .text
        .substring(this.autoCompleteItem.offset + this.autoCompleteItem.length);
    result.add(
      TextSpan(
        text: remainingText,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    );

    return result;
  }
}