import 'dart:convert';

enum UserStatus {
  ONLINE,
  OFFLINE
}

extension userStatusExtension on UserStatus {
  String get string {
    switch (this) {
      case UserStatus.ONLINE:
        return 'online';
      case UserStatus.OFFLINE:
        return 'offline';
      default:
        return null;
    }
  }
}

class User {

  String userEmail;
  String userDisplayName;
  String userUid;
  String userPhotoUrl;
  String userToken;
  UserStatus userStatus;

  User({
    this.userDisplayName,
    this.userEmail,
    this.userPhotoUrl,
    this.userToken,
    this.userUid,
    this.userStatus
  });

  User.fromJson(Map<String, dynamic> json) {
    userEmail = json['email'];
    userDisplayName = json['displayName'];
    userUid = json['uid'];
    userPhotoUrl = json['photoUrl'];
    userToken = json['token'];
    userStatus = json['userStatus'];
  }

  String toJson() {
    return json.encode({
      "userEmail": userEmail,
      "userDisplayName": userDisplayName,
      "userUid": userUid,
      "userPhotoUrl": userPhotoUrl,
      "userToken": userToken,
      "userStatus": userStatus.string
    });
  }
}