import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/signup_screen.dart';
import 'package:flutter_application_2/view_users_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF64B5F6), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInUp(
                duration: Duration(seconds: 2),
                child: Image.asset(
                  'assets/logo.png',
                  height: 100,
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                    duration: Duration(seconds: 2),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    )),
              SizedBox(height: 5),
              FadeInUp(
                duration: Duration(seconds: 2),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(Icons.email, color: Colors.blueAccent),
                  ),
                ),
              ),
              SizedBox(height: 5),
              FadeInUp(
                duration: Duration(seconds: 2),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock, color: Colors.blueAccent),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 10),
              FadeInUp(
                duration: Duration(seconds: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Password Contain ( A,a,1,@ )"),
                  ],
                ),
              ),
              SizedBox(height: 10),
               FadeInUp(
                            duration: Duration(seconds: 2),
                            child:  ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();
                  String password = passwordController.text.trim();
                  if (email.isEmpty && email == "") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Email Empty'),
                    ));
                  } else if (password.isEmpty && password == "") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Password Empty'),
                    ));
                  } else {
                    User? user =
                        await _auth.signInWithEmailAndPassword(email, password);
                    if (user != null) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool('isLoggedIn', true);
                      prefs.setString('email', email);
                      prefs.setString('password', password);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Login Sucessfully'),
                      ));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Viewdata()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Login Failed'),
                      ));
                    }
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: FadeInUp(
                    duration: Duration(seconds: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account?'),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
