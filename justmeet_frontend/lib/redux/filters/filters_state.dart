import 'package:justmeet_frontend/models/filter_data.dart';

class FiltersState {
  List<CategoryFilterData> categoriesFilter;
  DistanceFilterData distanceFilter;
  DateFilterData dateFilterData;

  FiltersState(
      {this.distanceFilter, this.categoriesFilter, this.dateFilterData});

  factory FiltersState.initial() {
    return FiltersState(
        categoriesFilter: CategoryFilterData.defaultCategoriesList,
        distanceFilter: new DistanceFilterData(maxDistance: 50.0),
        dateFilterData: new DateFilterData(
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 5))));
  }

  FiltersState copyWith(
      {List<CategoryFilterData> categoriesFilter,
      DistanceFilterData distanceFilter,
      DateFilterData dateFilterData}) {
    return FiltersState(
        categoriesFilter: categoriesFilter ?? this.categoriesFilter,
        distanceFilter: distanceFilter ?? this.distanceFilter,
        dateFilterData: dateFilterData ?? this.dateFilterData);
  }
}
