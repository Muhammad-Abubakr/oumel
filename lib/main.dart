import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oumel/screens/authentication.dart';
import 'package:oumel/screens/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    runApp(const MyApp());
  })();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2340),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'Oumel',

        /* App Theme */
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFEA335B),
            secondary: const Color(0xFF282828),
          ),
          useMaterial3: true,
        ),

        /* Routing */
        initialRoute: SplashScreen.routeName,
        // Routing Table
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          AuthenticationScreen.routeName: (context) => const AuthenticationScreen(),
        },
      ),
    );
  }
}
