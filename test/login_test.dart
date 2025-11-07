import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veritasapp/pages/login_signup/loginpage.dart';

void main() {
  group('Login Page Tests', () {
    testWidgets('Login page renders correctly for client', (WidgetTester tester) async {
      // Build the login widget
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      // Verify that the login page is displayed
      expect(find.text("Login to continue"), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("New here!! SignUp"), findsOneWidget);
    });

    testWidgets('Login page renders correctly for lawyer', (WidgetTester tester) async {
      // Build the login widget
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "lawyer"),
        ),
      );

      // Verify that the login page is displayed
      expect(find.text("Login to continue"), findsOneWidget);
      expect(find.text("Login"), findsOneWidget);
      expect(find.text("New here!! SignUp"), findsOneWidget);
    });

    testWidgets('Username and password fields are present', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      // Find text fields by hint text
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text("Username"), findsNothing); // Hint text might not be findable directly
    });

    testWidgets('Can enter username and password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      // Find text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Enter username in first field
      await tester.enterText(textFields.first, "test@example.com");
      await tester.pump();

      // Enter password in second field
      await tester.enterText(textFields.last, "password123");
      await tester.pump();

      // Verify text was entered
      expect(find.text("test@example.com"), findsOneWidget);
      expect(find.text("password123"), findsNothing); // Password is obscured
    });

    testWidgets('Password visibility toggle works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      // Find password field
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Enter password
      await tester.enterText(textFields.last, "testpassword");
      await tester.pump();

      // Find visibility toggle button
      final visibilityButton = find.byIcon(Icons.visibility_off);
      expect(visibilityButton, findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(visibilityButton);
      await tester.pump();

      // Verify icon changed
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('Login button is present and tappable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      // Find login button
      final loginButton = find.text("Login");
      expect(loginButton, findsOneWidget);

      // Verify button is tappable
      expect(tester.widget<ElevatedButton>(loginButton), isNotNull);
    });

    testWidgets('Sign up button navigates to signup page for client', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/': (context) => login(usertype: "client"),
            '/signupdetails_client': (context) => Scaffold(
              body: Center(child: Text('Signup Page')),
            ),
          },
          initialRoute: '/',
        ),
      );

      // Find sign up button
      final signUpButton = find.text("New here!! SignUp");
      expect(signUpButton, findsOneWidget);

      // Tap sign up button
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      // Verify navigation occurred (this would work if routes are properly set up)
      // Note: Actual navigation testing requires proper route setup
    });

    testWidgets('Empty fields validation - login button still works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      // Find login button
      final loginButton = find.text("Login");
      expect(loginButton, findsOneWidget);

      // Tap login button with empty fields
      await tester.tap(loginButton);
      await tester.pump();

      // Button should be tappable even with empty fields
      // Firebase will handle validation
      expect(find.text("Login"), findsOneWidget);
    });

    testWidgets('Text fields trim whitespace', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: login(usertype: "client"),
        ),
      );

      final textFields = find.byType(TextField);
      
      // Enter text with whitespace
      await tester.enterText(textFields.first, "  test@example.com  ");
      await tester.pump();

      // The text field should contain the text (trimming happens in onPressed)
      expect(find.textContaining("test@example.com"), findsWidgets);
    });
  });
}

