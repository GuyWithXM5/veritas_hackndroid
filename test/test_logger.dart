import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Helper that wraps [testWidgets] and logs pass/fail status to
/// `build/test_logs/test_results.log`.
void loggableTestWidgets(
  String description,
  WidgetTesterCallback callback,
) {
  testWidgets(description, (tester) async {
    try {
      await callback(tester);
      await _TestLog._write('PASS | ' + description + '\n');
    } catch (error) {
      await _TestLog._write('FAIL | ' + description + ' | ' + error.toString() + '\n');
      rethrow;
    }
  });
}

class _TestLog {
  static final File _file = File('build/test_logs/test_results.log');
  static bool _initialized = false;

  static Future<void> _ensureInitialized() async {
    if (_initialized) return;
    if (await _file.exists()) {
      await _file.delete();
    }
    await _file.create(recursive: true);
    _initialized = true;
  }

  static Future<void> _write(String message) async {
    await _ensureInitialized();
    await _file.writeAsString(message, mode: FileMode.append);
  }
}
