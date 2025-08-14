// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guardian_firewall/main.dart';

void main() {
  testWidgets('DashboardScreen UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GuardianFirewallApp());

    // Verify the initial state is "Protected".
    expect(find.text('Protected'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Tap the switch to turn off protection.
    await tester.tap(find.byType(Switch));
    await tester.pump();

    // Verify the state changes to "Unprotected".
    expect(find.text('Unprotected'), findsOneWidget);
  });
}
