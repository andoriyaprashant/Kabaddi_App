import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/player_details.dart';
import 'package:kabadi/screens/upcoming_matches.dart';

// ignore: must_be_immutable
class TeamDetails extends StatefulWidget {
  final QueryDocumentSnapshot team;
  const TeamDetails({super.key, required this.team});

  @override
  State<TeamDetails> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  bool _isSearching = false;
  List<String> imageNames = [
    "images/captain.jpg",
    "images/captain.jpg",
    "images/captain.jpg",
    "images/captain.jpg",
    "images/captain.jpg",
    "images/captain.jpg",
  ];

  List<Map<String, String>> players = [
    {
      'avatarImage': 'images/danbang.png',
      'playerName': 'Ishan Sharma',
      'jerseyNumber': '10',
      'playerImage': 'images/adharva.png',
    },
    {
      'avatarImage': 'images/bengaluru.png',
      'playerName': 'Jagran Josh',
      'jerseyNumber': '20',
      'playerImage': 'images/adharva.png',
    },
    {
      'avatarImage': 'images/gujarat.png',
      'playerName': 'Ishan Sharma',
      'jerseyNumber': '10',
      'playerImage': 'images/adharva.png',
    },
    {
      'avatarImage': 'images/danbang.png',
      'playerName': 'Jagran Josh',
      'jerseyNumber': '20',
      'playerImage': 'images/adharva.png',
    },
  ];

  List<Map<String, dynamic>> playerList = [];
  Rx<bool> isLoading = false.obs;

  getPlayersByTeam() async {
    try {
      isLoading.value = true;
      var playersTeam = await FirebaseFirestore.instance
          .collection("Players")
          .where("teamName", isEqualTo: widget.team["name"])
          .get();

      playersTeam.docs.forEach((playerDoc) {
        Map<String, dynamic> playerData = playerDoc.data();
        playerList.add(playerData);
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> articlesList = [];

  getArticlesOnPlayer() async {
    try {
      isLoading.value = true;
      var articles = await FirebaseFirestore.instance
          .collection("Articles")
          .orderBy(FieldPath.documentId, descending: true)
          .limit(2)
          .get();
      articles.docs.forEach((articleDoc) {
        Map<String, dynamic> articleData = articleDoc.data();
        articlesList.add(articleData);
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("error" + e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlayersByTeam();
    getArticlesOnPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            'Team Details',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
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
                  child: const Text('Edit Profile'),
                  value: 'edit_profile',
                  onTap: () async {
                    // Retrieve current user
                    if (user != null) {
                      // Access user's document in Firestore
                      if (userRole.value == "user") {
                        Get.to(() => const EditUserProfilePage());
                      } else if (userRole.value == "player") {
                        Get.to(() => const EditPlayerProfilePage());
                      } else if (userRole.value == "team") {
                        Get.to(() => const EditTeamProfilePage());
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            return isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              widget.team['logo'],
                              height: 50,
                            ),
                            //const SizedBox(width: 5),
                            Text(
                              widget.team['name'],
                              style: const TextStyle(
                                color: Color(0xFFfc5607),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Players",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children:
                                playerList.map((Map<String, dynamic> player) {
                              return buildPlayerContainer(context, player);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 150,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFcfcfcf),
                                    blurRadius: 1,
                                    spreadRadius: 2,
                                    offset: Offset(
                                      1,
                                      3,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 8, top: 8, left: 8, bottom: 20),
                                    child: Text(
                                      'Total Number of \n Championship',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFfc5607),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      '6',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0xFFcfcfcf),
                                    blurRadius: 1,
                                    spreadRadius: 2,
                                    offset: Offset(
                                      1,
                                      3,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        right: 8, top: 8, left: 8, bottom: 20),
                                    child: Text(
                                      'Total Number of \n Players',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFfc5607),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      playerList.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Last News",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        for (int i = 0; i < articlesList.length; i++)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                  child: Image.network(
                                    articlesList[i]["imageUrl"],
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // "Five reasons to be excited about Atharva's skills in this season",
                                        articlesList[i]["description"],
                                        maxLines: 5,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // const Text(
                                      //   "15 April 22",
                                      //   style: TextStyle(
                                      //       fontSize: 15, color: Colors.grey),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: ClipRRect(
                        //         borderRadius: BorderRadius.circular(
                        //           10,
                        //         ),
                        //         child: Image.asset(
                        //           articlesList[1]["imageUrl"],
                        //           width: 150,
                        //           height: 100,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               // "lajers have played like never before love to see it!",
                        //               articlesList[1]["title"],
                        //               style: const TextStyle(
                        //                   fontSize: 14,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //             // Text(
                        //             //   "15 April 22",
                        //             //   style: TextStyle(
                        //             //       fontSize: 15, color: Colors.grey),
                        //             // ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Upcoming Matches",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Upcoming(), // Adding the Upcoming widget here
                      ],
                    ),
                  );
          }),
        ),
      ),
    );
  }

  Widget buildPlayerContainer(
      BuildContext context, Map<String, dynamic> playerDetails) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayerDetails(
                      player: playerDetails,
                    )),
          );
        },
        child: Container(
          width: 200,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 130,
                          child: Text(
                            playerDetails['name'],
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                        Text(
                          playerDetails['jerseyNo'].toString(),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(widget.team["logo"]),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Image.network(
                    playerDetails["imageUrl"],
                    width: 200,
                    height: 200,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
