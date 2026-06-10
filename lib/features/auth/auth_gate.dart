import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import 'screens/login_screen.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../onboarding/screens/onboarding_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // First check if onboarding is complete
    if (!OnboardingScreen.isCompleted()) {
      print('📱 Onboarding not completed, showing OnboardingScreen');
      return const OnboardingScreen();
    }

    // Then check auth state
    final authState = ref.watch(firebaseAuthStateProvider);

    print('🔐 AuthGate building with state: ${authState.runtimeType}');

    return authState.when(
      data: (user) {
        print('✅ AuthGate data: user is ${user == null ? "null (not signed in)" : "signed in as ${user.email}"}');
        if (user == null) {
          return const LoginScreen();
        }
        print('🎯 Navigating to DashboardScreen');
        return const DashboardScreen();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Authentication error:\n${error.toString()}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}