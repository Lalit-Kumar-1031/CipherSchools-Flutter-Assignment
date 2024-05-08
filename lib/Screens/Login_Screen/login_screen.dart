import 'package:expense_tracking/Screens/HomeScreen.dart';
import 'package:expense_tracking/googleAuth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final user = await GoogleAuth().authenticate();
                if (user == null) {
                  Fluttertoast.showToast(
                      msg: "Authentication Failed, Please try again.");
                } else {
                  Fluttertoast.showToast(msg: "Google Sign up Success full");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ));
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 35,
                    width: 60,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Sign up with google"),
                ],
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
