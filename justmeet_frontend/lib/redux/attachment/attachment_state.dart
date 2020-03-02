
import 'package:flutter/cupertino.dart';

@immutable
class AttachmentState {

  final String storageImageUrl;

  AttachmentState({
    this.storageImageUrl
  });

  factory AttachmentState.initial() {
    return new AttachmentState(
      storageImageUrl: ''
    );
  }

  AttachmentState copyWith({
    String storageImageUrl
  }) {
    return new AttachmentState(
      storageImageUrl: storageImageUrl ?? this.storageImageUrl
    );
  }
}