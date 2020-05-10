import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:justmeet_frontend/models/event_request.dart';
import 'package:justmeet_frontend/models/user_reporting.dart';
import 'package:justmeet_frontend/utils/request_header.dart';
import 'package:justmeet_frontend/models/user.dart';
import 'package:justmeet_frontend/redux/config.dart';

class UserRepository {

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  const UserRepository(
    this._firebaseAuth,
    this._googleSignIn
  );

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final firebaseUser = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, 
      password: password);
    return await fromFirebaseUser(firebaseUser.user);
  }

  Future<void> signOut() async {
    await updateUserStatus(UserStatus.offline);
    await _firebaseAuth.signOut();
  }

  Future<void> updateFcmToken(String userId) async {
    Response response;
    response = await put(
        putUpdateFcmToken(userId, await getFcmToken()),
        headers: await RequestHeader().getBasicHeader(),
    );
    int statusCode = response.statusCode;
    if(statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<String> getFcmToken() async {
    final FirebaseMessaging _fcm = FirebaseMessaging();
    return await _fcm.getToken();
  }

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = 
      await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken, 
      accessToken: googleSignInAuthentication.accessToken
    ); 
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(credential);
    return initUser(authResult.user);
  }

  Future<User> initUser(FirebaseUser firebaseUser) async {
    if(firebaseUser != null) {
      User newUser = new User(
          userEmail: firebaseUser.email,
          userDisplayName: 'Guest',
          userToken: await getUserToken(firebaseUser),
          userUid: firebaseUser.uid,
          userPhotoUrl: 'gs://justmeet-538b1.appspot.com/default_avatar.png',
          userStatus: UserStatus.online
      );
      return newUser;
    }
    return Future.value(null);
  }

  Future<void> updateUser(User user) async {
    Response response;
    response = await put(
      putUpdateUserApiUrl,
      headers: await RequestHeader().getBasicHeader(),
      body: user.toJson()
    );
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      await updateFirebaseUser(user);
    }
  }
  
  Future<void> updateFirebaseUser(User user) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.userDisplayName;
    updateInfo.photoUrl = user.userPhotoUrl;
    await firebaseUser.updateProfile(updateInfo);
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email, 
      password: password
    );
    await createUser(await initUser(authResult.user));
  }

  Stream<User> getAuthenticationStateChange(){
    return _firebaseAuth.onAuthStateChanged.asyncMap((firebaseUser) {
      return fromFirebaseUser(firebaseUser); 
    });
  }

  Future<String> getUserToken(FirebaseUser firebaseUser) async{
    final tokenId = await firebaseUser.getIdToken();
    return tokenId.token;
  }

  Future<User> fromFirebaseUser(FirebaseUser firebaseUser) async {
    if(firebaseUser != null) {
      return new User(
        userEmail: firebaseUser.email,
        userDisplayName: firebaseUser.displayName != null ? firebaseUser.displayName : 'Guest',
        userToken: await getUserToken(firebaseUser),
        userUid: firebaseUser.uid,
        userPhotoUrl: firebaseUser.photoUrl != null ? firebaseUser.photoUrl : 'gs://justmeet-538b1.appspot.com/default_avatar.png',
        userStatus: UserStatus.online
      );
    }
    return Future.value(null);
  }

  Future<void> addUserReporting(UserReporting userReporting) async {
    Response response;
    response = await post(
        postAddUserReportingUrl,
        headers: await RequestHeader().getBasicHeader(),
    body: userReporting.toJson());
    int statusCode = response.statusCode;
    if (statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<void> updateUserStatus(UserStatus status) async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    Response response;
    response = await put(
      putUpdateUserStatusUrl(firebaseUser.uid, status.string),
      headers: await RequestHeader().getBasicHeader()
    );
    int statusCode = response.statusCode;
    if(statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<void> updateUserToken(String token) async {
    FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    Response response;
    response = await put(
        putUpdateUserTokenUrl(firebaseUser.uid, token),
        headers: await RequestHeader().getBasicHeader()
    );
    int statusCode = response.statusCode;
    if(statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<void> acceptRequest(String userId, String eventId) async {
    Response response;
    response = await put(
        putAcceptRequestUrl(userId, eventId),
        headers: await RequestHeader().getBasicHeader()
    );
    int statusCode = response.statusCode;
    if(statusCode != 200) {
      print('Connection error: $statusCode');
    }
  }

  Future<List<EventRequest>> getRequests(String userId) async {
    Response response;
    response = await get(
        getRequestsUrl(userId),
        headers: await RequestHeader().getBasicHeader()
    );
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      Iterable<dynamic> l = json.decode(response.body);
      return l.map((model) => EventRequest.fromJson(model)).toList();
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }

  Future<void> createUser(User user) async {
    Response response;
    response = await post(
        postCreateUserApiUrl,
        headers: await RequestHeader().getBasicHeader(),
        body: user.toJson()
    );
    int statusCode = response.statusCode;
    if(statusCode != 200) {
      print('Create user connection error. $statusCode');
    }
  }


  Future<User> getUser(userId) async {
    Response response;
    response = await get(
      getUserUrl(userId),
      headers: await RequestHeader().getBasicHeader()
    );
    int statusCode = response.statusCode;
    if(statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    print('Connection error: $statusCode');
    return Future.value(null);
  }
}