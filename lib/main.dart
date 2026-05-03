import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'package:pukaar/shared/utils/app_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pukaarLog('main: WidgetsFlutterBinding.ensureInitialized ok', tag: 'Pukaar.Main');

  pukaarLog('main: awaiting Firebase.initializeApp…', tag: 'Pukaar.Main');
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    pukaarLog('main: Firebase.initializeApp ok', tag: 'Pukaar.Main');
  } catch (e, st) {
    pukaarLog(
      'main: Firebase.initializeApp FAILED',
      tag: 'Pukaar.Main',
      error: e,
      stackTrace: st,
    );
    rethrow;
  }
  pukaarLog('main: runApp(PukaarApp)', tag: 'Pukaar.Main');
  runApp(const PukaarApp());
}
