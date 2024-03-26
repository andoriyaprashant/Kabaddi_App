import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';

import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/team_details.dart';

class Teams extends StatefulWidget {
  const Teams({super.key});

  @override
  State<Teams> createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  final List<Map<String, dynamic>> teams = [
    {"name": "Bengal Warriors", "image": "images/bengal.png"},
    {"name": "Bengaluru Bulls", "image": "images/bengaluru.png"},
    {"name": "Dabang Delhi K.C", "image": "images/danbang.png"},
    {"name": "Gujarat Giants", "image": "images/gujarat.png"},
    {"name": "Tamil Thalaivas", "image": "images/tamilThalaivas.png"},
    {"name": "PunneriPaltan", "image": "images/punneriPaltan.png"},
    {"name": "Bengal Warriors", "image": "images/bengal.png"},
    {"name": "Bengaluru Bulls", "image": "images/bengaluru.png"},
    {"name": "Dabang Delhi K.C", "image": "images/danbang.png"},
    {"name": "Gujarat Giants", "image": "images/gujarat.png"},
    {"name": "Tamil Thalaivas", "image": "images/tamilThalaivas.png"},
    {"name": "PunneriPaltan", "image": "images/punneriPaltan.png"},
    // Add more teams here as needed
  ];

  Rx<List<Map<String, String>>> teamList = Rx<List<Map<String, String>>>([]);
  Rx<bool> isLoading = false.obs;

  getTeams() {
    isLoading.value = true;
    teamStream = FirebaseFirestore.instance.collection("Teams").snapshots();
  }

  Stream? teamStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeams();
    isLoading.value = false;
  }

  int? selectedIndex; // Track the index of the selected team
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7f2f0),
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
            : const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Kabadi",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFfc5607),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "Teams",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
        actions: [
          // IconButton(
          //   color: Colors.black,
          //   icon: const Icon(
          //     Icons.search,
          //     color: const Color(0xFF6f758b),
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       _isSearching = !_isSearching; // Toggle search state
          //     });
          //   },
          // ),
          // IconButton(
          //   color: Colors.black,
          //   icon: const Icon(
          //     Icons.notifications,
          //     color: const Color(0xFF6f758b),
          //   ),
          //   onPressed: () {},
          // ),
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
                userProfile.value = {};
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
      body: Obx(() {
        return isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : StreamBuilder(
                stream: teamStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length > 0) {
                      return Container(
                        color: const Color(0xFFf7f2f0),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final QueryDocumentSnapshot team =
                                      snapshot.data.docs[index];
                                  return TeamButton(
                                    name: team['name'],
                                    image: team['logo'],
                                    isSelected: selectedIndex ==
                                        index, // Set isSelected based on selectedIndex
                                    onTap: () {
                                      setState(() {
                                        // Update selectedIndex when a team is tapped
                                        selectedIndex = index;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TeamDetails(
                                                  team: team,
                                                )),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text("No Teams yet"),
                      );
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Center(
                      child: Text("Internal Error"),
                    );
                  }
                });
      }),
    );
  }
}

class TeamButton extends StatelessWidget {
  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;

  const TeamButton({
    super.key,
    required this.name,
    required this.image,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: isSelected ? const Color(0xFFfc5607) : Colors.white,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35),
                child: Image.network(
                  image,
                  height: 50,
                ),
              ),
              const SizedBox(width: 14.0),
              Text(
                name,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF325177),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
