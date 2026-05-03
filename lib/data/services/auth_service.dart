import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:pukaar/shared/utils/app_log.dart';

class SignInCancelledException implements Exception {
  SignInCancelledException();
  @override
  String toString() => 'SignInCancelledException';
}

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<UserCredential> signInWithGoogle() async {
    pukaarLog('AuthService.signInWithGoogle: GoogleSignIn.signIn (start)', tag: 'Pukaar.AuthService');
    final account = await _googleSignIn.signIn();
    if (account == null) {
      pukaarLog('AuthService.signInWithGoogle: user cancelled (account=null)', tag: 'Pukaar.AuthService');
      throw SignInCancelledException();
    }
    pukaarLog(
      'AuthService.signInWithGoogle: account id=${account.id} email=${account.email}',
      tag: 'Pukaar.AuthService',
    );
    final auth = await account.authentication;
    pukaarLog(
      'AuthService.signInWithGoogle: tokens accessToken=${auth.accessToken != null} idToken=${auth.idToken != null}',
      tag: 'Pukaar.AuthService',
    );
    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    pukaarLog('AuthService.signInWithGoogle: signInWithCredential (start)', tag: 'Pukaar.AuthService');
    final cred = await _auth.signInWithCredential(credential);
    pukaarLog(
      'AuthService.signInWithGoogle: signInWithCredential ok uid=${cred.user?.uid}',
      tag: 'Pukaar.AuthService',
    );
    // Do not await Firestore: a slow/hung users/{uid} write strands the login spinner.
    unawaited(
      _ensureUserDoc(cred.user).catchError(
        (Object e, StackTrace st) => pukaarLog(
          'AuthService: ensureUserDoc failed',
          tag: 'Pukaar.AuthService',
          error: e,
          stackTrace: st,
        ),
      ),
    );
    return cred;
  }

  Future<void> _ensureUserDoc(User? user) async {
    if (user == null) {
      pukaarLog('AuthService._ensureUserDoc: skip (user null)', tag: 'Pukaar.AuthService');
      return;
    }
    pukaarLog('AuthService._ensureUserDoc: users/${user.uid} get()', tag: 'Pukaar.AuthService');
    final doc = _firestore.collection('users').doc(user.uid);
    final snap = await doc.get();
    if (snap.exists) {
      pukaarLog('AuthService._ensureUserDoc: doc exists, skip set', tag: 'Pukaar.AuthService');
      return;
    }
    pukaarLog('AuthService._ensureUserDoc: set() new user doc', tag: 'Pukaar.AuthService');
    await doc.set(<String, dynamic>{
      'displayName': user.displayName,
      'email': user.email,
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    });
    pukaarLog('AuthService._ensureUserDoc: set() done', tag: 'Pukaar.AuthService');
  }

  Future<void> signOut() async {
    pukaarLog('AuthService.signOut: start', tag: 'Pukaar.AuthService');
    await Future.wait<void>([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
    pukaarLog('AuthService.signOut: done', tag: 'Pukaar.AuthService');
  }
}
