import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/core/constants/app_icons.dart';
import 'package:quiz_app/core/utils/screen_utils.dart';
import 'package:quiz_app/features/onboarding/presentation/pages/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(AppIcons.logo),
              width: getScreenSize(context).width * 0.8,
              height: getScreenSize(context).height * 0.9,
            ),
          ],
        ),
      ),
    );
  }
}
