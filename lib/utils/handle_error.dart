import 'dart:developer';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

void handleError(dynamic e, {StackTrace? stackTrace, bool fatal = false}) {
  if (kDebugMode) {
    log(
      ">>>>>>>>> $e",
      stackTrace: stackTrace ?? StackTrace.current,
      name: 'handleError',
      time: DateTime.now(),
    );
  } else {
    try {
      // FirebaseCrashlytics.instance.recordError(e, stackTrace, fatal: fatal);
    } catch (e) {
      log(
        ">>>>>>>>> $e",
        stackTrace: stackTrace ?? StackTrace.current,
        name: 'handleError',
        time: DateTime.now(),
      );
    }
  }
}
