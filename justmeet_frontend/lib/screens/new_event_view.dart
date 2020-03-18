import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:justmeet_frontend/repositories/attachment_repository.dart';
import 'package:justmeet_frontend/widgets/new_event/new_event_app_bar.dart';
import 'package:justmeet_frontend/widgets/new_event/new_event_form.dart';

class NewEventView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    AttachmentRepository attachmentRepository = new AttachmentRepository(FirebaseStorage.instance);
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            NewEventAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    NewEventForm(
                      attachmentRepository: attachmentRepository,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
