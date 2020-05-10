import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:justmeet_frontend/models/filter_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/redux/filters/filters_action.dart';
import 'package:justmeet_frontend/widgets/calendar/calendar_popup_view.dart';
import 'package:justmeet_frontend/widgets/filter/slider_view.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class FiltersListView extends StatefulWidget {
  @override
  _FiltersListViewState createState() => _FiltersListViewState();
}

class _FiltersListViewState extends State<FiltersListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  bool barrierDismissible = true;

  @override
  void initState() {
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: animationController.value,
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  if (barrierDismissible) {
                    Navigator.pop(context);
                  }
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24.0)),
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    distanceViewUI(),
                                    const Divider(
                                      height: 1,
                                    ),
                                    categoriesViewUi(),
                                    const Divider(
                                      height: 1,
                                    ),
                                    rangeDateViewUI(),
                                    const Divider(
                                      height: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 16, top: 8),
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: ThemeProvider.themeOf(context)
                                      .data
                                      .primaryColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24.0)),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      blurRadius: 8,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24.0)),
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await StoreProvider.of<AppState>(context)
                                          .dispatch(OnFilterEventUpdate());
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Apply',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget categoriesViewUi() {
    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        return Flexible(
            child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: store.state.filtersState.categoriesFilter
                    .asMap()
                    .map((index, filter) => MapEntry(
                        index,
                        CheckboxListTile(
                          activeColor:
                              ThemeProvider.themeOf(context).data.primaryColor,
                          title: Text(filter.titleTxt),
                          value: filter.isSelected,
                          onChanged: (val) {
                            store.dispatch(OnCategoriesFilterUpdate(
                                index: index, value: val));
                          },
                        )))
                    .values
                    .toList()));
      },
    );
  }

  void showDemoDialog({BuildContext context}) {
    showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) => StoreBuilder(
        builder: (context, Store<AppState> store) {
          return CalendarPopupView(
            barrierDismissible: true,
            minimumDate: DateTime.now(),
            initialEndDate: store.state.filtersState.dateFilterData.endDate,
            initialStartDate: store.state.filtersState.dateFilterData.startDate,
            onApplyClick: (DateTime startData, DateTime endData) {
              if (startData != null && endData != null) {
                store.dispatch(OnDateFilterUpdate(
                    newDateFilterData: new DateFilterData(
                        startDate: startData, endDate: endData)));
              }
            },
            onCancelClick: () {},
          );
        },
      ),
    );
  }

  Widget rangeDateViewUI() {
    return StoreBuilder(
      builder: (context, Store<AppState> store) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    showDemoDialog(context: context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 4, bottom: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Choose date range',
                          style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                              color: ThemeProvider.themeOf(context).data.primaryColor.withOpacity(0.8)),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${DateFormat("dd, MMM").format(store.state.filtersState.dateFilterData.startDate)} - ${DateFormat("dd, MMM").format(store.state.filtersState.dateFilterData.endDate)}',
                          style: TextStyle(
                            color: ThemeProvider.themeOf(context).data.primaryColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
        );
      },
    );
  }

  Widget distanceViewUI() {
    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 8),
              child: Text(
                'Distance from my position',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SliderView(
              distValue: store.state.filtersState.distanceFilter.maxDistance,
              onChangedistValue: (double value) {
                store.dispatch(OnDistanceFilterUpdate(
                    newDistanceFilterData:
                        new DistanceFilterData(maxDistance: value)));
              },
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        );
      },
    );
  }
}
