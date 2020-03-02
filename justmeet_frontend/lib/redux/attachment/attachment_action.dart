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

class OnImageStream {
  String localImageUrl;
  Completer completer;

  OnImageStream({
    this.localImageUrl, 
    Completer completer
  }) : completer = completer ?? Completer();
}

class OnImageStramSuccess{
  String storageImageUrl;

  OnImageStramSuccess(this.storageImageUrl);
}