import 'package:flutter/material.dart';
import 'package:kabadi/screens/sign_upPlayer.dart';
import 'package:kabadi/screens/sign_upTeam.dart';
import 'package:kabadi/screens/sign_upUser.dart';

class ChooseRole extends StatefulWidget {
  const ChooseRole({super.key});

  @override
  State<ChooseRole> createState() => _ChooseRoleState();
}

class _ChooseRoleState extends State<ChooseRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPlayer()),
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
              child: const Text('Player'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpTeam()),
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
              child: const Text('Team'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpUser()),
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
              child: const Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
