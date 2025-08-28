import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:spotify_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpotifyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);

    // This is just a placeholder test since we don't have a counter
    // In a real app, you would test actual functionality
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
