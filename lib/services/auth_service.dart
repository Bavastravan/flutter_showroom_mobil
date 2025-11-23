import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // === Cek User Login ===
  User? get currentUser => _auth.currentUser;

  // === Register User ===
  Future<User?> register({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _db.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'username': username,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return cred.user;
  }

  // === Login (Email/Password) ===
  Future<User?> loginWithEmail({required String email, required String password}) async {
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // === Login dengan Username/Phone/email (input fleksibel) ===
  Future<User?> loginWithUsernameOrPhone({
    required String input,
    required String password,
  }) async {
    String? email;
    if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(input)) {
      email = input;
    } else if (RegExp(r'^\d{8,}$').hasMatch(input)) {
      // Cari di Firestore field phone
      var snap = await _db.collection('users').where('phone', isEqualTo: input).limit(1).get();
      if (snap.docs.isNotEmpty) email = snap.docs.first['email'];
    } else {
      // Cari di Firestore field username
      var snap = await _db.collection('users').where('username', isEqualTo: input).limit(1).get();
      if (snap.docs.isNotEmpty) email = snap.docs.first['email'];
    }
    if (email == null) throw FirebaseAuthException(
      message: 'User tidak ditemukan!',
      code: 'user-not-found',
    );
    UserCredential cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // === Login Google ===
  Future<User?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    UserCredential cred = await _auth.signInWithCredential(credential);

    // Simpan ke Firestore jika user baru
    final doc = _db.collection('users').doc(cred.user!.uid);
    final docSnap = await doc.get();
    if (!docSnap.exists) {
      await doc.set({
        'email': cred.user?.email,
        'username': cred.user?.displayName ?? cred.user!.email!.split('@')[0],
        'phone': '',
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'google',
      });
    }
    return cred.user;
  }

  // === Login Apple (iOS/macOS, non-web saja!) ===
  Future<User?> loginWithApple() async {
    if (kIsWeb || !(Platform.isIOS || Platform.isMacOS)) {
      throw Exception('Sign In with Apple hanya tersedia di iOS atau macOS');
    }
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    UserCredential cred = await _auth.signInWithCredential(oauthCredential);

    // Simpan ke Firestore jika user baru
    final doc = _db.collection('users').doc(cred.user!.uid);
    final docSnap = await doc.get();
    if (!docSnap.exists) {
      await doc.set({
        'email': cred.user?.email,
        'username': cred.user?.displayName ?? cred.user!.email!.split('@')[0],
        'phone': '',
        'createdAt': FieldValue.serverTimestamp(),
        'provider': 'apple',
      });
    }
    return cred.user;
  }

  // === Reset Password via Email ===
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // === Logout ===
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut(); // Google signOut
    // Untuk Apple, logout cukup dengan _auth.signOut()
  }
}
