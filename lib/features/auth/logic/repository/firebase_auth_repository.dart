import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xave/core/models/account.dart';
import 'package:xave/features/auth/logic/repository/auth_repository.dart';

/// An implementation of [IAuthRepository] with [FirebaseAuth]
class FirebaseAuthRepository implements IAuthRepository {
  /// Initializes a new [FirebaseAuthRepository].
  FirebaseAuthRepository({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
      : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  final FirebaseAuth _auth;

  final GoogleSignIn _googleSignIn;

  @override
  Future<Account> login() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final creds = await _auth.signInWithCredential(credential);
      final user = creds.user;
      if (user != null) {
        return Account(
          uuid: user.uid,
          email: user.email!,
          name: user.displayName!,
          imageURL: user.photoURL,
        );
      }
      throw const AuthException(message: 'user not found');
    } on FirebaseException catch (e) {
      throw AuthException(message: e.message);
    } on AuthException {
      rethrow;
    }
  }

  @override
  Stream<Account?> get loggedAccountState {
    final controller = StreamController<Account?>();
    final sink = controller.sink;
    _auth.authStateChanges().listen((event) {
      Account? account;
      if (event != null) {
        account = Account(
          uuid: event.uid,
          email: event.email!,
          name: event.displayName!,
          imageURL: event.photoURL,
        );
      }
      sink.add(account);
    });
    return controller.stream;
  }

  @override
  Future<void> logout() => _auth.signOut();
}
