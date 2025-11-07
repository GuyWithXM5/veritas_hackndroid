import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'test_logger.dart';

void main() {
  loggableTestWidgets('Test setup verification', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Test'),
          ),
        ),
      ),
    );

    expect(find.text('Test'), findsOneWidget);
  });
}

