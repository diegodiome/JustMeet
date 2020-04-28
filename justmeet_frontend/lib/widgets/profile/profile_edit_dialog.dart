
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/redux/app/app_state.dart';
import 'package:justmeet_frontend/redux/user/user_action.dart';
import 'package:justmeet_frontend/repositories/attachment_repository.dart';
import 'package:redux/redux.dart';
import 'package:theme_provider/theme_provider.dart';

class ProfileEditDialog extends StatefulWidget {
  @override
  _ProfileEditDialogState createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> with TickerProviderStateMixin{

  AnimationController animationController;
  bool barrierDismissible = true;
  AttachmentRepository attachmentRepository = new AttachmentRepository(FirebaseStorage.instance);
  final _displayNameEditingController = TextEditingController();

  File _image;

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
    _displayNameEditingController.dispose();
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
                                    editContentUI(),
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
                                      if(_displayNameEditingController.text == '' && _image == null) {
                                        Navigator.pop(context);
                                        return;
                                      } else {
                                        User userUpdated = StoreProvider.of<AppState>(context).state.userState.currentUser;
                                        if(_displayNameEditingController.text.compareTo(StoreProvider.of<AppState>(context).state.userState.currentUser.userDisplayName) != 0) {
                                          userUpdated.userDisplayName = _displayNameEditingController.text;
                                        }
                                        else if(_image != null) {
                                          await attachmentRepository.uploadImage(_image).then((imageUrl) {
                                            userUpdated.userPhotoUrl = imageUrl;
                                          });
                                        }
                                        StoreProvider.of<AppState>(context).dispatch(OnUpdateUser(userUpdated: userUpdated));
                                        Navigator.pop(context);
                                        return;
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        'Edit',
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

  Widget editContentUI() {
    final _displayNameTextField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          border: InputBorder.none,
          labelText: "Display Name",
          icon: Icon(Icons.account_circle)),
      controller: _displayNameEditingController
    );

    return StoreBuilder(
      builder: (context, Store<AppState> store) {
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: _displayNameTextField,
            ),
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
                            ? DecorationImage(image: FileImage(_image), fit: BoxFit.cover)
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
          ],
        );
      },
    );
  }

  getImage() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }
}
