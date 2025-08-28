import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_photos_app/main.dart';

void main() {
  testWidgets('Google Photos app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GooglePhotosApp());

    // Verify that the app starts with bottom navigation
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Verify that all three tabs are present in the navigation
    expect(find.text('Photos'), findsWidgets);
    expect(find.text('Search'), findsWidgets);
    expect(find.text('Library'), findsWidgets);
  });

  testWidgets('Navigation between tabs works', (WidgetTester tester) async {
    await tester.pumpWidget(const GooglePhotosApp());

    // Find the bottom navigation bar
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);

    // Tap on the Search tab (index 1)
    await tester.tap(find.descendant(
      of: bottomNavBar,
      matching: find.text('Search'),
    ));
    await tester.pumpAndSettle();

    // Verify we're on the Search screen by looking for search-specific content
    expect(find.text('Try searching for'), findsOneWidget);

    // Tap on the Library tab (index 2)
    await tester.tap(find.descendant(
      of: bottomNavBar,
      matching: find.text('Library'),
    ));
    await tester.pumpAndSettle();

    // Verify we're on the Library screen by looking for library-specific content
    expect(find.text('Quick access'), findsOneWidget);
  });
}
