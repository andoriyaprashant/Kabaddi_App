import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/discussion.dart';
import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/image_card.dart';
import 'package:kabadi/screens/navigationbar.dart';
import 'package:kabadi/screens/team_details.dart';
import 'package:kabadi/screens/teams.dart';

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
                      MaterialPageRoute(builder: (context) => Teams()),
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
                    imageUrl: data['imageUrl'], articleId: '',
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
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%200?alt=media&token=e54f6584-6c42-4328-8732-33e381d17123", articleId: '',
            ),
            SizedBox(height: 16),
            _buildArticleTile(
              title: "Captain",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath.",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%203?alt=media&token=c448eba2-e921-492d-8b53-e5fe1f89d35c", articleId: ''
            ),
            SizedBox(height: 16),
            _buildArticleTile(
              title: "About Adharva",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath.",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%202?alt=media&token=0ad1d5a1-f7b4-4f78-8be6-82e86d55b19e", articleId: ''
            ),
             SizedBox(height: 16),
            _buildArticleTile(
              title: "Telugu Titans",
              description:
                  "Kabaddi is basically a combative sport, with seven players on each side; played for a period of 40 minutes with a 5 minutes break (20-5-20). The core idea of the game is to score points by raiding into the opponent's court and touching as many defense players as possible without getting caught on a single breath",
              imageUrl:
                  "https://firebasestorage.googleapis.com/v0/b/kabadi-de081.appspot.com/o/Articles%2FArticle%201?alt=media&token=c498c223-169d-4802-b763-5c120c8e2ce3", articleId: ''
            ),
          
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

Widget _buildArticleTile({
  required String title,
  required String description,
  required String imageUrl,
  required String articleId,
}) {
  String comment = '';

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
      Image.network(
        imageUrl,
        width: 610,
        height: 320,
        fit: BoxFit.cover,
      ),
      Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('comments')
                  .where('articleId', isEqualTo: articleId)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                // Display comments
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return Text(data['comment']);
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Add a Comment'),
                          content: TextField(
                            onChanged: (value) {
                              comment = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Type your comment here...',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _submitComment(articleId, comment);
                                Navigator.pop(context);
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.comment),
                  label: Text('Add Comment'),
                ),
                SizedBox(width: 8),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('likes')
                      .where('articleId', isEqualTo: articleId)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    // Count likes
                    int likesCount = snapshot.data!.docs.length;

                    // Check if the current user has liked this article
                    bool likedByCurrentUser = snapshot.data!.docs
                        .any((like) => like['userId'] == FirebaseAuth.instance.currentUser?.uid);

                    return ElevatedButton.icon(
                      onPressed: () {
                        // Check if the current user has already liked the article
                        if (likedByCurrentUser) {
                          // Remove the like
                          _unlikeArticle(articleId);
                        } else {
                          // Like the article
                          _likeArticle(articleId);
                        }
                      },
                      icon: Icon(likedByCurrentUser ? Icons.favorite : Icons.favorite_border),
                      label: Text(likedByCurrentUser ? 'Unlike ($likesCount)' : 'Like ($likesCount)'),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}


void _submitComment(String articleId, String comment) async {
  try {
    await FirebaseFirestore.instance.collection('comments').add({
      'articleId': articleId,
      'comment': comment,
      'userId': FirebaseAuth.instance.currentUser?.uid,
      'timestamp': DateTime.now(),
    });
    // Optionally, update the UI to display the newly added comment
  } catch (error) {
    print('Error submitting comment: $error');
  }
}

void _likeArticle(String articleId) async {
  try {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    
    // Check if the user is logged in
    if (userId != null) {
      // Add a like document to the "Likes" collection
      await FirebaseFirestore.instance.collection('likes').add({
        'articleId': articleId,
        'userId': userId,
        'timestamp': DateTime.now(),
      });
      // Optionally, update the UI to reflect the like action
    } else {
      print('User is not logged in.');
    }
  } catch (error) {
    print('Error liking article: $error');
  }
}

void _unlikeArticle(String articleId) async {
  try {
    // Get the current user's ID
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    
    // Check if the user is logged in
    if (userId != null) {
      // Query the "Likes" collection to find the like document
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('likes')
          .where('articleId', isEqualTo: articleId)
          .where('userId', isEqualTo: userId)
          .get();
      
      // Check if the query returned any documents
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the like document
        await querySnapshot.docs.first.reference.delete();
        // Optionally, update the UI to reflect the unlike action
      } else {
        print('User has not liked this article.');
      }
    } else {
      print('User is not logged in.');
    }
  } catch (error) {
    print('Error unliking article: $error');
  }
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
