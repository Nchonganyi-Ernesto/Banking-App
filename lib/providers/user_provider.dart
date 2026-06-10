import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../providers/auth_provider.dart';

// Provider for FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Stream provider that listens to real-time user data from Firestore
final userStreamProvider = StreamProvider.autoDispose<UserModel>((ref) async* {
  final authState = await ref.watch(firebaseAuthStateProvider.future);
  
  if (authState == null) {
    yield const UserModel(
      name: 'Guest',
      avatarUrl: '',
      balance: 0.0,
      available: 0.0,
      sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
    );
    return;
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  
  await for (final snapshot in firestoreService.streamUserData(authState.uid)) {
    if (!snapshot.exists || snapshot.data() == null) {
      // Return default user with zero balance if document doesn't exist
      yield UserModel(
        name: authState.displayName ?? 'User',
        avatarUrl: '',
        balance: 0.0,
        available: 0.0,
        sparklineData: const [30, 70, 50, 90, 60, 80, 100, 75],
      );
    } else {
      yield UserModel.fromFirestore(snapshot.data()!);
    }
  }
});

// Simple provider that returns user data
final userProvider = Provider<UserModel>((ref) {
  final userStream = ref.watch(userStreamProvider);
  
  return userStream.when(
    data: (user) => user,
    loading: () => const UserModel(
      name: 'Loading...',
      avatarUrl: '',
      balance: 0.0,
      available: 0.0,
      sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
    ),
    error: (error, _) {
      print('User provider error: $error');
      return const UserModel(
        name: 'Error',
        avatarUrl: '',
        balance: 0.0,
        available: 0.0,
        sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
      );
    },
  );
});

// Helper provider for user operations
final userActionsProvider = Provider<UserActions>((ref) {
  return UserActions(ref);
});

class UserActions {
  final Ref ref;
  
  UserActions(this.ref);
  
  // Update balance in Firestore
  Future<void> updateBalance(double newBalance) async {
    final authState = await ref.read(firebaseAuthStateProvider.future);
    if (authState == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateUserBalance(
      authState.uid,
      newBalance,
      newBalance, // For now, available = balance
    );
  }

  // Add amount to current balance (e.g., quiz rewards)
  Future<void> addBalance(double amount) async {
    final currentUser = ref.read(userProvider);
    final newBalance = currentUser.balance + amount;
    await updateBalance(newBalance);
  }
}
