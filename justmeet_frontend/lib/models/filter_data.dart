
class FilterData {
  FilterData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<FilterData> defaultCategoriesList = <FilterData>[
    FilterData(
      titleTxt: 'Studio',
      isSelected: true,
    ),
    FilterData(
      titleTxt: 'Lavoro',
      isSelected: true,
    ),
    FilterData(
      titleTxt: 'Sport',
      isSelected: true,
    ),
    FilterData(
      titleTxt: 'Intrattenimento',
      isSelected: true,
    ),
  ];

}