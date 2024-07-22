import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';

class OtpVerification extends StatefulWidget {
  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  late User user;
  late Timer timer;
  late Timer deleteAccountTimer;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    user.sendEmailVerification();

    // Check if the user is verified every 5 seconds
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerification();
    });

        deleteAccountTimer = Timer(Duration(seconds: 20), () {
      deleteUser();
          Fluttertoast.showToast(msg: "Error signing uo");

      Navigator.pop(context);
    });

  }
  

  Future<void> checkEmailVerification() async {
    user = FirebaseAuth.instance.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'An email verification link has been sent to your email address. Please verify your email to continue.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

Future<void> deleteUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await user.delete();
  }
}
