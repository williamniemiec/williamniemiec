import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pinterest_app/main.dart';

void main() {
  testWidgets('Pinterest app basic test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PinterestApp());

    // Verify that the splash screen is displayed initially
    expect(find.text('Pinterest'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('App structure test', (WidgetTester tester) async {
    await tester.pumpWidget(const PinterestApp());
    
    // Verify the app is built with MaterialApp
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Verify ProviderScope is present
    expect(find.byType(ProviderScope), findsOneWidget);
  });

  testWidgets('Theme test', (WidgetTester tester) async {
    await tester.pumpWidget(const PinterestApp());
    
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    
    // Verify theme is set
    expect(app.theme, isNotNull);
    expect(app.darkTheme, isNotNull);
    expect(app.themeMode, ThemeMode.system);
  });

  testWidgets('Navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const PinterestApp());
    
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    
    // Verify routes are configured
    expect(app.routes, isNotNull);
    expect(app.routes!.containsKey('/main'), isTrue);
  });

  testWidgets('Splash screen elements test', (WidgetTester tester) async {
    await tester.pumpWidget(const PinterestApp());
    
    // Verify splash screen elements
    expect(find.text('Pinterest'), findsOneWidget);
    expect(find.text('Visual discovery engine for finding and organizing inspiration'), findsOneWidget);
    expect(find.byIcon(Icons.push_pin), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
