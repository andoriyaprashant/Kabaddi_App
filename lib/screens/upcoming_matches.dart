import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MaterialApp(home: Upcoming()));
}

class Match {
  String team1Name;
  String team1Logo;
  String team2Name;
  String team2Logo;
  String matchNumber;
  String matchTime;
  String matchDate;

  Match({
    required this.team1Name,
    required this.team1Logo,
    required this.team2Name,
    required this.team2Logo,
    required this.matchNumber,
    required this.matchTime,
    required this.matchDate,
  });
}

// ignore: must_be_immutable
class Upcoming extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  Upcoming({Key? key});

  List<Match> matches = [
    Match(
      team1Name: 'Danbang Delhi K.C',
      team1Logo: 'images/danbang.png',
      team2Name: 'Jaipur Pink Panters',
      team2Logo: 'images/jaipur.png',
      matchNumber: '62',
      matchTime: '19:00',
      matchDate: 'October 18 2024',
    ),
    Match(
      team1Name: 'Haryana Steelers',
      team1Logo: 'images/tamilThalaivas.png',
      team2Name: 'Gujarat Giants',
      team2Logo: 'images/gujarat.png',
      matchNumber: '63',
      matchTime: '20:30',
      matchDate: 'October 18 2024',
    ),
    Match(
      team1Name: 'Bangaluru Bulls',
      team1Logo: 'images/bengaluru.png',
      team2Name: 'Bengal Warriors',
      team2Logo: 'images/bengal.png',
      matchNumber: '64',
      matchTime: '19:30',
      matchDate: 'October 19 2024',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Group matches by date
    Map<String, List<Match>> groupedMatches = {};
    for (var match in matches) {
      if (groupedMatches.containsKey(match.matchDate)) {
        groupedMatches[match.matchDate]!.add(match);
      } else {
        groupedMatches[match.matchDate] = [match];
      }
    }

    return ListView(
      shrinkWrap: true,
      children: groupedMatches.entries.map((entry) {
        return _buildMatchGroup(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildMatchGroup(String matchDate, List<Match> matches) {
    return Container(
      color: const Color(0xFFfc5607),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                matchDate,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Column(
              children: matches.map((match) {
                return _buildMatchContainer(match);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchContainer(Match match) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      match.team1Logo,
                      height: 70,
                      width: 70,
                    ),
                    Text(
                      match.team1Name,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  "Match ${match.matchNumber}\n ${match.matchTime}\n  IST",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      match.team2Logo,
                      height: 70,
                      width: 70,
                    ),
                    Text(
                      match.team2Name,
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
