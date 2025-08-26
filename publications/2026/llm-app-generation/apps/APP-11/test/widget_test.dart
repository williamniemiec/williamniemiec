import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paypal_app/main.dart';

void main() {
  testWidgets('PayPal app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PayPalApp());

    // Verify that the app starts with the home screen
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('PayPal Balance'), findsOneWidget);

    // Verify bottom navigation is present
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
    expect(find.text('Deals'), findsOneWidget);

    // Test navigation to Payments tab
    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();
    expect(find.text('Send Money'), findsOneWidget);

    // Test navigation to Wallet tab
    await tester.tap(find.text('Wallet'));
    await tester.pumpAndSettle();
    expect(find.text('Payment Methods'), findsOneWidget);

    // Test navigation to Deals tab
    await tester.tap(find.text('Deals'));
    await tester.pumpAndSettle();
    expect(find.text('Available'), findsOneWidget);
  });
}
