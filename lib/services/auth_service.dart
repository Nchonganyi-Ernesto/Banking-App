import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() {
    print('🔄 AuthService: Setting up authStateChanges stream');
    return _auth.authStateChanges().map((user) {
      print('🔄 AuthStateChange: ${user?.email ?? "null"}');
      return user;
    });
  }

  User? get currentUser {
    final user = _auth.currentUser;
    print('👤 Current user: ${user?.email ?? "null"}');
    return user;
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    print('🔑 Attempting sign in with: $email');
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print('✅ Sign in successful: ${credential.user?.email}');
      return credential;
    } catch (e) {
      print('❌ Sign in failed: $e');
      rethrow;
    }
  }

  Future<UserCredential> createUserWithEmail(String email, String password) async {
    print('📝 Attempting registration with: $email');
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print('✅ Registration successful: ${credential.user?.email}');
      return credential;
    } catch (e) {
      print('❌ Registration failed: $e');
      rethrow;
    }
  }

  Future<void> updateDisplayName(String name) async {
    final user = currentUser;
    if (user != null) {
      await user.updateDisplayName(name.trim());
      await user.reload();
      print('✅ Display name updated to: $name');
    }
  }

  Future<void> updateEmail(String email) async {
    final user = currentUser;
    if (user != null) {
      // Firebase Auth v6 no longer exposes direct updateEmail on User.
      // This sends a verification email to the new address before it is applied.
      await user.verifyBeforeUpdateEmail(email.trim());
      await user.reload();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePassword(newPassword.trim());
      await user.reload();
    }
  }

  Future<UserCredential> reauthenticate(String email, String password) {
    final user = currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No signed in user found.',
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email.trim(),
      password: password.trim(),
    );

    return user.reauthenticateWithCredential(credential);
  }

  Future<void> signOut() {
    print('👋 Signing out');
    return _auth.signOut();
  }
}

