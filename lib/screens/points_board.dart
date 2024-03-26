// ignore_for_file: avoid_unnecessary_containers

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/edit_profile.dart';
import 'package:kabadi/screens/edit_profileplayer.dart';
import 'package:kabadi/screens/edit_profileteam.dart';
import 'package:kabadi/screens/upcoming_matches.dart';

class PointsTablePage extends StatefulWidget {
  // ignore: use_super_parameters
  const PointsTablePage({Key? key}) : super(key: key);

  @override
  State<PointsTablePage> createState() => _PointsTablePageState();
}

class _PointsTablePageState extends State<PointsTablePage> {
  IconData _selectedFilterIcon = Icons.filter_list; // Initially set filter icon
  String _selectedFilter = 'All'; // Initially set the filter to 'All'
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFf7f2f0),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Kabadi",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFfc5607),
                      ),
                    ),
                    Text(
                      "Matches",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
          actions: [
            IconButton(
              color: Colors.black,
              icon: const Icon(
                Icons.search,
                color: const Color(0xFF6f758b),
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching; // Toggle search state
                });
              },
            ),
            IconButton(
              color: Colors.black,
              icon: const Icon(
                Icons.notifications,
                color: const Color(0xFF6f758b),
              ),
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.0),
                          child: Text('Filter: '),
                        ),
                        const SizedBox(
                          width: 120,
                        ),
                        DropdownButton<String>(
                          value: _selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                              // Update the icon based on the selected filter
                              _selectedFilterIcon = newValue == 'All'
                                  ? Icons.filter_list
                                  : Icons.filter_alt;
                            });
                          },
                          items: <String>[
                            'All',
                            'Filter 1',
                            'Filter 2',
                            'Filter 3'
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Row(
                                  children: [
                                    // ignore: unnecessary_null_comparison
                                    _selectedFilterIcon != null
                                        ? Icon(_selectedFilterIcon)
                                        : Text(value),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Icon(Icons.refresh),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(10), // Optional: add border radius
                ),
                child: const TabBar(
                  labelColor: Colors.black, // Change label text color
                  indicatorColor: Color(0xFFfc5607),
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      text: 'Live',
                    ),
                    Tab(
                      text: 'Upcoming',
                    ),
                    Tab(
                      text: 'Points',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 1,
                  child: Container(
                    child: TabBarView(
                      children: [
                        const Center(child: Text('Live content')),
                        Upcoming(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Rank',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              DataColumn(
                                  label: Text(' Team',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('Played',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('W',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('L',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('T',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              DataColumn(
                                  label: Text('P',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            ],
                            rows: [
                              DataRow(cells: [
                                const DataCell(Text('1')),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/tamilThalaivas.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Tamil Thalaivas'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('8')),
                                const DataCell(Text('2')),
                                const DataCell(Text('0')),
                                const DataCell(Text('16')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('2')),
                                DataCell(
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Image.asset(
                                        'images/punneriPaltan.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Punneri Paltan'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('7')),
                                const DataCell(Text('3')),
                                const DataCell(Text('0')),
                                const DataCell(Text('14')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('3')),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/bengal.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Tamil Thalaivas'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('6')),
                                const DataCell(Text('4')),
                                const DataCell(Text('0')),
                                const DataCell(Text('12')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('4')),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/tamilThalaivas.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Tamil Thalaivas'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('5')),
                                const DataCell(Text('5')),
                                const DataCell(Text('0')),
                                const DataCell(Text('10')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('5')),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/tamilThalaivas.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Tamil Thalaivas'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('5')),
                                const DataCell(Text('5')),
                                const DataCell(Text('0')),
                                const DataCell(Text('10')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('6')),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/tamilThalaivas.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Tamil Thalaivas'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('5')),
                                const DataCell(Text('5')),
                                const DataCell(Text('0')),
                                const DataCell(Text('10')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('7')),
                                DataCell(
                                  Row(
                                    children: [
                                      Image.asset(
                                        'images/tamilThalaivas.png',
                                        width: 30,
                                        height: 55,
                                      ),
                                      const Text('Tamil Thalaivas'),
                                    ],
                                  ),
                                ),
                                const DataCell(Text('10')),
                                const DataCell(Text('5')),
                                const DataCell(Text('5')),
                                const DataCell(Text('0')),
                                const DataCell(Text('10')),
                              ]),
                            ],
                          ),
                        )
                        // Place the table here
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: PointsTablePage(),
  ));
}
