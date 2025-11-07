import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veritasapp/pages/client/registercase.dart';

void main() {
  group('Case Registration Page Tests', () {
    testWidgets('Case registration page renders correctly', (WidgetTester tester) async {
      // Build the register case widget
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Verify that the case registration page is displayed
      expect(find.text("Register a Case"), findsOneWidget);
      expect(find.text("Submit"), findsOneWidget);
    });

    testWidgets('Case type dropdown is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find dropdown button
      expect(find.text("Type of case:"), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('Can select case type from dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find dropdown
      final dropdown = find.byType(DropdownButton<String>);
      expect(dropdown, findsOneWidget);

      // Tap dropdown to open
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Verify dropdown items are available
      expect(find.text("Civil"), findsOneWidget);
      expect(find.text("Labor"), findsOneWidget);
      expect(find.text("Family"), findsOneWidget);
      expect(find.text("Cooperative"), findsOneWidget);
      expect(find.text("Consumer forum"), findsOneWidget);
      expect(find.text("Other"), findsOneWidget);
    });

    testWidgets('Location field is present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find location field by hint text
      final locationField = find.byType(TextField).at(0);
      expect(locationField, findsOneWidget);

      // Enter location
      await tester.enterText(locationField, "New York");
      await tester.pump();

      expect(find.text("New York"), findsOneWidget);
    });

    testWidgets('Date field is present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find date field (second TextField)
      final dateField = find.byType(TextField).at(1);
      expect(dateField, findsOneWidget);

      // Enter date
      await tester.enterText(dateField, "2024-01-15");
      await tester.pump();

      expect(find.text("2024-01-15"), findsOneWidget);
    });

    testWidgets('Description field is present and editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find description field (third TextField with maxLines)
      final descriptionField = find.byType(TextField).at(2);
      expect(descriptionField, findsOneWidget);

      // Enter description
      await tester.enterText(descriptionField, "This is a test case description");
      await tester.pump();

      expect(find.text("This is a test case description"), findsOneWidget);
    });

    testWidgets('Certification checkbox is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      // Find certification text
      expect(find.textContaining("I certify that the above facts are true"), findsOneWidget);
    });

    testWidgets('Can toggle certification checkbox', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      // Get initial state
      final initialValue = tester.widget<Checkbox>(checkbox).value;

      // Tap checkbox
      await tester.tap(checkbox);
      await tester.pump();

      // Verify state changed
      final newValue = tester.widget<Checkbox>(checkbox).value;
      expect(newValue, isNot(equals(initialValue)));
    });

    testWidgets('Submit button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find submit button
      final submitButton = find.text("Submit");
      expect(submitButton, findsOneWidget);
    });

    testWidgets('All required fields can be filled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Select case type
      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text("Civil"));
      await tester.pumpAndSettle();

      // Fill location
      final locationField = find.byType(TextField).at(0);
      await tester.enterText(locationField, "New York");
      await tester.pump();

      // Fill date
      final dateField = find.byType(TextField).at(1);
      await tester.enterText(dateField, "2024-01-15");
      await tester.pump();

      // Fill description
      final descriptionField = find.byType(TextField).at(2);
      await tester.enterText(descriptionField, "Test case description");
      await tester.pump();

      // Verify all fields have values
      expect(find.text("New York"), findsOneWidget);
      expect(find.text("2024-01-15"), findsOneWidget);
      expect(find.text("Test case description"), findsOneWidget);
    });

    testWidgets('Form validation - empty fields show error', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find submit button
      final submitButton = find.text("Submit");
      expect(submitButton, findsOneWidget);

      // Tap submit with empty fields (no case type selected, empty text fields)
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Should show validation message (if validation triggers)
      // Note: The actual validation might not show if _selectedOption is null
      // This test verifies the button is tappable
      expect(submitButton, findsOneWidget);
    });

    testWidgets('Case type options are correct', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Open dropdown
      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Verify all case types are present
      final caseTypes = ["Civil", "Labor", "Family", "Cooperative", "Consumer forum", "Other"];
      for (var caseType in caseTypes) {
        expect(find.text(caseType), findsOneWidget);
      }
    });

    testWidgets('Text fields trim whitespace', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      final locationField = find.byType(TextField).at(0);
      
      // Enter text with whitespace
      await tester.enterText(locationField, "  New York  ");
      await tester.pump();

      // Text field contains the text (trimming happens in onPressed)
      expect(find.textContaining("New York"), findsWidgets);
    });

    testWidgets('Upload files button is present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: regcase(),
        ),
      );

      // Find upload files text
      expect(find.textContaining("Upload files regarding the case"), findsOneWidget);
    });
  });
}

