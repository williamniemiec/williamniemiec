import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:threads_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ThreadsApp());

    // Verify that the app starts with the splash screen or auth screen
    expect(find.text('Threads'), findsOneWidget);
  });
}
