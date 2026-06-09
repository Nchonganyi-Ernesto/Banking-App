import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/auth_gate.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // ProviderScope is REQUIRED by Riverpod.
    // It acts as the global container that stores all providers (state).
    // Everything inside ProviderScope can read and watch providers.
    const ProviderScope(
      child: ZentraApp(),
    ),
  );
}

class ZentraApp extends StatelessWidget {
  const ZentraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zentra',

      // Remove the debug banner in the top-right corner.
      debugShowCheckedModeBanner: false,

      // Apply our custom theme (colors, fonts) defined in app_theme.dart.
      // Centralising it here means the whole app uses the same design system.
      theme: AppTheme.lightTheme,

      // AuthGate shows login UI when unauthenticated, dashboard when signed in.
      home: const AuthGate(),
    );
  }
}
