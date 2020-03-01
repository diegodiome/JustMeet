

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:justmeet_frontend/model/user.dart';

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
    await updateUserToken(null);
    await _firebaseAuth.signOut();
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
    return await fromFirebaseUser(authResult.user);
  }

  Future<void> updateUserToken(String token) async {

  }

  Future<void> updateUser(User user) async {
    
  }

  Stream<User> getAuthenticationStateChange() {
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
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        token: await getUserToken(firebaseUser),
        uid: firebaseUser.uid,
        photoUrl: firebaseUser.photoUrl
      );
    }
    return Future.value(null);
  } 

  Future<User> getUser(userId) async{
    return null;
  }
}