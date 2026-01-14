import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:demo/main.dart' as app;

/// Flutter integration test for Firebase Test Lab.
/// Tests the basic functionality of the editable PIN field demo app.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Editable PIN Field Demo App', () {
    testWidgets('App launches and displays main button', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify the main button is displayed
      expect(find.text('My Pin Code Editor'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('Navigate to PIN editor screen', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Tap the button to navigate to PIN editor
      await tester.tap(find.text('My Pin Code Editor'));
      await tester.pumpAndSettle();

      // Verify PIN editor screen is displayed
      expect(find.text('Dummy Editor'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('PIN editor displays 6 input fields', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to PIN editor
      await tester.tap(find.text('My Pin Code Editor'));
      await tester.pumpAndSettle();

      // Verify 6 PIN input fields are displayed
      expect(find.byType(TextField), findsNWidgets(6));
    });

    testWidgets('Can input values in PIN fields', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to PIN editor
      await tester.tap(find.text('My Pin Code Editor'));
      await tester.pumpAndSettle();

      // Find the first text field
      final firstField = find.byType(TextField).first;

      // Tap and enter a value
      await tester.tap(firstField);
      await tester.pumpAndSettle();
      await tester.enterText(firstField, '1');
      await tester.pumpAndSettle();

      // Verify the text was entered
      expect(find.text('1'), findsWidgets);
    });

    testWidgets('Navigate back from PIN editor', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Navigate to PIN editor
      await tester.tap(find.text('My Pin Code Editor'));
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back at the home screen
      expect(find.text('My Pin Code Editor'), findsOneWidget);
      expect(find.text('Dummy Editor'), findsNothing);
    });
  });
}
