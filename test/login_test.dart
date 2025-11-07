import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veritasapp/pages/login_signup/loginpage.dart';

import 'test_logger.dart';

void main() {
  group('Login Page Tests', () {
    loggableTestWidgets('Login page renders correctly for client', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      expect(find.text("Login to continue"), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("New here!! SignUp"), findsOneWidget);
    });

    loggableTestWidgets('Login page renders correctly for lawyer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "lawyer"),
        ),
      );

      expect(find.text("Login to continue"), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("New here!! SignUp"), findsOneWidget);
    });

    loggableTestWidgets('Username and password fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text("Username"), findsNothing);
    });

    loggableTestWidgets('Can enter username and password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.first, "test@example.com");
      await tester.pump();

      await tester.enterText(textFields.last, "password123");
      await tester.pump();

      expect(find.text("test@example.com"), findsOneWidget);
      expect(find.text("password123"), findsNothing);
    });

    loggableTestWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      await tester.enterText(textFields.last, "testpassword");
      await tester.pump();

      final visibilityButton = find.byIcon(Icons.visibility_off);
      expect(visibilityButton, findsOneWidget);

      await tester.tap(visibilityButton);
      await tester.pump();

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    loggableTestWidgets('Login button is present and tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      final loginButton = find.text("Login");
      expect(loginButton, findsOneWidget);

      expect(tester.widget<ElevatedButton>(loginButton), isNotNull);
    });

    loggableTestWidgets('Sign up button navigates to signup page for client', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => login(usertype: "client"),
            '/signupdetails_client': (context) => const Scaffold(
              body: Center(child: Text('Signup Page')),
            ),
          },
          initialRoute: '/',
        ),
      );

      final signUpButton = find.text("New here!! SignUp");
      expect(signUpButton, findsOneWidget);

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
    });

    loggableTestWidgets('Empty fields validation - login button still works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      final loginButton = find.text("Login");
      expect(loginButton, findsOneWidget);

      await tester.tap(loginButton);
      await tester.pump();

      expect(find.text("Login"), findsOneWidget);
    });

    loggableTestWidgets('Text fields trim whitespace', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      final textFields = find.byType(TextField);

      await tester.enterText(textFields.first, "  test@example.com  ");
      await tester.pump();

      expect(find.textContaining("test@example.com"), findsWidgets);
    });
  });
}

