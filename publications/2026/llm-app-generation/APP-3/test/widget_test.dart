// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apex_altimeter/main.dart';

void main() {
  testWidgets('Renders dashboard screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ApexAltimeter());

    // Verify that the dashboard screen is rendered.
    expect(find.text('Apex Altimeter'), findsOneWidget);
    // Verify that the bottom navigation bar is rendered.
    expect(find.byIcon(Icons.dashboard), findsOneWidget);
    expect(find.byIcon(Icons.map), findsOneWidget);
    expect(find.byIcon(Icons.history), findsOneWidget);
  });
}
