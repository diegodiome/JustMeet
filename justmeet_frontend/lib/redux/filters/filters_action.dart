import 'package:justmeet_frontend/models/filter_data.dart';

class OnDistanceFilterUpdate {
  DistanceFilterData newDistanceFilterData;

  OnDistanceFilterUpdate({this.newDistanceFilterData});
}

class OnDateFilterUpdate {
  DateFilterData newDateFilterData;

  OnDateFilterUpdate({this.newDateFilterData});
}

class OnCategoriesFilterUpdate {
  final bool value;
  final int index;

  OnCategoriesFilterUpdate({this.value, this.index});
}
