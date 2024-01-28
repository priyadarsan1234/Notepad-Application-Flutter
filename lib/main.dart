import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/splash.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 0, 127, 139),
          fontFamily: GoogleFonts.lato().fontFamily),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash_screen(),
            themeMode: ThemeMode.light,
            theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 0, 127, 139),
                fontFamily: GoogleFonts.lato().fontFamily),
            darkTheme: ThemeData(brightness: Brightness.dark),
          );
        },
      ),
    );
  }
}
