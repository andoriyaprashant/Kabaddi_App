import 'package:flutter/material.dart';
import 'package:kabadi/screens/player_details.dart';



class KabadiLeaguePage extends StatefulWidget {
  const KabadiLeaguePage({super.key});

  @override
  State<KabadiLeaguePage> createState() => _KabadiLeaguePageState();
}

class _KabadiLeaguePageState extends State<KabadiLeaguePage> {
  String _selectedOption = 'Rating';
  final List<String> _options = ['Rating', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    List<Player> players = [
      Player(
          name: 'sagar Defende',
          position: 'Raider',
          points: 9.5,
          profileImage: 'images/cricket.jpg'),
      Player(
          name: 'Vishal Chahal',
          position: 'Defender',
          points: 7.2,
          profileImage: 'images/l1.jpg'),
      Player(
          name: 'Himanshu',
          position: 'All-Rounder',
          points: 7.8,
          profileImage: 'images/l2.jpg'),
      Player(
          name: 'Aashish',
          position: 'Raider',
          points: 6.3,
          profileImage: 'images/l3.jpg'),
      Player(
          name: 'Mohit',
          position: 'Defender',
          points: 7.9,
          profileImage: 'images/cricket.jpg'),
      Player(
          name: 'Aashish',
          position: 'Raider',
          points: 8.1,
          profileImage: 'images/l3.jpg'),
      Player(
          name: 'Mohit',
          position: 'Defender',
          points: 6.7,
          profileImage: 'images/cricket.jpg'),
    ];

    double highestPoints = players
        .map((player) => player.points)
        .reduce((value, element) => value > element ? value : element);

    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text(
          "  KABADI PLAYERS",
          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz,color: Colors.grey,))
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              color: Colors.black,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Adjust the radius as needed
                                child: Image.asset(
                                  'images/tt.jpg',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                children: [
                                  Text(
                                    'PRO KABADI LEAGUE',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                            AssetImage('images/tt.jpg'),
                                        radius: 10,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Tamil Thalaivas',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.groups,
                                        color: Colors.orange,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '8 Members',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle navigation action for the first text
                                },
                                child: const Text(
                                  'Overview',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2.0,
                                    fontSize: 16,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle navigation action for the second text
                                },
                                child: const Text(
                                  'Content',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle navigation action for the third text
                                },
                                child: const Text(
                                  'Stats',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const Row(
                  children: [
                    SizedBox(
                      width: 25,
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "TOP PLAYERS",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                  ],
                ),
                // Player Details
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius as needed
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(
                                  10), // Adjust the radius as needed
                            ),
                            child: DropdownButton<String>(
                              value: _selectedOption,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOption = newValue!;
                                });
                              },
                              items: _options.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(option),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          for (var i = 0; i < players.length; i++)
                            _buildPlayerRow(
                                i + 1,
                                players[i].name,
                                players[i].position,
                                players[i].points,
                                players[i].profileImage,
                                highestPoints),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(int number, String name, String position,
      double points, String profileImage, double highestPoints) {
    Color pointsColor = points == highestPoints ? Colors.green : Colors.orange;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerDetails()),
          );
        },
        child: Row(
          children: [
            Text(
              '$number',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 20,
            ),
            CircleAvatar(
              backgroundImage: AssetImage(profileImage),
              radius: 20,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    position,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: pointsColor,
                borderRadius: BorderRadius.circular(
                    10), // Adjust the radius to change the curvature
              ),
              child: Text(
                '$points',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  final String name;
  final String position;
  final double points; // Change the type to double
  final String profileImage;

  Player({
    required this.name,
    required this.position,
    required this.points,
    required this.profileImage,
  });
}
