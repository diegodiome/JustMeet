
enum AutoCompleteItemType {Event, User}

class AutoCompleteItem {

  AutoCompleteItemType autoCompleteItemType;

  String id;

  String text;

  int offset;

  int length;
}