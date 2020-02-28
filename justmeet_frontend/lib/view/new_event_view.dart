import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justmeet_frontend/cloud_storage.dart';
import 'package:justmeet_frontend/controller/base_auth.dart';
import 'package:justmeet_frontend/controller/events_controller.dart';
import 'package:justmeet_frontend/model/event_list_data.dart';

class NewEventView extends StatefulWidget {
  final EventsController eventsController;
  final BaseAuth auth;
  NewEventView({@required this.eventsController, @required this.auth});

  @override
  _NewEventViewState createState() => _NewEventViewState();
}

// Declare this variable
int selectedRadio;
var categories = ['Studio', 'Lavoro', 'Teatro', 'Ricreativo'];
CloudStorage storage;

class _NewEventViewState extends State<NewEventView> {
  File _image;
  EventListData eventToAdd;

  @override
  void initState() {
    super.initState();
    storage = new CloudStorage();
    eventToAdd = new EventListData();
    setSelectedRadio(1);
    eventToAdd.eventDate = DateTime.parse('2020-02-26 11:00:00');
    eventToAdd.eventLocation = 'Civitanova Marche';
    eventToAdd.isPrivate = false;
  }

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      eventToAdd.eventCategory = categories[val - 1];
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    getEventForm(),
                    Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16, top: 8),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24.0)),
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              try {
                                if (_image != null) {
                                  setState(() {
                                    eventToAdd.eventImageUrl =
                                        storage.saveFile(_image);
                                  });
                                }
                                await widget.eventsController
                                    .addNewEvent(widget.auth, eventToAdd);
                                Navigator.pop(context);
                              } catch (e) {
                                print('Error creating new event : $e');
                              }
                            },
                            child: Center(
                              child: Text(
                                'Create',
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
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Create new event',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  Widget getEventForm() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16, top: 8, bottom: 8, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 4, bottom: 4),
                        child: TextField(
                          onChanged: (String txt) {
                            setState(() {
                              eventToAdd.eventName = txt;
                            });
                          },
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Event name...',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.add),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 16, top: 8, bottom: 8, left: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 4, bottom: 4),
                        child: TextField(
                          onChanged: (String txt) {
                            setState(() {
                              eventToAdd.eventDescription = txt;
                            });
                          },
                          maxLength: 100,
                          maxLines: 3,
                          cursorColor: Colors.amber,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Event description...',
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.short_text),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 10)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          },
                        ),
                        Text("Studio"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 2,
                          groupValue: selectedRadio,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          },
                        ),
                        Text("Lavoro"),
                      ],
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.all(20)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 3,
                          groupValue: selectedRadio,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          },
                        ),
                        Text("Teatro"),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 4,
                          groupValue: selectedRadio,
                          activeColor: Colors.amber,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          },
                        ),
                        Text("Ricreativo"),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                GestureDetector(
                  onTap: getImage,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.add_a_photo,
                      size: 25,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.amber.shade300),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                _image != null ? Icon(Icons.check) : Text('Pick an image')
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.map,
                      size: 25,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.amber.shade300),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 20)),
                Text('Choose location')
              ],
            )
          ],
        ));
  }

  getImage() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }
}
