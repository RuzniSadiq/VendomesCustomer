import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:worldsgate/screens/user/userhomepage.dart';
import 'package:worldsgate/screens/user/userlocationconfirmation.dart';

class EmailVerification extends StatefulWidget {
  //const OTPVerification({ Key? key }) : super(key: key);
  /*final String name;
  final String email;
  final String username;
  final String contactNumber;
  final String password;

  OTPVerification(
      this.name, this.email, this.username, this.contactNumber, this.password);*/

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final auth = FirebaseAuth.instance;
  User? user;
  Timer? timer;

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user!.reload();
    if (user!.emailVerified) {
      timer!.cancel();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => LocationConfirmation(user!.uid)));
    }
  }

  @override
  void initState() {
    user = auth.currentUser;
    user!.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 100.0,
                width: 100.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFdb9e1f)),
                )),
            SizedBox(
              height: 100.0,
            ),
            Text("An email has been sent to ${user!.email}, please verify",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16))
          ],
        ),
      )),
    );
  }
}
