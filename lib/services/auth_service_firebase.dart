import 'package:blood_management_app/authentication/email_verification.dart';
import 'package:blood_management_app/services/navigation_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<void> setPersistence() async {
    if (kIsWeb) {
      Logger().i('Web platform detected. Settign persistence to LOCAL');
      await _firebaseAuth.setPersistence(Persistence.LOCAL);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await setPersistence();

    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Logger().e('Failed to sign in. Error: ${e.message}');
      rethrow;
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await Future.delayed(const Duration(seconds: 4));
  }

  User? get currentUser {
    return _firebaseAuth.currentUser;
  }
}
