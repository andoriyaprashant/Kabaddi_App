import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kabadi/screens/landing_page.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/captain.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
          ),
          const Center(
            child: Text(
              'Kabadi',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfc5607),
              ),
            ),
          ),
        ],
      ),
      splashIconSize: double.maxFinite,
      duration: 200,
      nextScreen: const LandingPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}
