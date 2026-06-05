import 'package:orbit/services/auth_services.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthServices _authServices = AuthServices();

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isLoggedIn => _authServices.isLoggedIn;
  bool get isEmailVerified => _authServices.isEmailVerified;

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authServices.signUpWithEmailPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authServices.signInWithEmailPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      await _authServices.forgotPassword(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      _isLoading =true;
      _error = null;
      notifyListeners();
      await _authServices.emailVerification();
    } catch(e) {
      _error =e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> checkEmailVerification() async {
    await _authServices.currentUser?.reload();

    return _authServices.currentUser?.emailVerified ?? false;
  }

  Future<void> signInWithGoogle() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      await _authServices.signInWithGoogle();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authServices.signOut();
    notifyListeners();
  }
}