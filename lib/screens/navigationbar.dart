import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/explore_page.dart';
import 'package:kabadi/screens/kabadi_league.dart';
import 'package:kabadi/screens/live_score_page.dart';
import 'package:kabadi/screens/points_board.dart';
import 'package:kabadi/screens/teams.dart';
import 'package:kabadi/screens/trending_page.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _selectedIndex = 0;
  late PageController _pageController;

  getUserDetails() async {
    var value = FirebaseAuth.instance.currentUser;
    var userSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .where("uid", isEqualTo: value?.uid)
        .get();

    // If user data exists, extract the role
    if (userSnapshot.docs.isNotEmpty) {
      userRole.value = userSnapshot.docs[0].data()["role"];
    }

    // Fetch user profile
    var profileSnapshot;
    if (userRole == "user") {
      profileSnapshot = await FirebaseFirestore.instance
          .collection("UserProfile")
          .where("uid", isEqualTo: value?.uid)
          .get();
    } else if (userRole == "player") {
      profileSnapshot = await FirebaseFirestore.instance
          .collection("Players")
          .where("id", isEqualTo: value?.uid)
          .get();
    } else {
      profileSnapshot = await FirebaseFirestore.instance
          .collection("Teams")
          .where("id", isEqualTo: value?.uid)
          .get();
    }

    // If profile data exists, set the userProfile value
    if (profileSnapshot.docs.isNotEmpty) {
      userProfile.value = profileSnapshot.docs[0].data();
    }
    print("begin - " + userProfile.value.toString());
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: PageView(
          controller: _pageController,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Trending(),
            const ExplorePage(),
            const LiveScore(),
            const PointsTablePage(),
            const Teams(),
            const KabadiLeaguePage(),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
              bottom: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
              backgroundColor: Colors.black.withOpacity(0.5),
              selectedItemColor: Colors.white,
              selectedLabelStyle: const TextStyle(height: 0),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sports_kabaddi),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_tv),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.scoreboard_outlined),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.more_vert),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
