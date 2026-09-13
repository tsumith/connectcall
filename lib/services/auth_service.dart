import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(FirebaseAuth.instance, ref.read(userServiceProvider));
});

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;

  AuthService(this._firebaseAuth, this._userService);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_firebaseAuth.currentUser != null) {
        await _userService.updateOnlineStatus(
          _firebaseAuth.currentUser!.uid,
          true,
        );
      }
    } catch (e) {
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  Future<void> registerWithEmail(
    String name,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _userService.createUserProfile(user.uid, name, email);
        await _userService.updateOnlineStatus(user.uid, true);
      }
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      if (_firebaseAuth.currentUser != null) {
        await _userService.updateOnlineStatus(
          _firebaseAuth.currentUser!.uid,
          false,
        );
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out: ${e.toString()}');
    }
  }
}
