

class User {

  String email;
  String displayName;
  String uid;
  String photoUrl;
  String token;

  User({
    this.email,
    this.displayName,
    this.uid,
    this.photoUrl,
    this.token
  });

  User.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    displayName = json['displayName'];
    uid = json['uid'];
    photoUrl = json['photoUrl'];
    token = json['token'];
  }
}