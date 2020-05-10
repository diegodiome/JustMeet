import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:justmeet_frontend/models/event.dart';
import 'package:justmeet_frontend/models/reporting.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/models/user_reporting.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/repositories/event_repository.dart';
import 'package:justmeet_frontend/screens/event_info_view.dart';
import 'package:justmeet_frontend/screens/request_page.dart';
import 'package:justmeet_frontend/utils/event_helper.dart';
import 'package:justmeet_frontend/widgets/profile/profile_edit_dialog.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final bool isDisabled;

  ProfilePage({@required this.user, @required this.isDisabled});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  EventRepository eventRepository;
  List<Event> userEvents = List();

  @override
  void initState() {
    eventRepository = EventRepository();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Event>> getEvents() {
    return eventRepository.getUserEvents(widget.user.userUid);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Color(0xFFFA624F),
    ));
    return Scaffold(
        body: ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 350.0,
              width: double.infinity,
            ),
            Container(
              height: 200.0,
              width: double.infinity,
              color: Color(0xFFFA624F),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                  ));
                  Navigator.of(context).pop();
                },
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 125.0,
              left: 15.0,
              right: 15.0,
              child: Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(7.0),
                child: Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 75.0,
              left: (MediaQuery.of(context).size.width / 2 - 50.0),
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    image: DecorationImage(
                        image: widget.user.userPhotoUrl != null
                            ? FirebaseImage(widget.user.userPhotoUrl)
                            : AssetImage('assets/images/hotel_3.png'),
                        fit: BoxFit.cover)),
              ),
            ),
            Positioned(
              top: 190.0,
              left: (MediaQuery.of(context).size.width / 2) - 105.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.user.userEmail,
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    widget.user.userDisplayName != null
                        ? widget.user.userDisplayName
                        : '',
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        color: widget.isDisabled ?  Colors.grey : ThemeProvider.themeOf(context).data.primaryColor,
                        onPressed: () {
                          if(!widget.isDisabled) {
                            showDialog<dynamic>(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) => ProfileEditDialog(),
                            );
                          }
                        },
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        color: widget.isDisabled ?  Colors.grey : ThemeProvider.themeOf(context).data.primaryColor,
                        onPressed: () {
                          if(!widget.isDisabled) {
                            showDialog<dynamic>(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) => RequestPage(user: StoreProvider.of<AppState>(context).state.userState.currentUser,),
                            );
                          }
                        },
                        child: Text(
                          'Requests',
                          style: TextStyle(
                              fontFamily: 'Comfortaa',
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      PopupMenuButton<ReportingType>(
                        onSelected: (ReportingType result) {
                          StoreProvider.of<AppState>(context).dispatch(OnUserReporting(
                              userReporting: UserReporting(
                                  userId: widget.user.userUid,
                                  reportingCreator: StoreProvider.of<AppState>(context).state.userState.currentUser.userUid,
                                  reportingType: result
                              )
                          ));
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<ReportingType>>[
                          const PopupMenuItem<ReportingType>(
                            value: ReportingType.Spam,
                            child: Text('Spam'),
                          ),
                          const PopupMenuItem<ReportingType>(
                            value: ReportingType.Content,
                            child: Text('Proibited content'),
                          ),
                          const PopupMenuItem<ReportingType>(
                            value: ReportingType.Language,
                            child: Text('Offensive language'),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Events',
                style: TextStyle(
                    fontFamily: 'Comfortaa',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Column(
          children: <Widget>[
            FutureBuilder<List<Event>>(
                future: getEvents(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return menuCard(
                            snapshot.data[index].eventName,
                            snapshot.data[index].eventImageUrl,
                            snapshot.data[index].eventCategory,
                            snapshot.data[index].eventRates, () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            Navigator.push<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) => EventInfoView(
                                    event: snapshot.data[index],
                                  ),
                                  fullscreenDialog: true),
                            );
                            });
                        });
                  } else {
                    return Container();
                  }
                }),
            SizedBox(height: 12.0),
          ],
        ),
      ],
    ));
  }

  Widget menuCard(String title, String imgPath, String type, List<double> rates, VoidCallback function) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: GestureDetector(
      onTap: function,
      child: Material(
        borderRadius: BorderRadius.circular(7.0),
        elevation: 4.0,
        child: Container(
          height: 125.0,
          //width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0), color: Colors.white),
          child: Row(
            children: <Widget>[
              SizedBox(width: 10.0),
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FirebaseImage(imgPath), fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(7.0)),
              ),
              SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15.0),
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    type,
                    style: TextStyle(
                        fontFamily: 'Comfortaa',
                        color: Colors.grey,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 7.0),
                  SmoothStarRating(
                    allowHalfRating: true,
                    starCount: 5,
                    rating: averageRating(rates),
                    size: 20,
                    color: ThemeProvider.themeOf(context).data.primaryColor,
                    borderColor: ThemeProvider.themeOf(context).data.primaryColor,
                  ),
                  SizedBox(height: 4.0),
                ],
              )
            ],
          ),
        ),
      ),)
    );
  }
}
