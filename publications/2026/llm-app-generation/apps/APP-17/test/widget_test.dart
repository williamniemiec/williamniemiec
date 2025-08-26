// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tea_app/main.dart';

void main() {
  testWidgets('Tea app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TeaApp(hasCompletedOnboarding: false));

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that we can find the onboarding screen elements
    expect(find.text('Welcome to Tea'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('Tea app with completed onboarding', (WidgetTester tester) async {
    // Build our app with completed onboarding
    await tester.pumpWidget(const TeaApp(hasCompletedOnboarding: true));

    // Wait for the app to initialize
    await tester.pumpAndSettle();

    // Verify that we can find the loading screen or home screen elements
    expect(find.text('Tea'), findsAtLeastNWidgets(1));
  });
}
