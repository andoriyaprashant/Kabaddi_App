import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kabadi/screens/choose_role.dart';
import 'package:kabadi/screens/login.dart';
import 'package:kabadi/screens/navigationbar.dart';
import 'package:kabadi/screens/sign_upUser.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final user = snapshot.data;
          if (user != null) {
            // User is already logged in, navigate to NavigationBarWidget
            return const NavigationBarWidget(); // Adjust this according to your implementation
          } else {
            // User is not logged in, show landing page
            return Scaffold(
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'images/captain.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Kabadi',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFfc5607),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChooseRole(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: const Color(0xFFfc5607),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Sign Up'),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }
}
