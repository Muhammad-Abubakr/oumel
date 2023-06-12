import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';

void main() {
  (() async {
    // ensure widgets binding have been initialized
    WidgetsFlutterBinding.ensureInitialized();

    // initialize the firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize the Flutter App
    runApp(const App());
  })();
}
