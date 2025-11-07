import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// This is a basic widget test to ensure the test setup is working
void main() {
  testWidgets('Test setup verification', (WidgetTester tester) async {
    // Build a simple widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Test'),
          ),
        ),
      ),
    );

    // Verify the widget is rendered
    expect(find.text('Test'), findsOneWidget);
  });
}

