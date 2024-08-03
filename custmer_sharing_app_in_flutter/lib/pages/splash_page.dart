import 'package:custmer_sharing_app_in_flutter/pages/login/signup.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Start the timer as soon as the widget is loaded
    Timer(Duration(seconds: 3), () {
      // Navigate to the next screen after the duration
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginSignUp()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5F2D9C),
      body: Center(
        child: Image.asset('images/img.png', height: 150,),
      ),
    );
  }
}


