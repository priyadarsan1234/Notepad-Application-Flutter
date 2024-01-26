import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/login_screen.dart';
import 'package:flutter_application_2/view_users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash_screen extends StatefulWidget {
  const Splash_screen({Key? key});

  @override
  State<Splash_screen> createState() => Splash_screenState();
}

class Splash_screenState extends State<Splash_screen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      if (isLoggedIn) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Viewdata()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            color: Colors.black,
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 150),
                FadeInDown(
                  duration: Duration(seconds: 2),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 180,
                  ),
                ),
                // SizedBox(height: 210),
                // FadeInDownBig(
                //   duration: Duration(seconds: 2),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                    // children: [
                    //   const Text(
                    //     "Developed By Priyadarsan",
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   Image.asset(
                    //     "assets/logo.png",
                    //     height: 30,
                    //     width: 30,
                    //   ),
                    // ],
                //   ),
                // )
              ],
            ),
          );
        },
      ),
    );
  }
}
