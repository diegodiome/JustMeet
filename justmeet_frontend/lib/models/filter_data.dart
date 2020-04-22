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

class DateFilterData {
  DateTime startDate;
  DateTime endDate;

  DateFilterData({this.startDate, this.endDate});
}

class DistanceFilterData {
  double maxDistance;

  DistanceFilterData({this.maxDistance});
}
