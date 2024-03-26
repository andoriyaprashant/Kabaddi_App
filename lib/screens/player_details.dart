import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/discussion.dart';
import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/upcoming_matches.dart';

class PlayerDetails extends StatefulWidget {
  final Map<String, dynamic> player;
  const PlayerDetails({super.key, required this.player});

  @override
  // ignore: library_private_types_in_public_api
  _PlayerDetailsState createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    double _width = MediaQuery.of(context).size.width;
    bool _isSearching = false;

    //Size screenSize = MediaQuery.of(context).size;
    //Orientation orientation = MediaQuery.of(context).orientation;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFf9f9f8),
            title: const Text(
              "Kabadi Players",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
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
          body: SingleChildScrollView(
            child: Container(
              color: const Color(0xFFf9f9f8),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                size: _width * 0.05,
                              ),
                              color: const Color(0xFF6f758b),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: _width * 0.05,
                                  //   fontWeight: FontWeight.bold,
                                  color: const Color(0xFF6f758b),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateY(3.141592653),
                              child: SizedBox(
                                height: _height * 0.06,
                                width: _width * 0.10,
                                child: IconButton(
                                  padding:
                                      const EdgeInsets.only(right: 30, left: 0),
                                  icon: const Icon(
                                    Icons.reply,
                                    size: 25,
                                  ),
                                  color: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            IconButton(
                              padding: const EdgeInsets.only(left: 20),
                              icon: const Icon(
                                Icons.bookmark_border,
                                size: 25,
                              ),
                              color: Colors.grey,
                              onPressed: () {},
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the start (left)
                            children: [
                              Text(
                                widget.player["name"],
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: _height * 0.3),
                              Row(
                                // Wrap CircleAvatar and Text in a Row
                                children: [
                                  const CircleAvatar(
                                    backgroundImage:
                                        AssetImage("images/jersy.jpg"),
                                  ),
                                  SizedBox(
                                      width: _width *
                                          0.04), // Add some space between the avatar and text
                                  Text(
                                    widget.player["position"],
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Add some space between the column and image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.network(
                              widget.player["imageUrl"],
                              width: _width * 0.3,
                              height: _height * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: _height * 0.2,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 16, left: 35),
                                  child: Text(
                                    'Age',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30, left: 30),
                                  child: Text(
                                    widget.player["age"].toString(),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: _height * 0.2,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 16, left: 35),
                                  child: Text(
                                    'Points',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30, left: 30),
                                  child: Text(
                                    widget.player["points"].toString(),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: _height * 0.2,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 6, left: 25),
                                  child: Text(
                                    'Matches Played',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 30, left: 30),
                                  child: Text(
                                    widget.player["matchesPlayed"].toString(),
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: _height * 0.03,
                                width: _width * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue,
                                ),
                                child: Center(
                                  child: Container(
                                    height: _height * 0.015,
                                    width: _width * 0.025,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CommentBox()),
                                  );
                                },
                                child: Text(
                                  'Now discussing',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: CircleAvatar(
                              backgroundImage: AssetImage('images/profile.jpg'),
                              radius: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: _height * 0.01),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage:
                                            AssetImage('images/profile.jpg'),
                                        radius: 18,
                                      ),
                                      SizedBox(width: _width * 0.02),
                                      const Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 9.0),
                                            child: Text(
                                              'Kabadi news ',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Patna Atharva',
                                            style: TextStyle(
                                              fontSize: 14,
                                              //fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..rotateY(3.141592653),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.reply,
                                        size: 25,
                                      ),
                                      color: Colors.black,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                height: _height * 0.025,
                              ),
                              Row(
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '22',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Aug',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: _width *
                                          0.02), // Add some space between the columns and the row
                                  const Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Five reason to be excited about Atharva's skills in this season",
                                        style: TextStyle(
                                          fontSize: 17,
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _height * 0.03),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ABOUT',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Divider(
                                height: _height * 0.025,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  children: [
                                    Image.network(
                                      widget.player["imageUrl"],
                                      width: _width * 0.3,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.player["name"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: _height * 0.02,
                                          ),
                                          Text(
                                            // "Atharva (born 16 June 1993) is an Indian Kabaddi player, who has played as a defender and later became a magnificent raider.He was the first player ever to score 500, 700 and 800 raid points in Pro Kabaddi League. He was a member of the Indian National Kabaddi team that won a gold medal in the 2016 South Asian Games. After six seasons with Telugu Titans and one season for Tamil Thalaivas, Rahul now plays for Jaipur Pink Panthers.",
                                            widget.player["about"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.02,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Upcoming Matches",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Upcoming(),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
