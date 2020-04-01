import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:renty_crud_version/debug/logger.dart';
import 'package:renty_crud_version/models/user.dart';
import 'package:renty_crud_version/locator.dart';
import 'firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  User _currentUser;
  User get currentUser => _currentUser;

  //Debug
  final log = getLogger('AuthService');

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _populateCurrentUser(authResult.user);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = User(
        id: authResult.user.uid,
        email: email,
        fullName: fullName,
      );

      await _firestoreService.createUser(_currentUser);

      return authResult.user != null;
    } catch (e) {
      //return e.message;
      return e.toString();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      GoogleSignInAccount account = await _googleSignIn.signIn();

      var res = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.getCredential(
        idToken: (await account.authentication).idToken,
        accessToken: (await account.authentication).accessToken,
      ));

      var firebaseUser = await _firebaseAuth.currentUser();
      _currentUser = User(
          id: firebaseUser.uid,
          fullName: firebaseUser.displayName,
          email: firebaseUser.email);

      await _firestoreService.createUser(_currentUser);
      log.d(firebaseUser.uid);
      await _populateCurrentUser(firebaseUser);

      return res != null;
    } catch (e) {
      log.d("Google sign in error: " + e.message);
    }
  }

  Future<bool> isUserLoggedIn() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    await _populateCurrentUser(user);
    return user != null;
  }

  Future _populateCurrentUser(FirebaseUser user) async {
    try {
      if (user != null) {
        log.d(user.uid);
        _currentUser = await _firestoreService.getUser(user.uid);
        log.d("Current User value: " + _currentUser.toString());
      }
    } catch (e) {
      log.d(e.toString());
    }
  }

  Future getUserDetails() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid.toString();
  }

  Future logOut() async {
    await _firebaseAuth.signOut();
  }
}
