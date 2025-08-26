import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duolingo_clone/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DuolingoCloneApp());

    // Verify that our app starts with the navigation structure
    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Leagues'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
