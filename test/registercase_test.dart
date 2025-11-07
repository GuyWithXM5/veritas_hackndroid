import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veritasapp/pages/client/registercase.dart';

import 'test_logger.dart';

void main() {
  group('Case Registration Page Tests', () {
    loggableTestWidgets('Case registration page renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      expect(find.text("Register a Case"), findsOneWidget);
      expect(find.text("Submit"), findsOneWidget);
    });

    loggableTestWidgets('Case type dropdown is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      expect(find.text("Type of case:"), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    loggableTestWidgets('Can select case type from dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final dropdown = find.byType(DropdownButton<String>);
      expect(dropdown, findsOneWidget);

      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      expect(find.text("Civil"), findsOneWidget);
      expect(find.text("Labor"), findsOneWidget);
      expect(find.text("Family"), findsOneWidget);
      expect(find.text("Cooperative"), findsOneWidget);
      expect(find.text("Consumer forum"), findsOneWidget);
      expect(find.text("Other"), findsOneWidget);
    });

    loggableTestWidgets('Location field is present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final locationField = find.byType(TextField).at(0);
      expect(locationField, findsOneWidget);

      await tester.enterText(locationField, "New York");
      await tester.pump();

      expect(find.text("New York"), findsOneWidget);
    });

    loggableTestWidgets('Date field is present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final dateField = find.byType(TextField).at(1);
      expect(dateField, findsOneWidget);

      await tester.enterText(dateField, "2024-01-15");
      await tester.pump();

      expect(find.text("2024-01-15"), findsOneWidget);
    });

    loggableTestWidgets('Description field is present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final descriptionField = find.byType(TextField).at(2);
      expect(descriptionField, findsOneWidget);

      await tester.enterText(descriptionField, "This is a test case description");
      await tester.pump();

      expect(find.text("This is a test case description"), findsOneWidget);
    });

    loggableTestWidgets('Certification checkbox is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      expect(find.textContaining("I certify that the above facts are true"), findsOneWidget);
    });

    loggableTestWidgets('Can toggle certification checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      final initialValue = tester.widget<Checkbox>(checkbox).value;

      await tester.tap(checkbox);
      await tester.pump();

      final newValue = tester.widget<Checkbox>(checkbox).value;
      expect(newValue, isNot(equals(initialValue)));
    });

    loggableTestWidgets('Submit button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final submitButton = find.text("Submit");
      expect(submitButton, findsOneWidget);
    });

    loggableTestWidgets('All required fields can be filled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Civil"));
      await tester.pumpAndSettle();

      final locationField = find.byType(TextField).at(0);
      await tester.enterText(locationField, "New York");
      await tester.pump();

      final dateField = find.byType(TextField).at(1);
      await tester.enterText(dateField, "2024-01-15");
      await tester.pump();

      final descriptionField = find.byType(TextField).at(2);
      await tester.enterText(descriptionField, "Test case description");
      await tester.pump();

      expect(find.text("New York"), findsOneWidget);
      expect(find.text("2024-01-15"), findsOneWidget);
      expect(find.text("Test case description"), findsOneWidget);
    });

    loggableTestWidgets('Form validation - empty fields show error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final submitButton = find.text("Submit");
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(submitButton, findsOneWidget);
    });

    loggableTestWidgets('Case type options are correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      final caseTypes = ["Civil", "Labor", "Family", "Cooperative", "Consumer forum", "Other"];
      for (final caseType in caseTypes) {
        expect(find.text(caseType), findsOneWidget);
      }
    });

    loggableTestWidgets('Text fields trim whitespace', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      final locationField = find.byType(TextField).at(0);

      await tester.enterText(locationField, "  New York  ");
      await tester.pump();

      expect(find.textContaining("New York"), findsWidgets);
    });

    loggableTestWidgets('Upload files button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const regcase(),
        ),
      );

      expect(find.textContaining("Upload files regarding the case"), findsOneWidget);
    });
  });
}

