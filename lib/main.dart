import 'package:flutter/material.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/features/onboarding/presentation/pages/splash_page.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}
