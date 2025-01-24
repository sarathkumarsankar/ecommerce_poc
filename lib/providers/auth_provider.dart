import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoggedIn;
  final String? email;
  final String? userId;

  const AuthState({required this.isLoggedIn, this.email, this.userId});

  AuthState copyWith({bool? isLoggedIn, String? email, String? userId}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      userId: userId ?? this.userId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;

  AuthNotifier(this._auth) : super(const AuthState(isLoggedIn: false)) {
    _restoreAuthState();
  }

  Future<void> registration(String email, String password, String name) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = AuthState(
          isLoggedIn: true, email: email, userId: userCredential.user?.uid);
          saveName(name: name, userId: userCredential.user?.uid ?? "");
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      if (e.code == 'email-already-in-use') {
        log('This email is already in use. Please try another email.');
      } else if (e.code == 'invalid-email') {
        log('The email address is not valid. Please enter a valid email.');
      } else if (e.code == 'weak-password') {
        log('The password is too weak. Please enter a stronger password.');
      } else {
        log('Registration failed: ${e.message}');
      }
    } catch (e) {
      // Handle other unexpected errors
      log('An unexpected error occurred: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = AuthState(
          isLoggedIn: true, email: email, userId: userCredential.user?.uid);
    } catch (e) {
      // Handle errors
      log('Login failed: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    state = const AuthState(isLoggedIn: false);
  }

  Future<void> saveName({required String name, required String userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileName_$userId', name);
  }

  Future<void> _restoreAuthState() async {
    final user = _auth.currentUser;
    if (user != null) {
      final email = user.email;
      state = AuthState(isLoggedIn: true, email: email, userId: user.uid);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  return AuthNotifier(firebaseAuth);
});
