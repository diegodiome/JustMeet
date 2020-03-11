import 'dart:async';
import 'dart:io';

class OnUploadEventImage {
  File localImage;
  Completer completer;

  OnUploadEventImage({
    this.localImage,
    Completer completer
  }) : completer = completer ?? Completer();
}