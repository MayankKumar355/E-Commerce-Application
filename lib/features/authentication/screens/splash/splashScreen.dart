import 'dart:async'; // Future ke liye zaroori
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_store/features/authentication/screens/login/login.dart';
import 'package:shopping_store/utils/constants/image_strings.dart';
// Apni Next Screen ko import karein, jaise LoginScreen ya HomeScreen
// import 'package:shopping_store/features/authentication/screens/onboarding/onboarding.dart';

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
      Get.offAll(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Image.asset(
          isDarkMode ? HkImages.lightSplash : HkImages.darkSplash,
        ),
      ),
    );
  }
}