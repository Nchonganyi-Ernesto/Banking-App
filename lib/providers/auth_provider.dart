import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Keep the stream alive - don't use autoDispose
final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  print('🔄 firebaseAuthStateProvider: Creating stream');
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges();
});
