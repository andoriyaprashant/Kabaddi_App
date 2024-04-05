import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/discussion.dart';
import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/explore_page.dart';
import 'package:kabadi/screens/landing_page.dart';
import 'package:kabadi/screens/navigationbar.dart';
import 'package:kabadi/screens/team_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kabadi/screens/teams.dart';

class Trending extends StatefulWidget {
  const Trending({super.key});

  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending>
    with SingleTickerProviderStateMixin {
  Future<Uint8List?> getUserProfilePicture(String userId) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('UserProfilePictures/$userId');
      String downloadURL = await ref.getDownloadURL();
      HttpClientRequest request =
          await HttpClient().getUrl(Uri.parse(downloadURL));
      HttpClientResponse response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      return bytes;
    } catch (error) {
      print("Error fetching user profile picture: $error");
      return null;
    }
  }

  final int _selectedIndex = 0;
  late TabController _tabController;
  bool _isSearching = false;
  //bool _showDeleteButton = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? const TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: TextStyle(color: Colors.black),
              )
            : const Text(
                'Home',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
        actions: [
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // Toggle search state
              });
            },
          ),
          IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          const SizedBox(
            width: 10,
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: Text('Edit Profile'),
                value: 'edit_profile',
                onTap: () async {
                  // Retrieve current user
                  if (user != null) {
                    // Access user's document in Firestore
                    if (userRole.value == "user") {
                      Get.to(() => EditUserProfilePage());
                    } else if (userRole.value == "player") {
                      Get.to(() => EditPlayerProfilePage());
                    } else if (userRole.value == "team") {
                      Get.to(() => EditTeamProfilePage());
                    }
                  }
                },
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit_profile') {
                // Handle edit profile action
              } else if (value == 'logout') {
                // Handle logout action
                userProfile.value = {};
                _showLogoutConfirmationDialog(); // Call the logout confirmation dialog
              }
            },
            // child: const CircleAvatar(
            //   radius: 12.0,
            //   backgroundImage: AssetImage('images/cricket.jpg'),
            // ),
            child: const Icon(
              Icons.more_vert_outlined,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),

      //Menu Bar
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('ABCD'),
              accountEmail: const Text(''),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('images/profile.jpg')),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFfc5607),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NavigationBarWidget()),
                    )),
            // ListTile(
            //     leading: const Icon(Icons.person_2_rounded),
            //     title: const Text('My Account'),
            //     onTap: () => Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const EditUserProfilePage()),
            //         )),
            ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Explore'),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExplorePage()),
                    )),
            ListTile(
                leading: const Icon(Icons.people_outline_rounded),
                title: const Text('Know Your Team'),
                onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Teams()),
                    )),
            const ListTile(
              leading: Icon(Icons.live_tv),
              title: Text('LiveScore'),
            ),
            const ListTile(
              leading: Icon(Icons.sports_kabaddi_rounded),
              title: Text('Matches'),
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () => _dialogBuilder(context),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('images/profile.jpg'),
                                radius: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Tassy Omah',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.alarm,
                                  size: 20,
                                ),
                                color: Colors.grey,
                                onPressed: () {},
                              ),
                              const Text(
                                '6 hrs ago',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        'The Raptors Don\'t Need Leonard To be in that game! They really don\'t!',
                        style: TextStyle(fontSize: 19.0),
                      ),
                      const SizedBox(height: 10.0),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                        child: Image.asset(
                          'images/play1.jpg',
                          width: 610,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 0.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                ),
                                color: Colors.red,
                                onPressed: () {},
                              ),
                              const Text(
                                '334',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Icon(
                                Icons.comment,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5.0),
                              const Text(
                                '23440',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.bookmark_border,
                                color: Colors.grey,
                              ),
                              SizedBox(width: 10.0),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 0.0),
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text(
                  'For you',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.black : const Color(0xFFfc5607),
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Bookmarks',
                    style: TextStyle(
                      color: _selectedIndex == 1 ? Colors.black : const Color(0xFFfc5607),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
      padding: const EdgeInsets.all(15.0),
      child: Scrollbar(
        child: ListView(
          children: [
              // articles from Firestore
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('articles').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.data!.docs.isEmpty) {
                    return SizedBox.shrink();
                  }

              return Column(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return _buildArticleTile(
                    title: data['title'],
                    description: data['description'],
                    imageUrl: data['imageUrl'],
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 16),
            _buildArticleTile(
              title: "About matches",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath.",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%200?alt=media&token=e54f6584-6c42-4328-8732-33e381d17123",
            ),
            SizedBox(height: 16),
            _buildArticleTile(
              title: "Captain",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath.",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%203?alt=media&token=c448eba2-e921-492d-8b53-e5fe1f89d35c"
            ),
            SizedBox(height: 16),
            _buildArticleTile(
              title: "About Adharva",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath.",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%202?alt=media&token=0ad1d5a1-f7b4-4f78-8be6-82e86d55b19e"
            ),
             SizedBox(height: 16),
            _buildArticleTile(
              title: "Telugu Titans",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%201?alt=media&token=c498c223-169d-4802-b763-5c120c8e2ce3"
            ),
          ],
        ),
      ),
    ),
     // Second tab content (Bookmarks)
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Scrollbar(
                      child: GridView.count(
                        crossAxisCount: 2, // 2 columns
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        children: [
                          // First image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius as needed
                            child: Image.asset(
                              'images/play2.jpg',
                              width: 610,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Second image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius as needed
                            child: Image.asset(
                              'images/play1.jpg',
                              width: 610,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Third image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius as needed
                            child: Image.asset(
                              'images/play2.jpg',
                              width: 610,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Fourth image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius as needed
                            child: Image.asset(
                              'images/play1.jpg',
                              width: 610,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

Widget _buildArticleTile({
  required String title,
  required String description,
  required String imageUrl,
}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CommentBox()),
        );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                imageUrl,
                width: 610,
                          height: 320,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'images/delete.png',
                width: 150,
              ),
              const SizedBox(height: 16),
              const Text('Once you Delete your account \n'
                  'There is no getting it back\n'
                  'Make sure you want to do this'),
            ],
          ),
          actions: [
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge),
                child: const Text('Yes, Delete My Account'),
              ),
            ),
            const SizedBox(
              height: 10,
              width: double.infinity,
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge),
                child: const Text('No, Stop it'),
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => LandingPage());
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _signOut();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _handlePopupMenuSelection(String value) {
    if (value == 'logout') {
      _showLogoutConfirmationDialog();
    }
  }
}
