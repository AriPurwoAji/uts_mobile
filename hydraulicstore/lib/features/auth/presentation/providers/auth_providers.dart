import 'package:flutter/material.dart';
import '../../data/auth_repository_impl.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepo = AuthRepositoryImpl();

  AuthStatus _status = AuthStatus.initial;
  String _errorMessage = '';

  AuthStatus get status => _status;
  String get errorMessage => _errorMessage;

  // Register
  Future<bool> register(String name, String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authRepo.register(name, email, password);
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Login dengan email
  Future<bool> loginWithEmail(String email, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authRepo.loginWithEmail(email, password);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Login dengan Google
  Future<bool> loginWithGoogle() async {
    _status = AuthStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authRepo.loginWithGoogle();
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _parseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // Cek email verified
  Future<bool> checkEmailVerified() async {
    return await _authRepo.checkEmailVerified();
  }

  // Kirim ulang email verifikasi
  Future<void> resendVerificationEmail() async {
    try {
      await _authRepo.resendVerificationEmail();
    } catch (e) {
      _errorMessage = _parseError(e.toString());
      notifyListeners();
    }
  }

  // Set authenticated setelah verify email
  void setAuthenticated() {
    _status = AuthStatus.authenticated;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await _authRepo.logout();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  String _parseError(String error) {
    if (error.contains('EMAIL_NOT_VERIFIED')) return 'Email belum diverifikasi';
    if (error.contains('user-not-found')) return 'Email tidak ditemukan';
    if (error.contains('wrong-password')) return 'Password salah';
    if (error.contains('email-already-in-use')) return 'Email sudah digunakan';
    if (error.contains('weak-password')) return 'Password terlalu lemah';
    if (error.contains('invalid-email')) return 'Format email tidak valid';
    return 'Terjadi kesalahan. Coba lagi.';
  }
}