import 'package:google_maps_flutter/google_maps_flutter.dart';

class CategoryFilterData {
  CategoryFilterData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<CategoryFilterData> defaultCategoriesList = <CategoryFilterData>[
    CategoryFilterData(
      titleTxt: 'Studio',
      isSelected: true,
    ),
    CategoryFilterData(
      titleTxt: 'Lavoro',
      isSelected: true,
    ),
    CategoryFilterData(
      titleTxt: 'Sport',
      isSelected: true,
    ),
    CategoryFilterData(
      titleTxt: 'Intrattenimento',
      isSelected: true,
    ),
  ];
}

class DistanceFilterData {
  LatLng fromPosition;
  double maxDistance;

  DistanceFilterData({this.fromPosition, this.maxDistance});
}
