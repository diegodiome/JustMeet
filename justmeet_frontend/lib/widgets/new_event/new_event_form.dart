import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justmeet_frontend/controllers/map_helper.dart';
import 'package:justmeet_frontend/models/event_list_data.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/event/event_action.dart';
import 'package:justmeet_frontend/repositories/attachment_repository.dart';
import 'package:justmeet_frontend/widgets/map/map_page.dart';

class NewEventForm extends StatefulWidget {
  NewEventForm({@required this.attachmentRepository});

  final AttachmentRepository attachmentRepository;

  @override
  _NewEventFormState createState() => _NewEventFormState();
}

class _NewEventFormState extends State<NewEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameEventTextEditingController = TextEditingController();
  final _descriptionEventTextEditingController = TextEditingController();

  EventListData eventToAdd;
  int selectedRadio;

  var categories = ['Studio', 'Lavoro', 'Teatro', 'Ricreativo'];

  File _image;
  String _imageUrl;

  @override
  void initState() {
    eventToAdd = new EventListData();
    setSelectedRadio(1);
    super.initState();
  }

  @override
  void dispose() {
    _nameEventTextEditingController.dispose();
    _descriptionEventTextEditingController.dispose();
    super.dispose();
  }

  setSelectedRadio(int val) {
    setState(() {
      eventToAdd.eventCategory = categories[val - 1];
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final submitCallback = () async {
      if (_image != null) {
        await widget.attachmentRepository.uploadImage(_image).then((imageUrl) {
          setState(() {
            _imageUrl = imageUrl;
          });
        });
      } else {
        setState(() {
          _imageUrl = '';
        });
      }
      EventListData newEvent = new EventListData(
          eventAdmin: 'diomedi79@gmail.com',
          eventName: _nameEventTextEditingController.text,
          eventDescription: _descriptionEventTextEditingController.text,
          eventCategory: eventToAdd.eventCategory,
          eventDate: DateTime.parse('2020-02-26 11:00:00'),
          eventLocation: 'Civitanova Marche',
          eventImageUrl: _imageUrl,
          isPrivate: false);
      if (_formKey.currentState.validate()) {
        final createEventAction = OnCreateEvent(newEvent: newEvent);

        StoreProvider.of<AppState>(context).dispatch(createEventAction);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("Create event...")));

        createEventAction.completer.future.catchError((error) {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('$error')));
        });
      }
    };

    final _nameEventTextField = TextFormField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Event name',
          icon: Icon(Icons.email)),
      controller: _nameEventTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter name";
        }
        return null;
      },
    );

    final _descriptionEventTextField = TextFormField(
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Event description',
          icon: Icon(Icons.email)),
      controller: _descriptionEventTextEditingController,
      validator: (value) {
        if (value.isEmpty) {
          return "Please enter a description";
        }
        return null;
      },
    );

    return Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
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
                          child: _nameEventTextField),
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
                          child: _descriptionEventTextField),
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
                    child: _image != null ? null : Icon(Icons.image),
                    decoration: BoxDecoration(
                        image: _image != null
                            ? DecorationImage(
                                image: FileImage(_image), fit: BoxFit.cover)
                            : null,
                        shape: BoxShape.rectangle,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
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
                  onTap: () async {
                    MapLocationResult locationResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(
                                searchInput: true,
                                gestureEnabled: true,
                                mapStyle: MAP_STYLE.DARK,
                              )),
                    );
                  },
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
            ),
            Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
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
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: submitCallback,
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
          ])),
    );
  }

  getImage() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }
}
