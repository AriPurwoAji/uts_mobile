import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/services/dio_clients.dart';
import '../../../core/services/secure_storage.dart';
import '../../../core/constants/api_constants.dart';

class AuthRepositoryImpl {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Register dengan email & password
  Future<void> register(String name, String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);
    await credential.user?.sendEmailVerification();
  }

  // Login dengan email & password
  Future<void> loginWithEmail(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (!credential.user!.emailVerified) {
      await _firebaseAuth.signOut();
      throw Exception('EMAIL_NOT_VERIFIED');
    }

    await _verifyTokenToBackend();
  }

  // Login dengan Google
  Future<void> loginWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign in dibatalkan');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await _firebaseAuth.signInWithCredential(credential);
    await _verifyTokenToBackend();
  }

  // Cek apakah email sudah diverifikasi
  Future<bool> checkEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  // Kirim ulang email verifikasi
  Future<void> resendVerificationEmail() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  // Verifikasi token ke backend
  Future<void> _verifyTokenToBackend() async {
    final idToken = await _firebaseAuth.currentUser?.getIdToken();
    if (idToken == null) throw Exception('Gagal mendapatkan Firebase token');

    final response = await DioClient.instance.post(
      ApiConstants.verifyToken,
      data: {'firebase_token': idToken},
    );

    final accessToken = response.data['data']['access_token'];
    await SecureStorage.saveToken(accessToken);
  }

  Future<void> verifyAfterEmailVerified() async {
  final user = _firebaseAuth.currentUser;

  if (user == null) {
    throw Exception('User tidak ditemukan');
  }

  await user.reload();

  if (!user.emailVerified) {
    throw Exception('Email belum diverifikasi');
  }

  await _verifyTokenToBackend();
}

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await SecureStorage.clearAll();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}