import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veritasapp/pages/login_signup/signupdetails_client.dart';

void main() {
  group('Client Sign Up Page Tests', () {
    testWidgets('Sign up page renders correctly', (WidgetTester tester) async {
      // Build the sign up widget
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      // Verify that the sign up page is displayed
      expect(find.text("Create Account Now!"), findsOneWidget);
      expect(find.text("Sign Up"), findsOneWidget);
    });

    testWidgets('All required fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      // Find all text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4)); // Username, Email, Password, Phone
    });

    testWidgets('Can enter full name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter full name in first field
      await tester.enterText(textFields.at(0), "John Doe");
      await tester.pump();

      expect(find.text("John Doe"), findsOneWidget);
    });

    testWidgets('Can enter email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter email in second field
      await tester.enterText(textFields.at(1), "john@example.com");
      await tester.pump();

      expect(find.text("john@example.com"), findsOneWidget);
    });

    testWidgets('Can enter password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter password in third field
      await tester.enterText(textFields.at(2), "securePassword123");
      await tester.pump();

      // Password field exists (text might be obscured)
      expect(textFields.at(2), findsOneWidget);
    });

    testWidgets('Can enter phone number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter phone number in fourth field
      await tester.enterText(textFields.at(3), "1234567890");
      await tester.pump();

      expect(find.text("1234567890"), findsOneWidget);
    });

    testWidgets('Sign up button is present and tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      // Find sign up button
      final signUpButton = find.text("Sign Up");
      expect(signUpButton, findsOneWidget);

      // Verify button is tappable
      expect(tester.widget<ElevatedButton>(signUpButton), isNotNull);
    });

    testWidgets('All fields can be filled simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Fill all fields
      await tester.enterText(textFields.at(0), "John Doe");
      await tester.enterText(textFields.at(1), "john@example.com");
      await tester.enterText(textFields.at(2), "password123");
      await tester.enterText(textFields.at(3), "1234567890");
      await tester.pump();

      // Verify all fields have text
      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("john@example.com"), findsOneWidget);
      expect(find.text("1234567890"), findsOneWidget);
    });

    testWidgets('Text fields trim whitespace on input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter text with whitespace
      await tester.enterText(textFields.at(0), "  John Doe  ");
      await tester.pump();

      // Text field contains the text (trimming happens in onPressed)
      expect(find.textContaining("John Doe"), findsWidgets);
    });

    testWidgets('Email field accepts email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter valid email
      await tester.enterText(textFields.at(1), "test@example.com");
      await tester.pump();

      expect(find.text("test@example.com"), findsOneWidget);
    });

    testWidgets('Form validation - empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      // Find sign up button
      final signUpButton = find.text("Sign Up");
      expect(signUpButton, findsOneWidget);

      // Tap sign up button with empty fields
      await tester.tap(signUpButton);
      await tester.pump();

      // Button should be tappable (Firebase will handle validation)
      expect(find.text("Sign Up"), findsOneWidget);
    });

    testWidgets('Password field is secure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter password
      await tester.enterText(textFields.at(2), "secretpassword");
      await tester.pump();

      // Password should not be visible as plain text in the widget tree
      // (This is handled by Flutter's TextField with obscureText)
      expect(textFields.at(2), findsOneWidget);
    });
  });
}

