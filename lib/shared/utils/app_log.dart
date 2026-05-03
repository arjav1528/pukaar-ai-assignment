import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Debug logging for the app.
///
/// **`developer.log` does not reliably show in `flutter run` terminal output** (VM/DevTools
/// only). We mirror every line with [debugPrint] so `flutter: [Pukaar.xxx] …` appears
/// in the console when you run from VS Code / Android Studio / terminal.
void pukaarLog(
  String message, {
  String tag = 'Pukaar',
  Object? error,
  StackTrace? stackTrace,
}) {
  final buffer = StringBuffer('[$tag] $message');
  if (error != null) {
    buffer.write(' | $error');
  }
  debugPrint(buffer.toString());
  if (stackTrace != null) {
    debugPrint(stackTrace.toString());
  }
  developer.log(
    message,
    name: tag,
    error: error,
    stackTrace: stackTrace,
  );
}
