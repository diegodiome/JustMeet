

import 'package:firebase_auth/firebase_auth.dart';

class RequestHeader {

  static final RequestHeader _singleton = RequestHeader._internal();

  factory RequestHeader() {
    return _singleton;
  }

  RequestHeader._internal(); 

  Future<Map<String, String>> getBasicHeader() async{
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    final tokenId = await firebaseUser.
    getIdToken();
    final token = tokenId.token;
    Map<String,String> headers = {
      "Content-type": "application/json",
      "accept": "application/json",
      "Authorization": "$token"
    };
    return headers;
  }
}