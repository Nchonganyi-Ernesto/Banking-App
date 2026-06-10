import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/auth/auth_gate.dart';
import 'firebase_options.dart';

void main() async {
  print('🚀 App starting...');
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔥 Initializing Firebase...');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('✅ Firebase initialized');

  print('🎯 Starting app with ProviderScope...');
  runApp(
    const ProviderScope(
      child: ZentraApp(),
    ),
  );
}

class ZentraApp extends ConsumerWidget {
  const ZentraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('🏗️ Building ZentraApp');
    
    return MaterialApp(
      title: 'Zentra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Always show AuthGate at root - it will handle onboarding check too
      home: const AuthGate(),
    );
  }
}