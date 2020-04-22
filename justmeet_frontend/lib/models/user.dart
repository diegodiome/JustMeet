import 'dart:convert';

enum UserStatus {
  online,
  offline
}

extension userStatusExtension on UserStatus {
  String get string {
    switch (this) {
      case UserStatus.online:
        return 'online';
      case UserStatus.offline:
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
    userEmail = json['userEmail'];
    userDisplayName = json['userDisplayName'];
    userUid = json['userUid'];
    userPhotoUrl = json['userPhotoUrl'];
    userToken = json['userToken'];
    userStatus = json['userStatus'].toString().compareTo(UserStatus.offline.toString()) == 0 ? UserStatus.offline : UserStatus.online;
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