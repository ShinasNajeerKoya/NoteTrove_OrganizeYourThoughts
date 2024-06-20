import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note_app/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    startTimer();
    super.initState();
  }

  startTimer() {
    var duration = Duration(milliseconds: 3800);
    return Timer(duration, navigateToHomePage);
  }

  void navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/ab_bg_w_normal.png"),
                fit: BoxFit.fitHeight)),
        child: Center(
          child: Lottie.asset(
              "assets/loading_animations/splash_screen_animation.json"),
        ),
      ),
    );
  }
}
