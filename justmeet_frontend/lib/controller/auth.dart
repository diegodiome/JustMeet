
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'base_auth.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class Auth implements BaseAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String displayName;
  String email;
  String imageUrl;

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    assert(email != null);
    assert(password != null);

    final AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user;
  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    assert(email != null);
    assert(password != null);

    final AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return result.user.uid;
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    // Checking if email or name is null
    assert(user.email != null);
    assert(user.displayName != null);

    // set data
    displayName = user.displayName;
    email = user.email;
    if (user.photoUrl != null) {
      imageUrl = user.photoUrl;
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return currentUser.uid;
  }

  @override
  Future<String> getFirebaseToken() async{
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    assert(user != null);
    final idToken = await user.getIdToken();
    return idToken.token;
  }
}
