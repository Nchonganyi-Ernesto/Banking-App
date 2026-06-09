import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> createUserWithEmail(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> updateDisplayName(String name) async {
    final user = currentUser;
    if (user != null) {
      await user.updateDisplayName(name.trim());
      await user.reload();
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
    return _auth.signOut();
  }
}
