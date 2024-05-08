import 'dart:async';

import 'package:expense_tracking/Screens/HomeScreen.dart';
import 'package:expense_tracking/Screens/Login_Screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      _navigateToNextScreen();
    });
  }

  void _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2));  // Simulate some delay
    FirebaseAuth.instance.authStateChanges().first.then((user) {
      if (user == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png',width: MediaQuery.of(context).size.width*0.5,height: MediaQuery.of(context).size.height*0.2,),
            Image.asset('assets/images/campany.png',width: MediaQuery.of(context).size.width*0.9),
          ],
        ),
      ),
    );
  }
}
