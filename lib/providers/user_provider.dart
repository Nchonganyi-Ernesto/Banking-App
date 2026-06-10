import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../providers/auth_provider.dart';

// Provider for FirestoreService
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Stream provider that listens to real-time user data from Firestore
final userStreamProvider = StreamProvider<UserModel?>((ref) {
  final firebaseUser = ref.watch(firebaseAuthStateProvider).value;
  
  if (firebaseUser == null) {
    return Stream.value(null);
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  
  return firestoreService.streamUserData(firebaseUser.uid).map((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) {
      // Return default user with zero balance if document doesn't exist
      return UserModel(
        name: firebaseUser.displayName ?? 'User',
        avatarUrl: '',
        balance: 0.0,
        available: 0.0,
        sparklineData: const [30, 70, 50, 90, 60, 80, 100, 75],
      );
    }
    return UserModel.fromFirestore(snapshot.data()!);
  });
});

// Notifier for updating user data
class UserNotifier extends Notifier<UserModel> {
  @override
  UserModel build() {
    // Watch the stream and return current user data
    final userStream = ref.watch(userStreamProvider);
    
    return userStream.when(
      data: (user) => user ?? const UserModel(
        name: 'User',
        avatarUrl: '',
        balance: 0.0,
        available: 0.0,
        sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
      ),
      loading: () => const UserModel(
        name: 'Loading...',
        avatarUrl: '',
        balance: 0.0,
        available: 0.0,
        sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
      ),
      error: (_, _) => const UserModel(
        name: 'Error',
        avatarUrl: '',
        balance: 0.0,
        available: 0.0,
        sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
      ),
    );
  }

  // Update balance in Firestore
  Future<void> updateBalance(double newBalance) async {
    final firebaseUser = ref.read(firebaseAuthStateProvider).value;
    if (firebaseUser == null) return;

    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateUserBalance(
      firebaseUser.uid,
      newBalance,
      newBalance, // For now, available = balance
    );
  }

  // Add amount to current balance (e.g., quiz rewards)
  Future<void> addBalance(double amount) async {
    final currentUser = state;
    final newBalance = currentUser.balance + amount;
    await updateBalance(newBalance);
  }
}

// Main user provider - NotifierProvider
final userProvider = NotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
