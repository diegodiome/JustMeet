

class FilterListData {
  FilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<FilterListData> popularFList = <FilterListData>[
    FilterListData(
      titleTxt: 'Free Breakfast',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Free Parking',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Pool',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: 'Pet Friendly',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Free wifi',
      isSelected: false,
    ),
  ];

  static List<FilterListData> accomodationList = [
    FilterListData(
      titleTxt: 'All',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Apartment',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Home',
      isSelected: true,
    ),
    FilterListData(
      titleTxt: 'Villa',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Hotel',
      isSelected: false,
    ),
    FilterListData(
      titleTxt: 'Resort',
      isSelected: false,
    ),
  ];
}