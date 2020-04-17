import 'package:justmeet_frontend/models/filter_data.dart';

class FiltersState {
  List<CategoryFilterData> categoriesFilter;
  DistanceFilterData distanceFilter;

  FiltersState({this.distanceFilter, this.categoriesFilter});

  factory FiltersState.initial() {
    return FiltersState(
        categoriesFilter: CategoryFilterData.defaultCategoriesList,
        distanceFilter: new DistanceFilterData(maxDistance: 50.0));
  }

  FiltersState copyWith(
      {List<CategoryFilterData> categoriesFilter,
      DistanceFilterData distanceFilter}) {
    return FiltersState(
        categoriesFilter: categoriesFilter ?? this.categoriesFilter,
        distanceFilter: distanceFilter ?? this.distanceFilter);
  }
}
