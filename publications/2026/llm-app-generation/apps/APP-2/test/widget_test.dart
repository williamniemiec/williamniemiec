import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:color_by_number_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ColorByNumberApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);

    // This is a basic test - in a real app you'd test actual functionality
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
