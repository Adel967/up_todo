import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:up_todo/core/app/state/app_state.dart';
import 'package:up_todo/core/constants.dart';
import 'package:up_todo/layers/view/screens/calendar/provider/calendar_properties.dart';
import 'package:up_todo/layers/view/screens/home/home_screen.dart';
import 'package:up_todo/layers/view/screens/intro/splash_screen.dart';

import 'core/constants/theme.dart';
import 'injection_container.dart';

void main() async {
  initInjection();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CalendarProperties()),
        ChangeNotifierProvider(create: (context) => sl<AppStateModel>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
          fontFamily: GoogleFonts.roboto().fontFamily,
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeColors.primary,
            secondary: ThemeColors.secondary,
            outline: const Color.fromARGB(198, 0, 51, 102),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: Constants.outlineInputBorder,
            enabledBorder: Constants.outlineInputBorder,
            focusedBorder: Constants.outlineInputBorder,
            prefixIconColor: Color(0xFF003366),
            outlineBorder: BorderSide(
              width: .8,
              color: Color.fromARGB(198, 0, 51, 102),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
