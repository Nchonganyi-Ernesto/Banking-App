import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// ── What changed from the old version? ────────────────────────────────────
// OLD (Riverpod < 2.5):  class UserNotifier extends StateNotifier<UserModel>
// NEW (Riverpod 2.5+):   class UserNotifier extends Notifier<UserModel>
//
// The key difference:
// - Old: initial state was set in the constructor via super(initialState)
// - New: initial state is returned from a required build() method
// This new pattern is cleaner — build() acts like a widget's build() method.

class UserNotifier extends Notifier<UserModel> {
  // build() replaces the old constructor approach.
  // It runs once when the provider is first read, and returns the initial state.
  @override
  UserModel build() {
    return const UserModel(
      name: 'Tamon Joel',
      avatarUrl: '', // Using initials avatar for now
      balance: 4250.34,
      available: 5748.88,
      due: 1024.00,
      // These numbers draw the shape of the sparkline chart on the balance card
      sparklineData: [30, 70, 50, 90, 60, 80, 100, 75],
    );
  }

  // This method updates the balance — called when a transfer is made.
  // 'state' is now available from the parent Notifier class directly.
  void updateBalance(double newBalance) {
    state = UserModel(
      name: state.name,
      avatarUrl: state.avatarUrl,
      balance: newBalance,
      available: state.available,
      due: state.due,
      sparklineData: state.sparklineData,
    );
  }
}

// ── Provider Declaration ───────────────────────────────────────────────────
// OLD: StateNotifierProvider<UserNotifier, UserModel>
// NEW: NotifierProvider<UserNotifier, UserModel>
//
// Any widget using ref.watch(userProvider) will automatically rebuild
// whenever updateBalance() (or any other method that sets state) is called.
final userProvider = NotifierProvider<UserNotifier, UserModel>(() {
  return UserNotifier();
});
