import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oumel/blocs/database_user/database_user_cubit.dart';
import 'package:oumel/blocs/phone_verification/phone_verification_cubit.dart';
import 'package:oumel/blocs/user/user_bloc.dart';
import 'package:oumel/screens/wrapper/wrapper.dart';

import 'screens/auth/authentication.dart';
import 'screens/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(create: (context) => UserBloc()),
        BlocProvider<PhoneVerificationCubit>(create: (context) => PhoneVerificationCubit()),
        BlocProvider<DatabaseUserCubit>(create: (context) => DatabaseUserCubit()),
      ],
      child: ScreenUtilInit(
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
            appBarTheme: const AppBarTheme(
              foregroundColor: Color(0xFFEA335B),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Color(0xFFEA335B),
              unselectedItemColor: Color(0xFF282828),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            snackBarTheme: SnackBarThemeData(
              elevation: 1,
              backgroundColor: const Color(0xFFEA335B).withAlpha(200),
              actionBackgroundColor: const Color(0xFFFFFFFF),
              actionTextColor: const Color(0xFFEA335B),
            ),
            useMaterial3: true,
          ),

          /* Routing */
          initialRoute: SplashScreen.routeName,
          // Routing Table
          routes: {
            Wrapper.routeName: (context) => const Wrapper(),
            SplashScreen.routeName: (context) => const SplashScreen(),
            AuthenticationScreen.routeName: (context) => const AuthenticationScreen(),
          },
        ),
      ),
    );
  }
}
