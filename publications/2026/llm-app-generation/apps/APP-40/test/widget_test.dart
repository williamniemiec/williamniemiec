// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:google_home_app/main.dart';

void main() {
  testWidgets('Google Home app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GoogleHomeApp());

    // Verify that the app loads with the correct title
    expect(find.text('My Home'), findsOneWidget);
    
    // Verify that the bottom navigation is present
    expect(find.text('Favorites'), findsOneWidget);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('Automations'), findsOneWidget);
    expect(find.text('Activity'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
