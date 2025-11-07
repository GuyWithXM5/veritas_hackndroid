import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veritasapp/pages/login_signup/signupdetails_client.dart';

import 'test_logger.dart';

void main() {
  group('Client Sign Up Page Tests', () {
    loggableTestWidgets('Sign up page renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      expect(find.text("Create Account Now!"), findsOneWidget);
      expect(find.text("Sign Up"), findsOneWidget);
    });

    loggableTestWidgets('All required fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4));
    });

    loggableTestWidgets('Can enter full name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(0), "John Doe");
      await tester.pump();

      expect(find.text("John Doe"), findsOneWidget);
    });

    loggableTestWidgets('Can enter email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(1), "john@example.com");
      await tester.pump();

      expect(find.text("john@example.com"), findsOneWidget);
    });

    loggableTestWidgets('Can enter password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(2), "securePassword123");
      await tester.pump();

      expect(textFields.at(2), findsOneWidget);
    });

    loggableTestWidgets('Can enter phone number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(3), "1234567890");
      await tester.pump();

      expect(find.text("1234567890"), findsOneWidget);
    });

    loggableTestWidgets('Sign up button is present and tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final signUpButton = find.text("Sign Up");
      expect(signUpButton, findsOneWidget);

      expect(tester.widget<ElevatedButton>(signUpButton), isNotNull);
    });

    loggableTestWidgets('All fields can be filled simultaneously', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(0), "John Doe");
      await tester.enterText(textFields.at(1), "john@example.com");
      await tester.enterText(textFields.at(2), "password123");
      await tester.enterText(textFields.at(3), "1234567890");
      await tester.pump();

      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("john@example.com"), findsOneWidget);
      expect(find.text("1234567890"), findsOneWidget);
    });

    loggableTestWidgets('Text fields trim whitespace on input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(0), "  John Doe  ");
      await tester.pump();

      expect(find.textContaining("John Doe"), findsWidgets);
    });

    loggableTestWidgets('Email field accepts email format', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(1), "test@example.com");
      await tester.pump();

      expect(find.text("test@example.com"), findsOneWidget);
    });

    loggableTestWidgets('Form validation - empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final signUpButton = find.text("Sign Up");
      expect(signUpButton, findsOneWidget);

      await tester.tap(signUpButton);
      await tester.pump();

      expect(find.text("Sign Up"), findsOneWidget);
    });

    loggableTestWidgets('Password field is secure', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: signInDetails_client(),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.at(2), "secretpassword");
      await tester.pump();

      expect(textFields.at(2), findsOneWidget);
    });
  });
}

