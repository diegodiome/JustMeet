import 'package:justmeet_frontend/models/filter_data.dart';
import 'package:redux/redux.dart';
import 'filters_action.dart';
import 'filters_state.dart';

final filtersReducers = combineReducers<FiltersState>([
  TypedReducer<FiltersState, OnDistanceFilterUpdate>(_onDistanceFilterUpdate),
  TypedReducer<FiltersState, OnCategoriesFilterUpdate>(
      _onCategoriesFilterUpdate),
  TypedReducer<FiltersState, OnDateFilterUpdate>(_onDateFilterUpdate)
]);

FiltersState _onDistanceFilterUpdate(
    FiltersState state, OnDistanceFilterUpdate action) {
  return state.copyWith(distanceFilter: action.newDistanceFilterData);
}

FiltersState _onDateFilterUpdate(
    FiltersState state, OnDateFilterUpdate action) {
  return state.copyWith(dateFilterData: action.newDateFilterData);
}

FiltersState _onCategoriesFilterUpdate(
    FiltersState state, OnCategoriesFilterUpdate action) {
  List<CategoryFilterData> categoriesFilter = state.categoriesFilter;
  categoriesFilter[action.index].isSelected = action.value;
  return state.copyWith(categoriesFilter: categoriesFilter);
}
