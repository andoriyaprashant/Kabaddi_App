import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/image_card.dart';
import 'package:kabadi/screens/navigationbar.dart';
import 'package:kabadi/screens/team_details.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final PageController _pageController = PageController(initialPage: 0);
  Color _trendingButtonColor = Colors.white;
  Color _exploreButtonColor = Colors.white;
  int _activePage = 0;
  bool _isSearching = false; // Track the search state
  final List<Widget> _pages = [
    Image.asset('images/l3.jpg', fit: BoxFit.cover),
    Image.asset('images/l3.jpg', fit: BoxFit.cover),
    Image.asset('images/l2.jpg', fit: BoxFit.cover),
    Image.asset('images/l3.jpg', fit: BoxFit.cover),
    Image.asset('images/pkl1.jpg', fit: BoxFit.cover),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                'Explore',
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
            onSelected: (value) async {
              if (value == 'edit_profile') {
                // Handle edit profile action
              } else if (value == 'logout') {
                // Handle logout action
                await FirebaseAuth.instance
                    .signOut(); // Call the logout confirmation dialog
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
            //     onTap: () async {
            //       // Retrieve current user

            //       if (user.value != null) {
            //         // Retrieve user's role
            //         String role = userRole.value;
            //         print(userRole.value);
            //         // Route to edit profile page based on role
            //         if (role == 'player') {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     const EditPlayerProfilePage()),
            //           );
            //         } else if (role == 'team') {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const EditTeamProfilePage()),
            //           );
            //         } else {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const EditUserProfilePage()),
            //           );
            //         }
            //       }
            //     }),

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
                      MaterialPageRoute(builder: (context) => TeamDetails()),
                    )),
            const ListTile(
              leading: Icon(Icons.live_tv),
              title: Text('LiveScore'),
              /*onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LiveScore()),
                    )*/
            ),
            const ListTile(
              leading: Icon(Icons.sports_kabaddi_rounded),
              title: Text('Matches'),
              /*onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  PointsTablePage()),
                    )*/
            ),
            // ListTile(
            //     leading: const Icon(Icons.settings),
            //     title: const Text('Settings'),
            //     onTap: () async {
            //       // Retrieve current user
            //       User? user = FirebaseAuth.instance.currentUser;
            //       if (user != null) {
            //         // Access user's document in Firestore
            //         DocumentSnapshot<Map<String, dynamic>> snapshot =
            //             await FirebaseFirestore.instance
            //                 .collection('Users')
            //                 .doc(user.uid)
            //                 .get();
            //         // Retrieve user's role
            //         String? role = snapshot.data()?['role'];
            //         // Route to edit profile page based on role
            //         if (role == 'player') {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     const EditPlayerProfilePage()),
            //           );
            //         } else if (role == 'team') {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const EditTeamProfilePage()),
            //           );
            //         } else {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => const EditUserProfilePage()),
            //           );
            //         }
            //       }
            //     }),

            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Account'),
              onTap: () => _dialogBuilder(context),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,
                width: 350,
                child: Stack(children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _activePage = page;
                      });
                    },
                    itemCount: _pages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _pages[index % _pages.length];
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 270,
                    height: 40,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                          _pages.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: InkWell(
                              onTap: () {
                                _pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: CircleAvatar(
                                radius: 3,
                                backgroundColor: _activePage == index
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              ),
              const SizedBox(height: 20),
              const Text(
                "Recommended",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    const ImageCard(imagePath: 'images/l1.jpg'),
                    const ImageCard(imagePath: 'images/l2.jpg'),
                    const ImageCard(imagePath: 'images/l3.jpg'),
                    const ImageCard(imagePath: 'images/pkl1.jpg'),
                  ],
                ),
              ),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              CircleAvatar(
                                radius: 12.0,
                                backgroundImage:
                                    AssetImage('images/cricket.jpg'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Tim cherry",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.alarm,
                                color: Colors.grey,
                                size: 13,
                              ),
                              Text(
                                "6h ago",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "The Raptors Don't Need Leonard To be in that game! They really don't!",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'images/l2.jpg',
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
        });
  }
}
