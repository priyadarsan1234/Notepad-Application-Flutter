import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/signup.dart';
import 'package:flutter_application_2/All_Notes_Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class Login extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromARGB(255, 105, 149, 224), Colors.white,Color.fromARGB(255, 105, 149, 224)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeInUp(
                      duration: const Duration(seconds: 2),
                      child: Image.asset(
                        'assets/logo.png',
                        height: screenHeight * 0.13,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    
                        FadeInUp(
                      duration: const Duration(seconds: 2),
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontFamily:
                              'serif', 
                        ),
                      ),
                    ),
                     
                    SizedBox(height: screenHeight * 0.01),
                    FadeInUp(
                      duration: const Duration(seconds: 2),
                      child:  TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email, color: Colors.blueAccent),
                          ),
                        ),
                      
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    FadeInUp(
                      duration: const Duration(seconds: 2),
                      child: TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            icon: Icon(Icons.lock, color: Colors.blueAccent),
                          ),
                          obscureText: true,
                        ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FadeInUp(
                      duration: const Duration(seconds: 2),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Password Contain ( A, a, 1, @ )",
                              style: TextStyle(
                                fontFamily: 'serif',
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    FadeInUp(
                      duration: const Duration(seconds: 2),
                      child:  ElevatedButton(
                          onPressed: () async {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
                            if (email.isEmpty && email == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Email Empty'),
                              ));
                            } else if (password.isEmpty && password == "") {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Password Empty'),
                              ));
                            } else {
                              User? user = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (user != null) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('isLoggedIn', true);
                                prefs.setString('email', email);
                                prefs.setString('password', password);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Login Successfully'),
                                ));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => All_Notes_Home()),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Login Failed'),
                                ));
                              }
                            }
                          },
                          child: const Text('Login',
                              style: TextStyle(
                                fontFamily: 'serif',
                              )),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1,
                                vertical: screenHeight * 0.02),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(height: screenHeight * 0.01),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUp()),
                        );
                      },
                      child: FadeInUp(
                        duration: const Duration(seconds: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                )),
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontFamily: 'serif',
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.05),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
