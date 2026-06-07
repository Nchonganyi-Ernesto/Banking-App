import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentra/main.dart';

void main() {
  testWidgets('Smoke test - finds Zentra and Your Balance', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: ZentraApp(),
      ),
    );

    // Verify that our app renders 'Your Balance'
    expect(find.text('Your\nBalance'), findsOneWidget);
  });
}
